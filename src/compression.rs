use crate::*;
use std::collections::{HashSet,HashMap,BinaryHeap};
use std::fmt::{self, Formatter, Display};
use clap::Parser;
use std::path::PathBuf;
use std::hash::Hash;
use std::cmp::Ordering;
use itertools::Itertools;

const FHOLE_STR: &str = "_f";
const XHOLE_STR: &str = "_x";
const HOLE_STR: &str = "_";

/// Args for compression
#[derive(Parser, Debug)]
#[clap(name = "Dream Egg")]
pub struct CompressionArgs {
    /// json file to read compression input programs from
    #[clap(short, long, parse(from_os_str), default_value = "data/train_19.json")]
    pub file: PathBuf,

    /// Number of iterations to run compression for
    #[clap(short, long, default_value = "3")]
    pub iterations: usize,

    /// max arity of inventions
    #[clap(short='a', long, default_value = "2")]
    pub max_arity: usize,

    /// beam size
    // #[clap(short, long, default_value = "10000000")]
    // beam_size: usize,

    /// disable caching
    #[clap(long)]
    pub no_cache: bool,

    /// whether to render the inventions
    #[clap(long)]
    pub render_inventions: bool,

    /// render the final egraph
    #[clap(long)]
    pub render_final: bool,

    /// render initial egraph
    #[clap(long)]
    pub render_initial: bool,

    /// number of inventions to print - set to 0 if you dont want to print inventions at all
    #[clap(long, default_value="0")]
    pub print_inventions: usize,
}

/// nonterminals ("app" and "lam") cost 1/100th of a terminal ("var", "ivar", "prim"). This is because nonterminals
/// can be autofilled based on the type of the hole you're filling during most search methods.
const COST_NONTERMINAL: i32 = 1;
const COST_TERMINAL: i32 = 100;

type EGraph = egg::EGraph<Lambda, LambdaAnalysis>;

/// The analysis data associated with each Lambda node
#[derive(Debug)]
pub struct Data {
    free_vars: HashSet<i32>, // $i vars. For example (lam $2) has free_vars = {1}.
    free_ivars: HashSet<i32>, // #i ivars
    inventionless_cost: i32,
}

/// An invention we've found (ie a learned function we can use to compress the program).
/// Inventions have a body + an arity
#[derive(Debug, Clone, Copy, Eq, PartialEq, Hash)]
pub struct Invention {
    body:Id, // this will be a subtree which can have IVars
    arity: usize // also equal to max ivar in subtree + 1
}

/// At the end of the day we convert our Inventions into InventionExprs to make
/// them standalone without needing to carry the EGraph around to figure out what
/// the body Id points to.
#[derive(Debug, Clone)]
pub struct InventionExpr {
    body: Expr, // invention body (not wrapped in lambdas)
    arity: usize
}

impl Display for InventionExpr {
    fn fmt(&self, f: &mut Formatter) -> fmt::Result {
        write!(f, "(arity={}: {})", self.arity, self.body)
    }
}

impl Invention {
    fn new(body:Id, arity: usize) -> Invention {
        Invention { body, arity }
    }
    // fn canonicalize(&mut self, egraph: &EGraph) {
    //     self.body = egraph.find(self.body);
    // }
    fn is_canonical(&self, egraph: &mut EGraph) -> bool {
        self.body == egraph.find(self.body)
    }
    fn valid_invention(&self, egraph: &EGraph) -> bool {
        // even invalid Inventions are important as parts of AppLams that will propagate recursively upward,
        // This checks that there aren't any upward refs that go beyond the args of the AppLam itself
        // egraph[self.body].data.free_vars.iter().all(|i| *i < (self.arity as i32))
        egraph[self.body].data.free_vars.is_empty()
    }
    fn to_expr(&self, egraph: &EGraph) -> InventionExpr {
        // wrap body in lambdas
        let expr = extract(self.body, &egraph);
        InventionExpr {body: expr, arity:self.arity}
    }
}

/// An AppLam is an applied lambda, so in lambda calculus it would look like (app (lam ...) ...)
/// The lambda's body is in the `inv: Invention` field.
/// 
/// Note that this actually captures multiarg applams. The first argument .args[0] corresponds to
/// the #0 free ivar in the body. This means technically if you were to write out what a 2-arg applam
/// might look like it would be (app (app (lam (lam ...)) arg1) arg0) which is a bit backwards
/// from what you might expect (but think about where a $0 would point and it makes sense)
/// 
/// But in reality there are no apps and no lams, everything is implicitly captured in the AppLam. The
/// Invention does NOT have a lam() at the top.
#[derive(Debug, Clone)]
struct AppLam {
    inv: Invention,
    args: Vec<Id>, // these should be (possibly shifted) subtrees of the original tree. No IVars.
}

impl AppLam {
    fn new(body: Id, args: Vec<Id>) -> AppLam {
        AppLam {
            inv: Invention::new(body, args.len()),
            args: args,
        }
    }
    // fn canonicalize(&mut self, egraph: &mut EGraph) {
    //     self.inv.canonicalize(egraph);
    //     for arg in &mut self.args {
    //         if !canonical(arg, egraph) {
    //             *arg = egraph.find(*arg);
    //         }
    //     }
    // }
    fn is_canonical(&self, egraph: &mut EGraph) -> bool {
        self.inv.is_canonical(egraph) &&
        self.args.iter().all(|arg| canonical(arg, egraph))
    }
    /// unions together all the upward refs of body + args to get the free variables of this applam
    fn free_vars(&self, egraph: &mut EGraph) -> HashSet<i32> {
        let mut free_vars: HashSet<i32> = egraph[self.inv.body].data.free_vars.clone();
        for arg in self.args.iter() {
            free_vars.extend(egraph[*arg].data.free_vars.clone());
        }
        free_vars
    }
    fn to_string(&self, egraph: &EGraph) -> String {
        format!("inv:{}\narg:{}",
            self.inv.to_expr(egraph),
            self.args.iter().map(|arg| extract(*arg, egraph).to_string()).collect::<Vec<_>>().join("\narg:")
        )
    }

}

/// There will be one of these structs associated with each node, and it keeps
/// track of the best inventions for that node.
#[derive(Debug,Clone)]
struct BestInventions {
    inventionless_cost: i32,
    inventionful_cost: HashMap<Invention, i32>,
}

impl BestInventions {
    fn new(inventionless_cost: i32) -> BestInventions {
        BestInventions {
            inventionless_cost: inventionless_cost,
            inventionful_cost: HashMap::new()
        }
    }
    /// cost under an invention if it's useful for this node, else inventionless cost
    fn cost_under_inv(&self, inv: &Invention) -> i32 {
        self.inventionful_cost.get(inv).cloned().unwrap_or(self.inventionless_cost)
    }
    /// improve the cost using a new invention, or do nothing if we've already seen
    /// a better cost for this invention. Also skip if inventionless cost is better.
    fn new_cost_under_inv(&mut self, inv: Invention, cost:i32) {
        if cost < self.inventionless_cost {
            if !self.inventionful_cost.contains_key(&inv)
               || cost < self.inventionful_cost[&inv]  {
                self.inventionful_cost.insert(inv, cost);
            }
        }
    }
    /// Get the top inventions in decreasing order of cost
    fn top_inventions(&self) -> Vec<Invention> {
        let mut top_inventions: Vec<Invention> = self.inventionful_cost.keys().cloned().collect();
        top_inventions.sort_by(|a,b| self.inventionful_cost[a].cmp(&self.inventionful_cost[b]));
        top_inventions
    }
}

/// convert an egraph Id to an Expr. Assumes one node per class (just picks the first node). Note
/// that this could cause an infinite loop if the egraph didnt just have a single node in a class
/// and instead the first node had a self loop.
fn extract(eclass: Id, egraph: &EGraph) -> Expr {
    debug_assert!(egraph[eclass].nodes.len() == 1);
    match &egraph[eclass].nodes[0] {
        Lambda::Prim(p) => Expr::prim(*p),
        Lambda::Var(i) => Expr::var(*i),
        Lambda::IVar(i) => Expr::ivar(*i),
        Lambda::App([f,x]) => Expr::app(extract(*f,egraph), extract(*x,egraph)),
        Lambda::Lam([b]) => Expr::lam(extract(*b,egraph)),
        Lambda::Programs(roots) => Expr::programs(roots.iter().map(|r| extract(*r,egraph)).collect()),
    }
}

/// like extract() but works on nodes
fn extract_enode(enode: &Lambda, egraph: &EGraph) -> Expr {
    match enode {
        Lambda::Prim(p) => Expr::prim(*p),
        Lambda::Var(i) => Expr::var(*i),
        Lambda::IVar(i) => Expr::ivar(*i),
        Lambda::App([f,x]) => Expr::app(extract(*f,egraph),extract(*x,egraph)),
        Lambda::Lam([b]) => Expr::lam(extract(*b,egraph)),
        _ => {panic!("not rendered")},
    }
}

/// Extracts an expression under an invention. This rewrites the expression to use the invention
/// if it decreases the cost.
/// 
/// todo The current implementation requires the results of the full compression search, however
/// it should be possible to do this in a much more efficient way that works even on things
/// that weren't part of the original set of expressions. That would be easy with no HOFs and
/// might be more difficult with HOFs but is probably still possible
fn extract_under_inv(
    root: Id,
    inv: Invention,
    replace_inv_with: &str,
    applams_of_treenode: &HashMap<Id,Vec<AppLam>>,
    best_inventions_of_treenode: &HashMap<Id,BestInventions>,
    egraph: &EGraph,
) -> Expr {
    let root = egraph.find(root);
    let target_cost:i32 = best_inventions_of_treenode[&root].cost_under_inv(&inv);

    if best_inventions_of_treenode[&root].inventionful_cost.contains_key(&inv)
       && applams_of_treenode[&root].iter().any(|applam| applam.inv == inv) {
        let applam: Vec<AppLam> = applams_of_treenode[&root].iter().filter(|applam| applam.inv == inv).cloned().collect();
        assert!(applam.len() == 1);
        let applam = &applam[0];
        let mut expr = Expr::prim(replace_inv_with.into());
        // wrap the new primitive in app() calls. Note that you pass in the $0 args LAST given how appapplamlam works
        for arg in applam.args.iter().rev() {
            let arg_expr = extract_under_inv(*arg, inv, replace_inv_with, applams_of_treenode, best_inventions_of_treenode, egraph);
            expr = Expr::app(expr,arg_expr);
        }
        assert_eq!(target_cost,expr.cost());
        return expr
    }
    
    assert!(egraph[root].nodes.len() == 1);
    let expr: Expr = match &egraph[root].nodes[0] {
        Lambda::Prim(p) => {
            Expr::prim(*p)
        },
        Lambda::Var(i) => {
            Expr::var(*i)
        },
        Lambda::IVar(_) => {
            panic!("Shouldn't be extracting an IVar under an invention")
            //into_expr.add(Lambda::IVar(*i))
        },
        Lambda::App([f,x]) => {
            let f_expr = extract_under_inv(*f, inv, replace_inv_with, applams_of_treenode, best_inventions_of_treenode, egraph);
            let x_expr = extract_under_inv(*x, inv, replace_inv_with, applams_of_treenode, best_inventions_of_treenode, egraph);
            Expr::app(f_expr,x_expr)
        },
        Lambda::Lam([b]) => {
            let b_expr = extract_under_inv(*b, inv, replace_inv_with, applams_of_treenode, best_inventions_of_treenode, egraph);
            Expr::lam(b_expr)
        }
        Lambda::Programs(roots) => {
            let root_exprs: Vec<Expr> = roots.iter()
                .map(|r| extract_under_inv(*r, inv, replace_inv_with, applams_of_treenode, best_inventions_of_treenode, egraph))
                .collect();
            Expr::programs(root_exprs)
        }
    };

    assert_eq!(target_cost,expr.cost());
    expr
}


#[inline]
fn canonical(id:&Id, egraph: &EGraph) -> bool {
    egraph.find(*id) == *id
}

/// Narrows a beam. Not actually used currently since Invention beam size wasn't an issue at all (AppLam was
/// but it's way less clear how to narrow that beam)
fn narrow_beam(beam: &mut HashMap<Invention,i32>, beam_size: usize) {
    if beam.len() < beam_size {
        return
    }
    // println!("Need to narrow beam! (worth turning this print message off if it ever actually prints)");
    let num_to_drop = beam_size - beam.len();
    let mut costs: Vec<(Invention,i32)> = beam.iter().map(|(id,cost)|(*id,*cost)).collect();
    // DECREASING order of cost (since i do cost2.cmp(cost1))
    costs.sort_by(|(_,cost1),(_,cost2)| cost2.cmp(cost1));
    for (id,_) in costs.iter().take(num_to_drop) {
        beam.remove(id);
    }
}

#[derive(Default)]
pub struct LambdaAnalysis;

impl Analysis<Lambda> for LambdaAnalysis {
    type Data = Data;
    fn merge(&self, to: &mut Data, from: Data) -> bool {
        // we really shouldnt be merging anyone ever rn I think.
        panic!("shouldn't be merging");

        assert_eq!(to.free_vars,from.free_vars);
        assert_eq!(to.free_ivars,from.free_ivars);
        assert_eq!(to.inventionless_cost,from.inventionless_cost);

        // keep the lowest inventionless cost
        // modified |= merge_inventionless(&mut to.inventionless_cost_any, &from.inventionless_cost_any);
        
        false // didnt modify anything
    }

    fn make(egraph: &EGraph, enode: &Lambda) -> Data {
        let mut free_vars: HashSet<i32> = HashSet::new();
        let mut free_ivars: HashSet<i32> = HashSet::new();
        match enode {
            Lambda::Var(i) => {
                free_vars.insert(*i);
            }
            Lambda::IVar(i) => {
                free_ivars.insert(*i);
            }
            Lambda::Prim(_) => {
            }
            Lambda::App([f, x]) => {
                // union of f and x
                free_vars.extend(egraph[*f].data.free_vars.iter());
                free_vars.extend(egraph[*x].data.free_vars.iter());
                free_ivars.extend(egraph[*f].data.free_ivars.iter());
                free_ivars.extend(egraph[*x].data.free_ivars.iter());
            }
            Lambda::Lam([b]) => {
                // body, subtract 1 from all values, remove the -1 if its in there
                free_vars.extend(egraph[*b].data.free_vars.iter()
                    .map(|x| x-1)
                    .filter(|x| *x >= 0));
                free_ivars.extend(egraph[*b].data.free_ivars.iter());
            }
            Lambda::Programs(programs) => {
                // assert no free variables in programs
                assert!(programs.iter().all(|p| egraph[*p].data.free_vars.is_empty()));
                assert!(programs.iter().all(|p| egraph[*p].data.free_ivars.is_empty()));
            }
        }
        let inventionless_cost = match enode {
            Lambda::Var(_) | Lambda::IVar(_) | Lambda::Prim(_) => COST_TERMINAL,
            Lambda::App([f,x]) => {
                    COST_NONTERMINAL
                    + egraph[*f].data.inventionless_cost
                    + egraph[*x].data.inventionless_cost
                }
            Lambda::Lam([b]) => {
                COST_NONTERMINAL + egraph[*b].data.inventionless_cost
            }
            Lambda::Programs(ps) => {
                ps.iter().map(|p| egraph[*p].data.inventionless_cost).sum()
            }
        };
        Data {
               free_vars: free_vars,
               free_ivars: free_ivars,
               inventionless_cost: inventionless_cost
            }
    }

    fn modify(_egraph: &mut EGraph, _id: Id) {
    }
}


/// Does debruijn index shifting of a subtree. Note that the type of shifting is specified by
/// the `shift` argument.
/// 
/// Shift variants:
/// * ShiftVar(i32) -> increment all free variables by the given amount
/// * ShiftIVar(i32) -> increment all ivars by given amount
/// * TableShiftIVar(Vec<i32>) -> increment ivar #i by the amount given by table[i]
#[inline] // useful to inline since callsite can usually tell which Shift type is happening allowing further optimization
fn shift(e: Id, shift: Shift, egraph: &mut EGraph, caches: Option<&mut CacheGenerator>) -> Option<Id> {
    let mut empty = HashMap::new();
    let seen = match caches {
        Some(caches) => caches.get(&shift),
        None => &mut empty,
    };
    match shift {
        Shift::ShiftVar(incr_by) => recursive_var_mod(
            |actual_idx, _depth, _which_upward_ref, egraph| {
                Some(egraph.add(Lambda::Var(actual_idx + incr_by)))
            },
            false, // operate on Vars
            e,egraph,seen
        ),
        Shift::ShiftIVar(incr_by) => recursive_var_mod(
            |actual_idx, _depth, _which_upward_ref, egraph| {
                // note this is IVars so depth and which_upward_ref are meaningless to us
                Some(egraph.add(Lambda::IVar(actual_idx + incr_by)))
            },
            true, // operate on IVars
            e,egraph,seen
        ),
        Shift::TableShiftIVar(shift_table) => recursive_var_mod(
            |actual_idx, _depth, _which_upward_ref, egraph| {
                // shift variable up or down whatever the shift table says it should be
                // note this is IVars so depth and which_upward_ref are meaningless to us
                Some(egraph.add(Lambda::IVar(actual_idx + shift_table[actual_idx as usize])))
            },
            true, // operate on IVars
            e,egraph,seen
        )
    }
}



// not used in the new verison but should be compatible with everything we've got!
// fn inline(e: Id, replace_with: Id, egraph: &mut EGraph, seen: &mut RecVarModCache) -> Option<Id> {
//     recursive_var_mod(
//         |actual_idx, depth, which_upward_ref, egraph| {
//             if which_upward_ref == 0 {
//                 // ShifterVM { incr_by: depth }.recursive_var_mod(replace_with, egraph)
//                 shift(replace_with, depth, egraph, None) // note i have it just make a new hashmap on the spot for this, caching would be better
//             } else {
//                 // we need to decrement this by 1 since its a pointer above the lambda we removed
//                 Some(egraph.add(Lambda::Var(actual_idx - 1)))
//             }
//         },
//         e,egraph, seen
//     )
// }

/// This is a helper function for implementing various recursive operations that only
/// modify Var or IVar constructs (use `ivars=true` to run this on all ivars). Just provide
/// a function that you want to call on each Var to determine what to replace it with. The function
/// signature should be `(actual_idx, depth, which_upward_ref, egraph) -> Option<Id>`.
/// 
/// We recurse over the full graph rooted at `eclass` and replace any `Var` (or `IVar` if `ivars=true`)
/// with the result of calling the function with:
/// * `actual_idx`: if we're matching on Var(i) this is i
/// * `depth`: how many Lamdas are between this Var and the original toplevel eclass this was called on
/// * `which_upward_ref`: this is just actual_idx-depth
/// * `egraph`: the EGraph we're operating on
/// 
/// Note that we wont touch any branches of the tree that dont have free variables with respect to the toplevel,
/// so this will never be called on some Var(i) if it is not considered a free variable in `eclass` as a whole.
/// 
/// This function is fairly efficient. We cache both within and between calls to it, it uses
/// the enode data that tells us if there are no free variables in a branch (and thus it can be ignored),
/// it operates on the structurally hashed form of the graph, etc.
fn recursive_var_mod(
    var_mod: impl Fn(i32, i32, i32, &mut EGraph) -> Option<Id>,
    ivars: bool,
    eclass:Id,
    egraph: &mut EGraph,
    seen: &mut RecVarModCache
    ) -> Option<Id>
    {
        recursive_var_mod_helper(
            &var_mod,
            ivars,
            eclass,
            0,
            egraph,
            seen,
        )
}

/// see `recursive_var_mod`
fn recursive_var_mod_helper(
    var_mod: &impl Fn(i32, i32, i32, &mut EGraph) -> Option<Id>,
    ivars: bool, // whether to run this on vars or ivars
    eclass:Id,
    depth: i32,
    egraph: &mut EGraph,
    seen : &mut RecVarModCache,
    ) -> Option<Id>
    {
        // important invariant for ivars=false case: a $i with i==depth would be a $0 pointer at the top level
        // meaning i<depth is an internal pointer that doesnt break the top level
        let eclass = egraph.find(eclass);
        let key = (eclass,depth);

        if seen.contains_key(&key) {
            return seen[&key];
        }

        if  (ivars && egraph[eclass].data.free_ivars.is_empty())
        || (!ivars && egraph[eclass].data.free_vars.iter().all(|i| *i < depth)) {
            // if we're replacing ivars and theres no ivars in this subtree, we can return early
            // if we're replacing vars, from our invariant (above) we know i<depth is an internal pointer that doesnt point out of the top level so again we can return early
            seen.insert(key, Some(eclass));
            return Some(eclass)
        }

        // this is for loop breaking (though there shouldnt be loops in my new DAG setup anyways)
        seen.insert(key, None);
        
        // if you want a multiple-node-per-eclass version of this that unions together the stuff from diff branches, see my old code!
        assert!(egraph[eclass].nodes.len() == 1);
        // clone to appease the borrow checker
        let enode = egraph[eclass].nodes[0].clone();

        let new_eclass = match enode {
            Lambda::Var(i) => {
                if ivars {
                    panic!("unreachable, Var doesnt have free IVars")
                }
                assert!(i >= depth); // otherwise we should have returned earlier
                // by our invariant be have i-depth as the toplevel version of this index
                var_mod(i, depth, i-depth, egraph)
            }
            Lambda::IVar(i) => {
                if !ivars {
                    panic!("unreachable, IVar doesnt have free Vars")
                }
                var_mod(i, depth, i-depth, egraph)
            }
            Lambda::Prim(_) => {
                panic!("unreachable, Prim never has free vars/ivars")
            }
            Lambda::App([f, x]) => {
                // recurse in each (class shift will return early if no shifting is needed) and build a new App
                let fnew_opt = recursive_var_mod_helper(var_mod, ivars, f, depth, egraph, seen);
                let xnew_opt = recursive_var_mod_helper(var_mod, ivars, x, depth, egraph, seen);
                match (fnew_opt,xnew_opt) {
                    (Some(fnew),Some(xnew)) => Some(egraph.add(Lambda::App([fnew, xnew]))),
                    _ => None,
                }
            }
            Lambda::Lam([b]) => {
                // increment depth
                recursive_var_mod_helper(var_mod, ivars, b, depth+1, egraph, seen)
                .map(|bnew| egraph.add(Lambda::Lam([bnew])))
            }
            Lambda::Programs(_) => {
                panic!("attempted to shift a Programs node")
            }
        };

        if let Some(new_eclass) = new_eclass {
            let new_eclass = egraph.find(new_eclass);
            seen.insert(key, Some(new_eclass));
            Some(new_eclass)
        } else {
            None
        }
}


/// the cost of a program, where `app` and `lam` cost 1, `programs` costs nothing,
/// `ivar` and `var` and `prim` cost 100.
pub struct ProgramCost {}
impl CostFunction<Lambda> for ProgramCost {
    type Cost = i32;
    fn cost<C>(&mut self, enode: &Lambda, mut costs: C) -> Self::Cost
    where
        C: FnMut(Id) -> Self::Cost
    {
        match enode {
            Lambda::Var(_) | Lambda::IVar(_) | Lambda::Prim(_) => COST_TERMINAL,
            Lambda::App([f, x]) => {
                COST_NONTERMINAL + costs(*f) + costs(*x)
            }
            Lambda::Lam([b]) => {
                COST_NONTERMINAL + costs(*b)
            }
            Lambda::Programs(ps) => {
                ps.iter()
                .map(|p|costs(*p))
                .sum()
            }
        }
    }
}

/// depth of a program. For example a leaf is depth 1.
pub struct ProgramDepth {}
impl CostFunction<Lambda> for ProgramDepth {
    type Cost = i32;
    fn cost<C>(&mut self, enode: &Lambda, mut costs: C) -> Self::Cost
    where
        C: FnMut(Id) -> Self::Cost
    {
        match enode {
            Lambda::Var(_) | Lambda::IVar(_) | Lambda::Prim(_) => 1,
            Lambda::App([f, x]) => {
                1 + std::cmp::max(costs(*f), costs(*x))
            }
            Lambda::Lam([b]) => {
                1 + costs(*b)
            }
            Lambda::Programs(ps) => {
                ps.iter()
                .map(|p|costs(*p))
                .max().unwrap()
            }
        }
    }
}


/// does a child first traversal of the egraph and returns a Vec<Id> in that
/// order. Notably an Id will never show up twice (if it showed up earlier
/// it wont show up again). Assumes no cycles in the EGraph.
fn toplogical_ordering(root: Id, egraph: &EGraph) -> Vec<Id> {
    let mut vec = Vec::new();
    toplogical_ordering_rec(root, egraph, &mut vec);
    vec
}

/// see `toplogical_ordering`
fn toplogical_ordering_rec(root: Id, egraph: &EGraph, vec: &mut Vec<Id>) {
    // assumes no cycles.
    // we require at this point that all eclasses only have ONE enode
    assert!(egraph[root].nodes.len() == 1);
    for child in egraph[root].nodes[0].children(){
        toplogical_ordering_rec(*child, egraph, vec);
    }
    if !vec.contains(&root) {
        // if we're already a child of someone else earlier we dont need to be readded
        vec.push(root);
    }
}

/// cache for shift()
type RecVarModCache = HashMap<(Id,i32),Option<Id>>;

/// types of debruijn index shifts.
/// * ShiftVar(i32) -> increment all free variables by the given amount
/// * ShiftIVar(i32) -> increment all ivars by given amount
/// * TableShiftIVar(Vec<i32>) -> increment ivar #i by the amount given by table[i]
#[derive(Debug,Clone,Eq,PartialEq,Hash)]
enum Shift {
    ShiftVar(i32), // shift $i to be $(i+incr_by)
    ShiftIVar(i32), // shift #i to be #(i+incr_by)
    TableShiftIVar(Vec<i32>), // shift #i to be #(i+table[#i]) ie look up the shift amount in the table
}

/// generates caches for shift()
struct CacheGenerator {
    caches: HashMap<Shift,RecVarModCache>,
    enabled: bool,
}
impl CacheGenerator {
    fn new(enabled: bool) -> CacheGenerator {
        CacheGenerator { caches: Default::default(), enabled: enabled }
    }
    fn get(&mut self, context: &Shift) -> &mut RecVarModCache {
        if !self.enabled {
            // wipe the cache before returning it
            self.caches.insert(context.clone(),Default::default());
         }
        if !self.caches.contains_key(&context) {
            self.caches.insert(context.clone(),Default::default());
        } 
        self.caches.get_mut(&context).unwrap()
    }
}


#[inline(always)]
fn build_shift_table(applam_shift: &AppLam, applam_noshift: &AppLam) -> (Vec<i32>, Vec<Id>) {
    let mut shift_table = vec![]; // just gonna assume nobody wants an arity greater than 10 (for static speed)
    let mut to_remove = vec![];
    let mut shift_rest_by = applam_noshift.inv.arity as i32; // normal amt we shift x by, except if there are merges to be done. If a merge happens all the higher x vars get shifted less, and the specific x var gets shifted a very specific amount
    for (x_idx,xarg) in applam_shift.args.iter().enumerate() {
        if let Some(f_idx) = applam_noshift.args.iter().position(|farg| farg == xarg) {
            // we found a match! $x_idx should map to the same thing as $f_idx.
            // remember, our body currently has $x_idx at the toplevel so now
            // we want to shift it by $(f_idx-x_idx) so that it ends up as f_idx.
            shift_table.push((f_idx as i32) - (x_idx as i32));
            to_remove.push(true);
            shift_rest_by -= 1; // effectively downshifts all the higher args now that this one is gone
        } else {
            // shift fully without merging
            shift_table.push(shift_rest_by);
            to_remove.push(false);
        }
    }

    // remove the args from xargs that we can merge into fargs
    let new_x_applam_args: Vec<Id> = applam_shift.args.iter()
        .zip(to_remove)
        .filter(|(_,remove)| !*remove)
        .map(|(xarg,_)| xarg)
        .cloned().collect();
    
    let mut new_applam_args = applam_noshift.args.clone();
    new_applam_args.extend(new_x_applam_args);
    (shift_table, new_applam_args)
}




/// A node in an Zipper
/// Ord: Func < Body < Arg
// #[derive(Debug, Clone, Eq, PartialEq, Hash, PartialOrd, Ord)]
// enum ZNode {
//     // * order of variants here is important because the derived Ord will use it
//     Func(Id), // zipper went into the function, so Id is the arg
//     Body, 
//     Arg(Id), // zipper went into the arg, so Id is the function
// }

/// A node in an Zipper
/// Ord: Func < Body < Arg
#[derive(Debug, Clone, Eq, PartialEq, Hash, PartialOrd, Ord)]
enum ZNode {
    // * order of variants here is important because the derived Ord will use it
    Func, // zipper went into the function, so Id is the arg
    Body, 
    Arg, // zipper went into the arg, so Id is the function
}

type ZId = usize; // zipper id
type InvId = usize;
type ZPath = Vec<ZNode>;

/// a 1 arg invention
// #[derive(Debug, Clone, Eq, PartialEq, Hash, PartialOrd, Ord)]
// struct Zipper {
//     nodes: Vec<ZNode>
// }

/// a 1 arg invention
#[derive(Debug, Clone, Eq, PartialEq, Hash, PartialOrd, Ord)]
struct Zipper {
    path: ZPath,
    left: Vec<Option<Id>>,
    right: Vec<Option<Id>>,
}


/// a 1 arg applied invention
#[derive(Debug,Clone, Eq, PartialEq, Hash)]
struct AppZipper {
    zipper: Zipper,
    arg: Id,
}

#[derive(Debug,Clone, Eq, PartialEq, Hash, PartialOrd, Ord)]
struct ZTupleElem {
    zid: ZId,
    ivar: usize // which #i argument this is, which also corresponds to args[i] ofc
}

/// a multiarg multiuse invention
#[derive(Debug,Clone, Eq, PartialEq, Hash, PartialOrd, Ord)]
struct ZTuple {
    elems: Vec<ZTupleElem>,
    divergence_idxs: Vec<usize>,
    multiarg: Vec<ZId>, // len=arity, gives the first zid added for each arg
    multiuse: Vec<ZId>, // gives the 2nd and onward zids added for each arg (not the first, thats in multiarg)
    arity: usize,
}

/// a multiarg multiuse invention applied
#[derive(Debug,Clone, Eq, PartialEq, Hash)]
struct AppZTuple {
    ztuple: ZTuple,
    args: Vec<Id>,
}

// can add upper bound utility and such here later too
struct WorklistItem {
    ztuple: ZTuple,
    nodes: Vec<Id>, // nodes in the group
    left_utility: i32, // utility of a single usage
    utility_upper_bound: i32, // upper bound utility over all usages
}

// can add upper bound utility and such here later too
struct FinishedItem {
    ztuple: ZTuple,
    nodes: Vec<Id>, // nodes in the group
    utility: i32,
}


impl Zipper {
    fn new(path: ZPath, left: Vec<Option<Id>>, right: Vec<Option<Id>> ) -> Zipper {
        Zipper { path, left, right }
    }

    // fn to_expr(&self, egraph: &EGraph) -> Expr {
    //     self.path.iter().rev().fold(Expr::ivar(ivar_idx), |acc,node| {
    //         match node {
    //             ZNode::Func => Expr::app(acc, Expr::prim(HOLE_STR.into())),
    //             ZNode::Arg => Expr::app(Expr::prim(HOLE_STR.into()), acc),
    //             ZNode::Body => Expr::lam(acc),
    //         }
    //     })
    // }


    // fn free_vars(&self, egraph: &EGraph) -> HashSet<i32> {
    //     let mut free_vars: HashSet<i32> = Default::default();
    //     let mut depth:i32 = 0;
    //     for node in self.nodes.iter() {
    //         match node {
    //             ZNode::Func(o) | ZNode::Arg(o) => {
    //                 free_vars.extend(egraph[*o].data.free_vars.iter()
    //                 .filter_map(|fv|
    //                     if *fv >= depth {Some(fv-depth)} else {None}));
    //             }
    //             ZNode::Body => {
    //                 depth += 1;
    //             }
    //         }
    //     }
    //     free_vars
    // }
}

impl AppZipper {
    fn new(zipper: Zipper, arg: Id) -> AppZipper {
        AppZipper { zipper: zipper, arg: arg }
    }
    #[inline]
    fn clone_prepend(&self, new: ZNode, id: Option<Id>) -> AppZipper {
        let mut appzipper: AppZipper = self.clone();
        match new {
            ZNode::Func => {
                assert!(id.is_some());
                appzipper.zipper.left.insert(0,None);
                appzipper.zipper.right.insert(0,id);
            },
            ZNode::Arg => {
                assert!(id.is_some());
                appzipper.zipper.left.insert(0,id);
                appzipper.zipper.right.insert(0,None);
            },
            ZNode::Body => {
                assert!(id.is_none());
                appzipper.zipper.left.insert(0,None);
                appzipper.zipper.right.insert(0,None);        
            },
        }
        appzipper.zipper.path.insert(0,new);
        appzipper
    }
}

impl ZTupleElem {
    fn new(zid: ZId, ivar: usize) -> ZTupleElem {
        ZTupleElem { zid: zid, ivar: ivar }
    }
}

impl ZTuple {
    fn new(elems: Vec<ZTupleElem>, divergence_idxs: Vec<usize>, multiarg: Vec<usize>, multiuse: Vec<usize>, arity: usize) -> ZTuple {
        ZTuple { elems, divergence_idxs, multiarg, multiuse, arity }
    }
    fn single(zid: ZId) -> ZTuple {
        ZTuple::new(vec![ZTupleElem::new(zid, 0)], vec![], vec![zid], vec![], 1)
    }
    fn extend(&self, elem: ZTupleElem, div_idx: usize, is_multiuse: bool) -> ZTuple {
        let mut res = self.clone();
        res.divergence_idxs.push(div_idx);
        if is_multiuse {
            res.multiuse.push(elem.zid);
        } else {
            res.multiarg.push(elem.zid);
            res.arity += 1;
        }
        res.elems.push(elem);
        res
    }
    fn to_expr(&self, node: Id, appzipper_of_node_zid: &HashMap<(Id,ZId),AppZipper>, egraph: &EGraph) -> Expr {
        let mut elem_idx: usize = 0;
        let mut zipper: &Zipper = &appzipper_of_node_zid[&(node,self.elems[elem_idx].zid)].zipper;
        let mut depth: usize = zipper.path.len() - 1;
        let mut expr = Expr::ivar(self.elems[elem_idx].ivar as i32);
        let mut diverged: Vec<(usize,Expr)> = vec![];

        loop {
            if elem_idx < self.divergence_idxs.len() && depth == self.divergence_idxs[elem_idx] {
                // we should diverge to the right
                assert_eq!(zipper.path[depth], ZNode::Func);
                diverged.push((depth,expr));
                elem_idx += 1;
                zipper = &appzipper_of_node_zid[&(node,self.elems[elem_idx].zid)].zipper;
                depth = zipper.path.len() - 1;
                expr = Expr::ivar(self.elems[elem_idx].ivar as i32);
                continue;
            }
            if !diverged.is_empty() && depth == diverged.last().unwrap().0 {
                // we should ignore our normal Some(f) and instead use the stored diverged expr
                assert_eq!(zipper.path[depth], ZNode::Arg);
                expr = Expr::app(diverged.pop().unwrap().1, expr);
                if depth == 0 { break }
                depth -= 1;
                continue;
            }

            // normal step upward by 1
            match (&zipper.path[depth], &zipper.left[depth], &zipper.right[depth]) {
                (ZNode::Arg, Some(f), None) => { expr = Expr::app(extract(*f,egraph), expr); },
                (ZNode::Func, None, Some(x)) => { expr = Expr::app(expr, extract(*x,egraph)); },
                (ZNode::Body, None, None) => { expr = Expr::lam(expr); },
                _ => panic!("malformed zipper"),
            }
            if depth == 0 { break }
            depth -= 1;
        }


        expr
    }
}

impl AppZTuple {
    fn new(ztuple: ZTuple, args: Vec<Id>) -> AppZTuple {
        AppZTuple { ztuple: ztuple, args: args }
    }
}

impl WorklistItem {
    fn new(ztuple: ZTuple, nodes: Vec<Id>, left_utility: i32, utility_upper_bound: i32) -> WorklistItem {
        WorklistItem { ztuple: ztuple, nodes: nodes, left_utility: left_utility, utility_upper_bound: utility_upper_bound }
    }
}

impl FinishedItem {
    fn new(ztuple: ZTuple, nodes: Vec<Id>, utility: i32) -> FinishedItem {
        FinishedItem { ztuple, nodes, utility }
    }
}











// impl AppOffZTuple {
    
//     #[inline(never)]
//     fn from_appzippers(ztuple: &ZTuple, appzippers: impl Iterator<Item=AppOffZipper>) -> AppOffZTuple
//     {
//         // assert_eq!(ztuple.elems.len(), appzippers.len());
//         let mut args: Vec<Id> = vec![];
//         let mut elems: Vec<OffZTupleElem> = ztuple.elems.iter()
//             .zip(appzippers.into_iter())
//             .map(|(elem,appzipper)| {
//                 debug_assert!(elem.arg_idx <= args.len());
//                 if elem.arg_idx == args.len() {
//                     args.push(appzipper.arg.clone());
//                 }
//                 OffZTupleElem::new(appzipper.zipper, elem.arg_idx)
//             }
//         ).collect();
//         // mask out the places where adjacent zippers block out each others off elements
//         // elems.
        
//         for (i,diverges_at) in ztuple.divergence_idxs.iter().enumerate() {
//             // mask with FuncDiverge and ArgDiverge
//             // note the jth divergence index tells you about
//             // masking elems[j] with FuncDiverge and elems[j+1] with ArgDiverge
//             elems[i].zipper.nodes[*diverges_at] = OffZNode::FuncDiverge;
//             elems[i+1].zipper.nodes[*diverges_at] = OffZNode::ArgDiverge;
//             if i > 0 {
//                 for j in i-1..=0 {
//                     // as soon as a smaller zipper diverges earlier than me, it and all subsequent zippers dont share this divergence point
//                     if ztuple.divergence_idxs[j] <= *diverges_at {
//                         break;
//                     }
//                     debug_assert!(matches!(elems[j].zipper.nodes[*diverges_at], OffZNode::Func(_)|OffZNode::FuncDiverge), "{:?}", elems[j].zipper.nodes[*diverges_at]);
//                     debug_assert!(matches!(elems[j+1].zipper.nodes[*diverges_at], OffZNode::Func(_)|OffZNode::FuncDiverge), "{:?}", elems[j+1].zipper.nodes[*diverges_at]);
//                     elems[j].zipper.nodes[*diverges_at] = OffZNode::FuncDiverge;
//                     elems[j+1].zipper.nodes[*diverges_at] = OffZNode::FuncDiverge;
//                 }
//             }
//             for j in i+1..ztuple.divergence_idxs.len() {
//                 if ztuple.divergence_idxs[j] <= *diverges_at {
//                     break
//                 }
//                 debug_assert!(matches!(elems[j].zipper.nodes[*diverges_at], OffZNode::Arg(_)|OffZNode::ArgDiverge), "{:?}", elems[j].zipper.nodes[*diverges_at]);
//                 debug_assert!(matches!(elems[j+1].zipper.nodes[*diverges_at], OffZNode::Arg(_)|OffZNode::ArgDiverge), "{:?}", elems[j+1].zipper.nodes[*diverges_at]);
//                 elems[j+1].zipper.nodes[*diverges_at] = OffZNode::ArgDiverge;
//                 elems[j+1].zipper.nodes[*diverges_at] = OffZNode::ArgDiverge;
//             }
//         }
//         AppOffZTuple::new(OffZTuple::new(elems,ztuple.arity),args)
//     }
//     #[inline(never)]
//     fn merge_multiarg(&self, appzipper: &AppOffZipper, appzipper_zid: ZId, ztuple: &ZTuple) -> Option<ZTuple> {
//         debug_assert!(self.offztuple.zippers().all(|zipper| zipper.forget() < appzipper.zipper.forget()), "not an upward merge");
//         if let Some(diverge_idx) = self.offztuple.zippers().last().unwrap().intersect_from_right(&appzipper.zipper) {
//             let mut new_ztuple: ZTuple = ztuple.clone();
//             new_ztuple.elems.push(ZTupleElem::new(appzipper_zid, ztuple.arity)); // new multiarg
//             new_ztuple.divergence_idxs.push(diverge_idx);
//             new_ztuple.arity += 1;
//             return Some(new_ztuple);
//         }
//         None
//     }
//     #[inline(never)]
//     fn merge_multiuse(&self, appzipper: &AppOffZipper, appzipper_zid: ZId, ztuple: &ZTuple) -> Option<Vec<ZTuple>> {
//         debug_assert!(self.offztuple.zippers().all(|zipper| zipper.forget() < appzipper.zipper.forget()),
//             "not an upward merge:\n{}\n\n{}\n\n{}\n{:?}\n{:?}\n{:?}\n",
//             self.offztuple.to_string_forgetful(),
//             appzipper.zipper.forget().to_expr(100),
//             appzipper_zid,
//             ztuple.zids().collect::<Vec<_>>(),
//             appzipper.zipper.forget(),
//             self.offztuple.zippers().last().unwrap().forget()
//         );
//         if !self.args.iter().any(|arg| *arg == appzipper.arg) {
//             return None // no shared arg
//         }

//         if let Some(diverge_idx) = self.offztuple.zippers().last().unwrap().intersect_from_right(&appzipper.zipper) {
//             let mut new_ztuples =  vec![];
//             for (i,_) in self.args.iter().enumerate().filter(|(_,arg)| **arg == appzipper.arg) {
//                 let mut new_ztuple: ZTuple = ztuple.clone();
//                 new_ztuple.elems.push(ZTupleElem::new(appzipper_zid, i)); // new multiuse for argument i
//                 new_ztuple.divergence_idxs.push(diverge_idx);
//                 new_ztuples.push(new_ztuple);
//                 // no bump in arity
//             }
//             return Some(new_ztuples);
//         }
//         None
//     }
// }
// impl OffZTuple {
//     /// in case you dont have and egraph and still want to print something
//     fn to_string_forgetful(&self) -> String {
//         self.elems.iter()
//             .map(|elem| elem.zipper.forget().to_expr(elem.arg_idx as i32).to_string())
//             .collect::<Vec<String>>()
//             .join("\n")
//     }
//     fn to_expr(&self, egraph: &EGraph) -> Expr {
//         fn merge(eleft: &Expr, child_left: Id, eright: &Expr, child_right: Id) -> Option<Expr> {
//             let nodeleft = eleft.get(child_left);
//             let noderight = eright.get(child_right);

//             // left can never be an FHOLE. The _f would never get merged thru right merging.
//             assert_ne!(*nodeleft, Lambda::Prim(FHOLE_STR.into()));

//             // _x & any_right -> any_right  (fine even if rhs is some sort of hole)
//             if *nodeleft == Lambda::Prim(XHOLE_STR.into()) {
//                 return Some(eright.cloned_subexpr(child_right));
//             }
//             // any_left & _f -> any_left
//             if *noderight == Lambda::Prim(FHOLE_STR.into()) {
//                 return Some(eleft.cloned_subexpr(child_left));
//             }

//             // search for place where eleft == "merge->" and eright == "<-merge"
//             match (nodeleft,noderight) {
//                 (Lambda::Lam([bl]),Lambda::Lam([br])) => {
//                     // if body merge returns None we return None, otherwise we wrap the body result in an Expr
//                     merge(eleft, *bl, eright, *br).map(|e| Expr::lam(e))
//                 }
//                 (Lambda::App([fl,xl]),Lambda::App([fr,xr])) => {
//                     // merge fl with fr and xl with xr
//                     let f = merge(eleft, *fl, eright, *fr);
//                     let x = merge(eleft, *xl, eright, *xr);
//                     if f.is_none() && x.is_none() {
//                         None
//                     } else {
//                         Some(Expr::app(
//                             f.unwrap_or_else(||eright.cloned_subexpr(*fr)), // eleft.cloned_... would be the same since `None` said theyre the same
//                             x.unwrap_or_else(||eright.cloned_subexpr(*xr))
//                         ))
//                     }
//                 }
//                 (a,b) => {
//                     assert_eq!(a,b,"\nnode types in merge dont match: {} and {} when merging:\n{}\n{}", nodeleft, noderight, eleft, eright);
//                     None
//                 },
//             }
//         }
//         let mut exprs: Vec<Expr> = self.elems.iter().map(|elem| elem.zipper.to_expr(egraph, elem.arg_idx as i32)).collect();
//         let mut expr = exprs.remove(0); // grab leftmost
//         // repeatedly merge new exprs in from the right
//         for expr_right in exprs {
//             expr = merge(&expr, expr.root(), &expr_right, expr_right.root()).unwrap();
//         }
//         expr
//     }
//     fn to_string_detailed(&self,egraph: &EGraph) -> String {
//         let exprs: Vec<Expr> = self.elems.iter().map(|elem| elem.zipper.to_expr(egraph, elem.arg_idx as i32)).collect();
//         let s: String = exprs.iter().map(|e|e.to_string()).collect::<Vec<String>>().join("\n");
//         // println!("{}", s);
//         format!("{}\nfrom:\n{}\n", self.to_expr(egraph).to_string(), s)
//     }
// }

// impl Zipper {

//     fn to_expr(&self, ivar_idx: i32) -> Expr {
//         self.nodes.iter().rev().fold(Expr::ivar(ivar_idx), |acc,node| {
//             match node {
//                 ZNode::Func => Expr::app(acc, Expr::prim(HOLE_STR.into())),
//                 ZNode::Arg => Expr::app(Expr::prim(HOLE_STR.into()), acc),
//                 ZNode::Body => Expr::lam(acc),
//             }
//         })
//     }
// }


// impl AppOffZipper {

//     fn to_string(&self,egraph: &EGraph) -> String {
//         format!("\t{} <- {} | {:?}",
//             self.zipper.to_expr(egraph, 0),
//             extract(self.arg,egraph),
//             self.zipper.forget()
//         )
//     }
// }

// impl OffZipper {
//     /// intersect two zippers, assumes other > self (ie it's coming "from the right")
//     /// and returns the index at which they diverge ie self is Func and other is Arg.
//     #[inline(never)]
//     fn intersect_from_right(&self, other: &OffZipper) -> Option<usize> {
//         debug_assert!(self.forget() < other.forget(), "not an intersect from the right");
//         // note that we cant do a .startswith check for zippers bc of divergences 

//         // lets find the place where self == Func and other == Arg
//         for (i,s) in self.nodes.iter().enumerate() {
//             let ref o = other.nodes[i]; // we assume that `o` is shorter if its a 
//             match (s,o) {
//                 (OffZNode::Func(_), OffZNode::Arg(_)) => return Some(i),
//                 // I'm not sure that these cases will ever happen, but just in case I'm ensuring that
//                 // Diverges are treated as normal things. Because the point of this function is it should
//                 // be identical to if we had .forgot() - but w the benefit of no new allocation.
//                 (OffZNode::ArgDiverge, OffZNode::Arg(_)) | (OffZNode::FuncDiverge, OffZNode::Func(_)) |
//                 (OffZNode::Arg(_), OffZNode::ArgDiverge) | (OffZNode::Func(_), OffZNode::FuncDiverge) => {},
//                 _ => {
//                     assert_eq!(s,o, "these zippers might not have come from the same origin");
//                 },
//             }
//         }
//         None // prefix case
//     }

//     fn to_expr(&self, egraph: &EGraph, ivar_idx: i32) -> Expr {
//         self.nodes.iter().rev().fold(Expr::ivar(ivar_idx), |acc,node| {
//             match node {
//                 OffZNode::Func(x) => Expr::app(acc, extract(*x,egraph)),
//                 OffZNode::FuncDiverge => Expr::app(acc, Expr::prim(XHOLE_STR.into())),
//                 OffZNode::Arg(f) => Expr::app(extract(*f,egraph), acc),
//                 OffZNode::ArgDiverge => Expr::app(Expr::prim(FHOLE_STR.into()), acc),
//                 OffZNode::Body => Expr::lam(acc),
//             }
//         })
//     }
// }








/// path down a tree. false = children[0]; true = children[1]
type ZipperZ = Vec<bool>;
type InvIdd = Id;


#[derive(Debug,Clone)]
struct AppliedInv1 {
    body: InvIdd,
    arg: Id, // from original tree modulo shifting
    zipper: ZipperZ, // useful for performing efficient merges
}

impl AppliedInv1 {
    fn new(body: InvIdd, arg: Id, zipper: ZipperZ) -> AppliedInv1 {
        AppliedInv1 { body, arg, zipper }
    }
    fn print(&self, egraph: &EGraph) {
        println!("body: {}", extract(self.body, egraph));
        println!("\targ {}", extract(self.arg, egraph));
    }
}

#[derive(Debug,Clone,Eq,PartialEq,Hash)]
struct Inv {
    multiarg_bodies: Vec<InvIdd>, // like inv1.body
    multiuse_bodies: Vec<(usize,InvIdd)> // Id is  .body, usize says which `inv` this multiuse is merged with
}
impl Inv {
    fn new(multiarg_bodies: Vec<InvIdd>, multiuse_bodies: Vec<(usize,InvIdd)>) -> Inv {
        Inv { multiarg_bodies, multiuse_bodies }
    }
    fn to_expr(&self, egraph: &EGraph) -> Expr { // todo the Vec<> bit is temporary
        let expr:Expr = extract(self.multiarg_bodies[0], egraph);
        // todo implement using zippers add them in bc theyre legit when transferred even
        expr
    }
    fn print(&self, egraph: &EGraph) {
        println!("{:?}", self);
        for e in self.multiarg_bodies.iter() {
            println!("\tmultiarg {}", extract(*e, egraph));
        }
        for e in self.multiuse_bodies.iter() {
            println!("\tmultiuse {}", extract(e.1, egraph));
        }
    }
}

#[derive(Debug, Clone)]
struct AppliedInv {
    inv: Inv,
    args: Vec<Id>,
    multiarg_zippers: Vec<ZipperZ>, // has the unique ones then the multiuse ones
    multiuse_zippers: Vec<ZipperZ>,
}
impl AppliedInv {
    fn new(inv: Inv, args: Vec<Id>, multiarg_zippers: Vec<ZipperZ>, multiuse_zippers: Vec<ZipperZ>) -> AppliedInv {
        AppliedInv { inv, args, multiarg_zippers, multiuse_zippers }
    }
    fn print(&self, egraph: &EGraph) {
        self.inv.print(egraph);
        self.args.iter().for_each(|arg| println!("\targ {}", extract(*arg, egraph)));
    }
    #[inline]
    fn zippers_interfere(&self, appinv1: &AppliedInv1) -> bool {
        // merge works if inv1.zipper is not a prefix of any of our zippers or vis versa
        // (note that the prefix case is a path towards adding higher order functions, though
        // it would take a good bit of extra work to make that work)
        self.multiarg_zippers.iter()
            .chain(self.multiuse_zippers.iter())
            .any(|z| z.starts_with(&appinv1.zipper) || appinv1.zipper.starts_with(&z)) //||
        // self.multiuses.iter().any(|(inv,_)| inv.zipper.starts_with(&inv1.zipper) || inv1.zipper.startås_with(&inv.zipper))
    }
    #[inline]
    fn merge_multiarg(&self, appinv1: &AppliedInv1, max_arity: usize) -> Option<AppliedInv> {
        if self.args.len() >= max_arity {
            return None; // would exceed arity
        }
        if self.zippers_interfere(&appinv1) {
            return None; // zipper is ancestor of other zipper
        }
        let mut new_appinv = self.clone();
        new_appinv.inv.multiarg_bodies.push(appinv1.body.clone());
        new_appinv.args.push(appinv1.arg.clone());
        new_appinv.multiarg_zippers.push(appinv1.zipper.clone());
        Some(new_appinv)
    }
    #[inline]
    fn merge_multiuse(&self, appinv1: &AppliedInv1) -> Option<Vec<AppliedInv>> {
        if !self.args.iter().any(|arg| *arg == appinv1.arg) {
            return None // no shared arg
        }
        println!("multiuse 1!!!"); // todo this is never printing!!!
        if self.zippers_interfere(&appinv1) {
            return None; // zipper is ancestor of other zipper
        }
        println!("multiuse 2!!!"); // todo this is never printing!!!
        let mut res =  vec![];
        for (i,_) in self.args.iter().enumerate().filter(|(_,arg)| **arg == appinv1.arg) {
            let mut new_appinv = self.clone();
            new_appinv.inv.multiuse_bodies.push((i,appinv1.body.clone()));
            new_appinv.multiuse_zippers.push(appinv1.zipper.clone());
            res.push(new_appinv);
            println!("multiuse 3!!!"); // todo this is never printing!!!
        }
        Some(res)
    }
    // #[inline]
    // fn cost(&self, costs: &HashMap<Id,i32>) -> i32 {
    //     COST_TERMINAL // the new primitive for this invention
    //     + COST_NONTERMINAL * self.invs.len() as i32 // the chain of app()s needed to apply the new primitive
    //     + self.invs.iter()
    //         .map(|appinv1| costs[&appinv1.arg])
    //         .sum::<i32>(); // sum costs of actual args
    // }
}

// impl PartialEq for Inv1 {
//     fn eq(&self, other: &Inv1) -> bool {
//         self.body == other.body // comparison is just based on the .body
//     }
// }
// impl Eq for Inv1 {}

// #[derive(Debug,Clone)]
// struct Inv {
//     invs: Vec<Inv1>,
// }

// #[derive(Debug,Clone)]
// struct AppliedInv {
//     inv: Inv,
//     args: Vec<Id>, // from original tree modulo shifting
// }

// struct Inv {
//     trees: Vec<Id>, // from original tree but with a single #0
//     origin: Id, // where in the original tree this was created.
//     zippers: Vec<Vec<bool>>, // alternative representation of `.trees`
// }




/// result of beta_inversions(). This struct feels pretty subject to change, it's a bit
/// of a pain to work with these _of_treenode objects.
struct InversionResult {
    applams_of_treenode: HashMap<Id,Vec<AppLam>>,
    best_inventions_of_treenode: HashMap<Id,BestInventions>
}

fn get_treenode_to_roots(roots: &Vec<Id>, egraph: &EGraph) -> HashMap<Id,Vec<Id>> {
    let mut treenode_to_roots: HashMap<Id,Vec<Id>> = Default::default();
    fn get_treenode_to_roots_rec(treenode: Id, root: Id, treenode_to_roots: &mut HashMap<Id,Vec<Id>>, egraph: &EGraph) {
        treenode_to_roots.entry(treenode).or_default().push(root);
        egraph[treenode].nodes[0].children().iter().for_each(|child| get_treenode_to_roots_rec(*child, root, treenode_to_roots, egraph));
    }
    roots.iter().for_each(|root| get_treenode_to_roots_rec(*root, *root, &mut treenode_to_roots, egraph));
    treenode_to_roots.iter_mut().for_each(|(_,roots)| {roots.sort(); roots.dedup();});
    treenode_to_roots
}

fn get_appzippers(treenodes: &[Id], no_cache:bool, egraph: &mut EGraph) -> (HashMap<Id,Vec<AppZipper>>, HashMap<Id,Id>) {
    let mut all_appzippers: HashMap<Id,Vec<AppZipper>> = Default::default();
    let caches = &mut CacheGenerator::new(!no_cache);
    
    // keys are shifted treenodes values are original treenodes. Useful since shifted ones can use same inventions as originals
    let mut remap: HashMap<Id,Id> = Default::default();

    for treenode in treenodes.iter() {
        // println!("processing id={}: {}", treenode, extract(*treenode, egraph) );

        // im essentially using the egraph just for its structural hashing rn
        assert!(egraph[*treenode].nodes.len() == 1);
        // clone to appease the borrow checker
        let node = egraph[*treenode].nodes[0].clone();

        //==================================//
        // *** PROPAGATE/CREATE APPLAMS *** //
        //==================================//
        let mut appzippers: Vec<AppZipper> = vec![];
        
        // any node can become the identity function (the empty zipper)
        appzippers.push(AppZipper::new(Zipper::new(vec![],vec![],vec![]), *treenode));

        match node {
            Lambda::IVar(_) => { panic!("attempted to abstract an IVar") }
            Lambda::Var(_) | Lambda::Prim(_) | Lambda::Programs(_) => {},
            Lambda::App([f,x]) => {
                let ref f_appzippers = all_appzippers[&f];
                let ref x_appzippers = all_appzippers[&x];

                // bubbling from the left:
                // (app f x) == (app (appzipper body arg) x) => (appzipper (app body upshift(x)) arg)
                // note no shifting is needed thanks to IVars
                for f_appzipper in f_appzippers.iter() {
                    // bubble out of function so zipper should point left so Func
                    let new: AppZipper = f_appzipper.clone_prepend(ZNode::Func,Some(x));
                    appzippers.push(new);
                }

                // bubbling from the right:
                // (app f x) == (app f (appzipper body arg)) => (appzipper (app upshift(f) body) arg)
                // note no shifting is needed thanks to IVars
                for x_appzipper in x_appzippers.iter() {
                    // bubble out of arg so zipper should point right so Arg
                    let new: AppZipper = x_appzipper.clone_prepend(ZNode::Arg,Some(f));
                    appzippers.push(new);
                }
            },
            Lambda::Lam([b]) => {
                let ref b_appzippers = all_appzippers[&b];
                // bubbling up over the lambda:
                // (lam b) == (lam (appzipper body arg)) => (appzipper (lam body) downshift(arg))
                // where:
                //  - arg must not have any upward refs to $0 in it   since we cant jump over a lambda we point to
                //    > (in the multiarg appzipper case, none of them can have $0)
                //  - in the pre-ivar era this required a RotateShift which turned out to be a huge speed bottleneck
                //    as it created tons of new nodes in the egraph. This is no longer needed with ivars. No shfiting at lal!

                for b_appzipper in b_appzippers.iter() {
                    // can't bubble an appzipper over a lambda if its arg refers to the lambda!
                    // todo make it handle the threading case i figured out with theo
                    if egraph[b_appzipper.arg].data.free_vars.contains(&0) {
                        continue;
                    }

                    let mut new: AppZipper = b_appzipper.clone_prepend(ZNode::Body,None);
                    
                    // downshift the args since the lambda above them moved below them (earlier we made sure none of them had pointers to it)
                    let new_arg: Id = shift(b_appzipper.arg, Shift::ShiftVar(-1), egraph, Some(caches)).unwrap();
                    new.arg = new_arg;

                    // to keep track of the fact that this shifted treenode can use the same inventions as the original
                    // todo note once you allow threading it's unclear if this remapping still holds or if there are new ways to remap
                    remap.insert(new_arg, b_appzipper.arg);

                    // println!("Bubbled over lam:\n\t{}\n{}", extract(*treenode,egraph), new.to_string(egraph));

                    appzippers.push(new);
                }
            },
        }

        all_appzippers.insert(*treenode, appzippers);
    }

    // remove all the identity functions.
    // note that we must be very careful pruning here. Most pruning isnt allowed, for example you cant prune things
    // that have free variables out bc if those free vars are on the leading edge you could still merge them away later
    all_appzippers.iter_mut().for_each(|(_,appzippers)| {
        appzippers.retain(|appzipper| !appzipper.zipper.path.is_empty());
    });

    (all_appzippers,remap)
}

#[derive(Debug)]
struct Cost {
    inventionless_cost: i32,
    inventionful_cost: HashMap<InvId, i32> 
}
impl Cost {
    fn new(inventionless_cost: i32) -> Self {
        Cost {
            inventionless_cost,
            inventionful_cost: Default::default()
        }
    }
    /// improve the cost using a new invention, or do nothing if we've already seen
    /// a better cost for this invention. Also skip if inventionless cost is better.
    fn new_cost_under_inv(&mut self, inv: InvId, cost:i32) {
        if cost < self.inventionless_cost {
            if !self.inventionful_cost.contains_key(&inv) // todo swap this to use entry api
               || cost < self.inventionful_cost[&inv]  {
                // println!("new cost added");
                self.inventionful_cost.insert(inv.clone(), cost);
            }
        }
    }
    /// cost under an invention if it's useful for this node, else inventionless cost
    fn cost_under_inv(&self, inv: InvId) -> i32 {
        self.inventionful_cost.get(&inv).cloned().unwrap_or(self.inventionless_cost)
    }
    /// best inventions - a very slow way
    fn best_inventions(&self, k: usize) -> Vec<(InvId,i32)> {
        let mut invs: Vec<(InvId,i32)> = self.inventionful_cost.iter().map(|(i,c)| (i.clone(),*c)).collect();
        // reverse order sort
        invs.sort_by(|(_,c1),(_,c2)| c1.cmp(c2));
        invs.truncate(k);
        invs
    }
}

#[derive(Debug)]
struct Costs {
    costs: Vec<Cost>, // todo note this could be a Vec<> instead of a hashmap
    remap: HashMap<Id,Id>
}
impl Costs {
    fn new(treenodes: &[Id], remap: HashMap<Id,Id>, egraph: &EGraph) -> Self {
        let costs = treenodes.iter().map(|node| Cost::new(egraph[*node].data.inventionless_cost)).collect();
        Costs { costs, remap }
    }
    #[inline(never)]
    fn cost_under_inv(&self, node: Id, inv: InvId) -> i32 {
        let remapped_node = if usize::from(node) < self.costs.len() {node} else {self.remap[&node]};
        self.costs[usize::from(remapped_node)].cost_under_inv(inv)
    }
    #[inline(never)]
    fn new_cost_under_inv(&mut self, node: Id, inv: InvId, cost:i32) {
        self.costs[usize::from(node)].new_cost_under_inv(inv, cost);
    }
    #[inline(never)]
    fn useful_invs(&self, node: Id) -> impl Iterator<Item=InvId> + '_ {
        let remapped_node = if usize::from(node) < self.costs.len() {node} else {self.remap[&node]};
        self.costs[usize::from(remapped_node)].inventionful_cost.keys().copied()
    }
    #[inline(never)]
    fn best_inventions(&self, node: Id, k: usize) -> Vec<(InvId,i32)> {
        let remapped_node = if usize::from(node) < self.costs.len() {node} else {self.remap[&node]};
        self.costs[usize::from(remapped_node)].best_inventions(k)
    }

    fn clear(&mut self) {
        self.costs.iter_mut().for_each(|cost| cost.inventionful_cost.clear());
    }

    #[inline(never)]
    fn bubble_up_costs(&mut self, node: Id, egraph: &EGraph) {
        let ref enode = egraph[node].nodes[0];

        // inventions that helped our children
        let mut child_inventions: Vec<InvId> = enode.children().iter()
            .flat_map(|id| self.useful_invs(*id))
            .collect();
        
        match enode {
            Lambda::IVar(_) => { panic!("unreachable"); }
            Lambda::Var(_) | Lambda::Prim(_) => {},
            Lambda::App([f,x]) => {
                for inv in child_inventions {
                    let fcost = self.cost_under_inv(*f, inv);
                    let xcost = self.cost_under_inv(*x, inv);
                    let cost = COST_NONTERMINAL+fcost+xcost;
                    self.new_cost_under_inv(node, inv, cost);
                }
            }
            Lambda::Lam([b]) => {
                // just map +1 over the costs
                for inv in child_inventions {
                    let cost = COST_NONTERMINAL + self.cost_under_inv(*b, inv);
                    self.new_cost_under_inv(node, inv, cost);
                }
            }
            Lambda::Programs(roots) => {
                // println!("root cost processing");
                // union together all the useful inventions of diff programs. Throw out ones only used in one place.
                filter_singles(&mut child_inventions);

                // while let Some(inv) = child_inventions.pop() {
                    // println!("processing inv {:?}", inv);
                    // weird setup: if you see exactly one copy of yourself ahead of you, youre good to go.
                    // That way if theres only 1 copy of something it gets skipped, and if there are like 5 copies itll still only
                    // do the computation once.
                    // if child_inventions.iter().filter(|inv2| **inv2 == inv).count() == 1 {
                
                for inv in child_inventions {
                    let cost = roots.iter()
                        .map(|root| self.cost_under_inv(*root, inv))
                        .sum();
                    self.new_cost_under_inv(node, inv, cost);
                    // }
                }
            }
        }
    }
}

/// checks that two zipper slices are equal on their leading edges, ie
/// same length, same ZNode variants at each position, and same subtrees
/// for arguments hanging off of ZNode::Func(arg) variants.
// fn eq_leading(a: &[ZNode], b: &[ZNode]) -> bool {
//     a.len() == b.len() && a.iter().zip(b.iter())
//         .all(|(a,b)|
//         match (a,b) {
//             (ZNode::Func(arg1), ZNode::Func(arg2)) => arg1 == arg2,
//             (ZNode::Arg(_), ZNode::Arg(_)) => true,
//             (ZNode::Body, ZNode::Body) => true,
//             _ => false
//         })
// }

/// checks that two zipper slices are equal on their trailing edges
// fn eq_trailing(a: &[ZNode], b: &[ZNode]) -> bool {
//     a.len() == b.len() && a.iter().zip(b.iter())
//         .all(|(a,b)|
//         match (a,b) {
//             (ZNode::Func(_), ZNode::Func(_)) => true,
//             (ZNode::Arg(f1), ZNode::Arg(f2)) => f1 == f2,
//             (ZNode::Body, ZNode::Body) => true,
//             _ => false
//         })
// }

#[inline]
fn group_by_key<T: Copy, U: Ord>(v: Vec<T>, key: impl Fn(&T)->U) -> Vec<Vec<T>> {
    // sort so that all equal elements are adjacent

    let mut group = vec![v[0]];
    let mut groups = vec![];
    
    for i in 1..v.len() {
        // group zippers by their left sides being the same
        if key(&v[i]) == key(&v[i-1]) {
            // add on to old ztuplegroup
            group.push(v[i]);
        } else {
            // start a new ztuplegroup
            groups.push(group);
            group = vec![v[i]];
        }
    }
    groups.push(group);
    groups
}


/// Utility
/// The utility of an invention is how useful it is at compressing the program.
/// utility(inv) = { (-NONTERMINAL_COST * arity) +  (COST_NONTERMINAL * total_path_len) + (sum of inventionless costs along edges) + -COST_TERMINAL } (for each arg #i, (num_usages - 1) * arg.inventionless_cost) + (-COST_NONTERMINAL * num_usages)
///                  ^ cost of Apps to use inv      ^ all these nonterms used to be in the original program, hence they count toward utility
///                                                   note that in practice we have to be careful not to double-count shared path prefixes
///                                                   but we can handle this easily through the "fold" and leading/tailing edge setup
///                                                                                       ^ again all these subtrees used to be in the original program so they count toward utility.
///                                                                                       and again we must be careful not to double-count shared path prefixes, which will again
///                                                                                       be naturally handled by the fold setup.
///                                                                                                                                                       ^ this captures multiuse inventions, where for each additional use
///                                                                                                                                                       you gain (+ size_of_arg) utility. Notably this cost is specific to
///                                                                                                                                                       the location that it is used and specific arguments passed in.
/// implementation: we'll build up this utility as we go. We'll lump the path length                                                  ^ theres a COST_TERMINAL whenever you use an invention for the `inv` primitive itself
/// term into the left_edge_utility. 

/// utility of a fragment of a zipper, specifically a left edge (the left/right
/// distinction is just so we can include the nonterminal cost in the left edge)
#[inline]
fn left_edge_utility(edge: &[Option<Id>], egraph: &EGraph) -> i32 {
    edge.len() as i32 * COST_NONTERMINAL +
    edge.iter().filter_map(|option_id|
        option_id.map(|id| egraph[id].data.inventionless_cost)).sum::<i32>()
}
#[inline]
fn right_edge_utility(edge: &[Option<Id>], egraph: &EGraph) -> i32 {
    edge.iter().filter_map(|option_id|
        option_id.map(|id| egraph[id].data.inventionless_cost)).sum::<i32>()
}

#[inline]
fn edge_has_free_vars(edge: &[Option<Id>], path: &[ZNode], mut depth: i32, egraph: &EGraph) -> bool {
    // return false;
    debug_assert_eq!(edge.len(), path.len());
    for (edge,node) in edge.iter().zip(path.iter()) {
        if *node == ZNode::Body {
            depth += 1;
            continue;
        }
        if let Some(id) = edge {
            if egraph[*id].data.free_vars.iter().any(|i| *i - depth >= 0) {
                return true;
            }
        }
    }
    return false;
}

#[inline]
fn divergence_idx(left: &[ZNode], right: &[ZNode]) -> usize {
    // find the first index where the two edges diverge

    for i in 0..left.len() {
        debug_assert!(i < right.len(), "right is a prefix of left");
        if left[i] != right[i] {
            debug_assert_eq!(left[i], ZNode::Func, "left: {:?}, right: {:?}", left, right);
            debug_assert_eq!(right[i], ZNode::Arg, "left: {:?}, right: {:?}", left, right);
            return i;
        }
    }
    panic!("right does not diverge from left")
}


/// This is the main workhorse of compression. Takes a child-first ordering of nodes in an EGraph
/// (assumed to be acyclic) and finds all the possible useful inventions up to the given arity.
#[inline(never)] // for flamegraph debugging
fn beta_inversions(
    programs_node: Id,
    max_arity: usize,
    // beam_size: usize,
    no_cache: bool,
    egraph: &mut EGraph
) -> InversionResult {

    println!("{}", extract(programs_node, egraph));

    let treenodes: Vec<Id> = toplogical_ordering(programs_node,egraph);
    assert!(usize::from(*treenodes.iter().max().unwrap()) == treenodes.len() - 1); // ensures we can safely just use Vecs of length treenodes.len() to store various nodewise things
    // let mut roots: Vec<Id> = egraph[programs_node].nodes[0].children().iter().cloned().collect();
    // if roots.iter().copied().collect::<HashSet<Id>>().len() != roots.len() {
    //     panic!("roots are not unique, this will cause issues and just doesnt make sense as an input");
    // }

    // assert!(roots.iter().collect::<HashSet<_>>().len() == roots.len(), "duplicate programs found");

    // lets you lookup which roots a treenode is a descendent of
    // println!("ROOOOOOTS {:?}", roots);
    // let mut roots_of_node: HashMap<Id,Vec<Id>> = get_treenode_to_roots(&roots, egraph);
    // roots_of_node.insert(programs_node,vec![]); // Programs node has no roots
    // for (treenode, roots) in treenode_to_roots.iter() {
    //     println!("{} {:?}", extract(*treenode, egraph), roots);
    // }

    // populate num_paths_to_node so we know how many different parts of the programs tree
    // a node participates in (ie multiple uses within a single program or among programs)
    let mut num_paths_to_node: HashMap<Id,i32> = HashMap::new();
    treenodes.iter().for_each(|treenode| {
        num_paths_to_node.insert(*treenode, 0);
    });
    fn helper(num_paths_to_node: &mut HashMap<Id,i32>, node: &Id, egraph: &EGraph) {
        // num_paths_to_node.insert(*child, num_paths_to_node[node] + 1);
        *num_paths_to_node.get_mut(node).unwrap() += 1;
        for child in egraph[*node].nodes[0].children() {
            helper(num_paths_to_node, &child, egraph);
        }
    }
    helper(&mut num_paths_to_node, &programs_node, &egraph);

    let tstart_total = std::time::Instant::now();

    let tstart = std::time::Instant::now();
    let (all_appzippers, remap) = get_appzippers(&treenodes, no_cache, egraph);
    println!("get_appzippers: {:?}ms", tstart.elapsed().as_millis());


    // from inv1 body to set of roots that it's used under
    let tstart = std::time::Instant::now();

    let mut paths: Vec<ZPath> = all_appzippers.values().flatten().map(|appzipper| appzipper.zipper.path.clone()).collect();
    println!("{} total paths (incl dupes)", paths.len());
    paths.sort();
    paths.dedup();
    println!("{} paths", paths.len());

    println!("collect paths and dedup: {:?}ms", tstart.elapsed().as_millis());


    let mut appzipper_of_node_zid: HashMap<(Id,ZId),AppZipper> = HashMap::new();
    let mut zids_of_node: Vec<Vec<ZId>> = vec![vec![]; treenodes.len()];
    let mut nodes_of_zid: Vec<Vec<Id>> = vec![vec![]; paths.len()];
    let mut first_mergeable_zid_of_zid: Vec<ZId> = vec![];
    let mut worklist: Vec<WorklistItem> = vec![];
    let mut donelist: Vec<FinishedItem> = vec![];
    // make sure treenodes is a permutation of the first N numbers so the Vec<Vec<>> is fine to use
    assert!(*treenodes.iter().max().unwrap() == Id::from(treenodes.len()-1));

    for (i,path) in paths.iter().enumerate() {
        // first path after `i` where the path isnt a prefix is the first mergeable one
        // (note partition_point points to the first elem where the predicate is FALSE assuming the 
        // vec already starts with all Trues and ends with all Falses)
        first_mergeable_zid_of_zid.push(paths[i..].partition_point(|p| p.starts_with(path)) + i);
    }


    let tstart = std::time::Instant::now();


    for (treenode,appzippers) in all_appzippers {
        for appzipper in appzippers {
            if let Ok(i) = paths.binary_search(&appzipper.zipper.path) {
                zids_of_node[usize::from(treenode)].push(i);
                nodes_of_zid[i].push(treenode);
                appzipper_of_node_zid.insert((treenode,i),appzipper.clone());
            } else { unreachable!() }
        }
    }

    println!("binary search to set up data structs: {:?}ms", tstart.elapsed().as_millis());

    let tstart = std::time::Instant::now();

    // build up the initial worklist
    const MAX_DONELIST: usize = 100;
    let mut upper_bound_cutoff: i32 = 0; // todo update this later
    let mut lowest_donelist_utility = 0;

    for (zid,nodes) in nodes_of_zid.iter().enumerate() {
        let left_edge_key = |node: &Id| appzipper_of_node_zid[&(*node,zid)].zipper.left.as_slice();
        let path_key = |node: &Id| appzipper_of_node_zid[&(*node,zid)].zipper.path.as_slice();
        let right_edge_key = |node: &Id| appzipper_of_node_zid[&(*node,zid)].zipper.right.as_slice();
        let both_edge_key = |node: &Id| (appzipper_of_node_zid[&(*node,zid)].zipper.left.as_slice(),
                                        appzipper_of_node_zid[&(*node,zid)].zipper.right.as_slice());
        let mut nodes = nodes.clone();

        // sorting by `both` means elements with the same `both` key will be adjacent, AND
        // elements with the same `left` key will be contiguous (since the `left` key is a prefix of the `both` key)
        nodes.sort_unstable_by_key(&both_edge_key);

        let left_groups = group_by_key(nodes.clone(), left_edge_key);
        let both_groups = group_by_key(nodes, both_edge_key);

        // finish any inventions
        for group in both_groups {
            // if groups are singletons or contain free variables, skip them
            if group.len() <= 1 ||
               edge_has_free_vars(left_edge_key(&group[0]), path_key(&group[0]),  0, &egraph) ||
               edge_has_free_vars(right_edge_key(&group[0]), path_key(&group[0]),  0, &egraph) {
                continue;
            }
            // todo filter out ones w free vars too
            let left_utility = left_edge_utility(left_edge_key(&group[0]), egraph);
            let right_utility = right_edge_utility(right_edge_key(&group[0]), egraph);
            let arity_utility = -COST_NONTERMINAL * 1; // arity is 1
            let multiuse_utility = 0; // can't have multiuse here
            let num_uses = group.iter().map(|node| num_paths_to_node[node]).sum::<i32>();
            let utility = num_uses * (-COST_TERMINAL + left_utility + right_utility + arity_utility) + multiuse_utility;
            if utility > lowest_donelist_utility {
                donelist.push(FinishedItem::new(ZTuple::single(zid), group, utility));
            }

        }

        // extend the worklist
        for group in left_groups {
            // if groups are singletons or contain free variables on the left edge (which can never be changed), discard them
            if group.len() <= 1 {
                println!("rejected bc <= 1: {}", ZTuple::single(zid).to_expr(group[0], &appzipper_of_node_zid, &egraph));
                continue;
            }
            if edge_has_free_vars(left_edge_key(&group[0]), path_key(&group[0]),  0, &egraph) {
                panic!("hey");
                continue;
            }
            println!("passed: {}", ZTuple::single(zid).to_expr(group[0], &appzipper_of_node_zid, &egraph));


            let left_utility = left_edge_utility(left_edge_key(&group[0]), egraph);
            let upper_bound = i32::MAX/2; // todo ive temporarily relaxed the upper bound
            if upper_bound > upper_bound_cutoff {
                worklist.push(WorklistItem::new(ZTuple::single(zid), group, left_utility, upper_bound));
            }
        }
    }

    donelist.sort_unstable_by_key(|item| -item.utility);
    donelist.truncate(MAX_DONELIST);
    lowest_donelist_utility = donelist.last().unwrap().utility;

    println!("initial worklist length: {}", worklist.len());
    println!("set up the worklist: {:?}ms", tstart.elapsed().as_millis());
    println!("largest ztuple group: {}", worklist.iter().map(|ztg| ztg.nodes.len()).max().unwrap());
    println!("avg ztuple group: {}", worklist.iter().map(|ztg| ztg.nodes.len()).sum::<usize>() as f64 / worklist.len() as f64);


    // todo not sure if its the right move to sort by this see discussion in notes "sort the worklist by upper bound"
    // worklist.sort_by_key(|wi| wi.utility_upper_bound);

    println!("total prep: {:?}ms", tstart_total.elapsed().as_millis());
    
    // let tstart = std::time::Instant::now();
    // let num_invs = appzipper_of_node_zid.values().map(|appzipper| appzipper.zipper.clone()).collect::<HashSet<Zipper>>().len();
    // println!("counted inventions: {:?}ms", tstart.elapsed().as_millis());
    // println!("{} single arg invs", num_invs);

    println!("deriving inventions...");
    let tstart = std::time::Instant::now();

    derive_inventions(
        &appzipper_of_node_zid,
        &zids_of_node,
        &nodes_of_zid,
        &first_mergeable_zid_of_zid,
        &mut worklist,
        &mut donelist,
        &paths,
        max_arity,
        &egraph,
        &remap,
        &treenodes,
        programs_node,
        &mut upper_bound_cutoff,
        &mut lowest_donelist_utility,
        MAX_DONELIST,
        &num_paths_to_node,
    );


    println!("\ndone deriving inventions: {:?}ms\n", tstart.elapsed().as_millis());

    println!("total everything: {:?}ms", tstart_total.elapsed().as_millis());

    let orig_cost = extract(programs_node,egraph).cost();
    //  for (inv, cost) in best_inventions.iter().take(5) {
    //      println!("{} -> {}\n{}", orig_cost, cost, inv.to_expr(egraph)); 
    // }

    // for done in donelist.iter() {
    //     let s = done.ztuple.to_expr(done.nodes[0], &mut appzipper_of_node_zid, egraph).to_string();
    //     if s == "(logo_forLoop #1 (lam (lam (logo_FWRT (logo_MULL logo_UL #0) (logo_DIVA logo_UA #1) $0))))" ||
    //        s == "(logo_forLoop #0 (lam (lam (logo_FWRT (logo_MULL logo_UL #1) (logo_DIVA logo_UA #0) $0))))" {
    //         let final_cost = orig_cost - done.utility;
    //         let multiplier = orig_cost as f64 / final_cost as f64;    
    //         println!("FOUND: utility: {} (final_cost: {}; {:.2}x) | uses: {}; ztuple: {} ", done.utility, final_cost, multiplier, done.nodes.len(), done.ztuple.to_expr(done.nodes[0], &mut appzipper_of_node_zid, egraph));
    //         break;
    //        }
    // }

    println!("orig cost: {}", orig_cost);
    for done in donelist.iter().take(10) {
        let final_cost = orig_cost - done.utility;
        let multiplier = orig_cost as f64 / final_cost as f64;
        println!("utility: {} (final_cost: {}; {:.2}x) | uses: {}; ztuple: {} ", done.utility, final_cost, multiplier, done.nodes.iter().map(|node| num_paths_to_node[node]).sum::<i32>(), done.ztuple.to_expr(done.nodes[0], &mut appzipper_of_node_zid, egraph));
    }

    unimplemented!();
}
#[inline(never)]
fn derive_inventions(
    appzipper_of_node_zid: &HashMap<(Id,ZId),AppZipper>,
    zids_of_node: &Vec<Vec<ZId>>,
    nodes_of_zid: &Vec<Vec<Id>>,
    first_mergeable_zid_of_zid: &Vec<ZId>,
    worklist: &mut Vec<WorklistItem>,
    donelist: &mut Vec<FinishedItem>,
    paths: &Vec<ZPath>,
    max_arity: usize,
    egraph: &EGraph,
    remap: &HashMap<Id,Id>,
    treenodes: &Vec<Id>,
    programs_node: Id,
    upper_bound_cutoff: &mut i32,
    lowest_donelist_utility: &mut i32,
    MAX_DONELIST: usize,
    num_paths_to_node: &HashMap<Id,i32>,
) {

    let mut num_processed = 0;
    let mut invs_scored = 0;

    // todo ofc can parallelize this 
    while let Some(wi) = worklist.pop() {
        // println!("processing {}", num_processed);
        // check upper bound
        if wi.utility_upper_bound <= *upper_bound_cutoff {
            continue;
        }
        num_processed += 1;

        let rightmost_zid: ZId = wi.ztuple.elems.last().unwrap().zid;
        let first_mergeable_zid: ZId = first_mergeable_zid_of_zid[rightmost_zid];


        let mut possible_elems: Vec<(ZTupleElem,Id)> = vec![];

        // collect all the possible ztupleelems
        for node in wi.nodes.iter() {
            // skip over the zids that are prefixes - partition point will binarysearch for the first case where the predicate is false.
            // this works nicely since all (unusuable) prefix ones come before all nonprefix ones and first_mergeable_zid tells us the first nonprefix one
            let zids = &zids_of_node[usize::from(*node)];
            let start: usize = zids.partition_point(|zid| *zid < first_mergeable_zid);
            for zid in &zids[start..] {
                // merging rightmost_zid and zid is possible as long as either arity or multiuse check out

                // add any multiarg
                if wi.ztuple.arity < max_arity {
                    possible_elems.push((ZTupleElem::new(*zid, wi.ztuple.arity), *node));
                }
                // add any multiuse
                let arg = appzipper_of_node_zid[&(*node,*zid)].arg;
                for (argi,arg_zid) in wi.ztuple.multiarg.iter().enumerate() {
                    if arg == appzipper_of_node_zid[&(*node, *arg_zid)].arg {
                        possible_elems.push((ZTupleElem::new(*zid, argi), *node));
                    }
                }
            }
        }
        
        // sort by zid (and ivar) (and Id though we dont care about that)
        possible_elems.sort();
        // Itertools::group_by(key: F)
        for (elem, subset) in &Itertools::group_by(possible_elems.into_iter(), |(elem, _node)| elem.clone()) {
            let mut nodes: Vec<Id> = subset.map(|(_elem, node)| node).collect();
            let is_multiuse = elem.ivar < wi.ztuple.arity; // multiuse means an old index within the old arity range was reused

            // divergence point doesnt depend on the specific node so we'll just use the first one
            let div_idx = divergence_idx(appzipper_of_node_zid[&(nodes[0],rightmost_zid)].zipper.path.as_slice(),
                                         appzipper_of_node_zid[&(nodes[0],elem.zid)].zipper.path.as_slice());
            
            let div_depth = appzipper_of_node_zid[&(nodes[0],rightmost_zid)].zipper.path[..div_idx].iter().filter(|x| **x == ZNode::Body).count() as i32;

            let new_ztuple: ZTuple = wi.ztuple.extend(elem.clone(), div_idx, is_multiuse);

            // define key functions for grabbing all the slices of zipper we care about
            // left_fold_key is the left inner side of the fold which is rightmost_zid.RIGHT (not LEFT)
            let left_fold_key =  |node: &Id| &appzipper_of_node_zid[&(*node,rightmost_zid)].zipper.right[div_idx+1..];
            let left_fold_path_key =  |node: &Id| &appzipper_of_node_zid[&(*node,rightmost_zid)].zipper.path[div_idx+1..];
            let right_fold_key = |node: &Id| &appzipper_of_node_zid[&(*node,elem.zid)].zipper.left[div_idx+1..];
            let right_fold_path_key = |node: &Id| &appzipper_of_node_zid[&(*node,elem.zid)].zipper.path[div_idx+1..];

            let fold_key = |node: &Id| (&appzipper_of_node_zid[&(*node,rightmost_zid)].zipper.right[div_idx+1..],
                                        &appzipper_of_node_zid[&(*node,elem.zid)].zipper.left[div_idx+1..]);
            let right_edge_key = |node: &Id| appzipper_of_node_zid[&(*node,elem.zid)].zipper.right.as_slice();
            let right_path_key = |node: &Id| appzipper_of_node_zid[&(*node,elem.zid)].zipper.path.as_slice();

            let both_edge_key = |node: &Id| (&appzipper_of_node_zid[&(*node,rightmost_zid)].zipper.right[div_idx+1..],
                                             &appzipper_of_node_zid[&(*node,elem.zid)].zipper.left[div_idx+1..],
                                             appzipper_of_node_zid[&(*node,elem.zid)].zipper.right.as_slice());

            // sorting by `both` will also sort by fold_key since the latter is a prefix of the former
            nodes.sort_unstable_by_key(&both_edge_key);

            let fold_groups = group_by_key(nodes.clone(), fold_key);
            let both_groups = group_by_key(nodes, both_edge_key);

            // finish any inventions
            for group in both_groups {
                // if groups are singletons or contain free variables, skip them
                if group.len() <= 1 ||
                    edge_has_free_vars(left_fold_key(&group[0]), left_fold_path_key(&group[0]),  div_depth, &egraph) ||
                    edge_has_free_vars(right_fold_key(&group[0]), right_fold_path_key(&group[0]),  div_depth, &egraph) ||
                    edge_has_free_vars(right_edge_key(&group[0]), right_path_key(&group[0]),  0, &egraph) {
                    continue;
                }
                // the left side of the fold is a RIGHT-facing edge (since it faces into the fold) hence it's right_edge_utility for the left_fold_key
                let fold_utility = right_edge_utility(left_fold_key(&group[0]), egraph) + left_edge_utility(right_fold_key(&group[0]), egraph);
                let left_utility = wi.left_utility + fold_utility;
                let right_utility = right_edge_utility(right_edge_key(&group[0]), egraph);
                let arity_utility = -COST_NONTERMINAL * new_ztuple.arity as i32; // new arity
                // multiuse utility depends on the size of the argument that's being used in multiple places. We can
                // look up that argument using appzipper_of_node_zid since ztuple.multiuses gives us the zids for the multiuse
                // cases (leaving out the original use)
                let multiuse_utility = new_ztuple.multiuse.iter()
                    .map(|&arg_zid| // for each extra use of a multiuse arg
                        group.iter().map(|node| // for each node
                            num_paths_to_node[node] * // account for same node being used in multiple subtrees
                            egraph[appzipper_of_node_zid[&(*node,arg_zid)].arg].data.inventionless_cost
                        ).sum::<i32>()
                    ).sum::<i32>();
                
                let num_uses = group.iter().map(|node| num_paths_to_node[node]).sum::<i32>();
                let utility = num_uses * (-COST_TERMINAL + left_utility + right_utility + arity_utility) + multiuse_utility;
                if utility > *lowest_donelist_utility {
                    donelist.push(FinishedItem::new(new_ztuple.clone(), group, utility));
                }
                invs_scored += 1;
            }
    
            // extend the worklist
            for group in fold_groups {
                // if groups are singletons or the fold contains free variables, skip them
                if group.len() <= 1 ||
                    edge_has_free_vars(left_fold_key(&group[0]), left_fold_path_key(&group[0]),  div_depth, &egraph) ||
                    edge_has_free_vars(right_fold_key(&group[0]), right_fold_path_key(&group[0]),  div_depth, &egraph) {
                    continue;
                }
                // todo filter out ones w free vars too
                let fold_utility = right_edge_utility(left_fold_key(&group[0]), egraph) + left_edge_utility(right_fold_key(&group[0]), egraph);
                let left_utility = wi.left_utility + fold_utility;
                let upper_bound = i32::MAX/2; // todo ive temporarily relaxed the upper bound
                if upper_bound > *upper_bound_cutoff {
                    worklist.push(WorklistItem::new(new_ztuple.clone(), group, left_utility, upper_bound));
                }
            }
        }

        if donelist.len() > std::cmp::max(1000, if MAX_DONELIST != usize::MAX { MAX_DONELIST*4 } else { MAX_DONELIST }) {
            donelist.sort_unstable_by_key(|item| -item.utility);
            donelist.truncate(MAX_DONELIST);
            *lowest_donelist_utility = donelist.last().unwrap().utility;
        }

    }

    assert!(worklist.is_empty());

    donelist.sort_unstable_by_key(|item| -item.utility);
    donelist.truncate(MAX_DONELIST);
    *lowest_donelist_utility = donelist.last().unwrap().utility;

    println!("!! num processed: {}", num_processed);
    println!("!! invs scored: {}", invs_scored);
}


    //     let mut invs: Vec<OffZTuple> = vec![];
    //     let mut worklist_additions: Vec<ZTuple> = vec![];
    //     for node in treenodes.iter() {

    //         // 1) inherit useful inventions from children by bubbling up one step of costs from them. In the Programs case
    //         //    this also will filter out singly-used inventions. Important to do this on all nodes even ones where ztuple doesnt apply!
    //         node_costs.bubble_up_costs(*node, egraph);

    //         // 2) fail fast if this node doesnt have all the zids the ztuple needs.
    //         if ztuple.zids().any(|zid| !zids_of_node[usize::from(*node)].contains(&zid)) {
    //             continue; // this node is missing a necessary zid
    //         }
            
    //         // 3) instantiate an offztuple roughly by mapping zids to zippers
    //         let appzippers =  ztuple.zids().map(|zid| appzipper_of_node_zid[&(*node,zid)].clone());
    //         let appoffztuple = AppOffZTuple::from_appzippers(&ztuple, appzippers);

    //         // 4) for efficiency we'll switch to referring to the invention by its location in `invs`
    //         let inv: InvId = invs.iter().position(|inv| inv == &appoffztuple.offztuple).unwrap_or_else(|| {
    //             invs.push(appoffztuple.offztuple.clone());
    //             // println!("new inv: {}", appoffztuple.offztuple.to_string_detailed(egraph));
    //             invs.len() - 1
    //         });

    //         // 5) use merge_multiarg and merge_multiuse to extend the worklist (or rather a temp worklist that gets deduped later)
    //         let largest_zid: ZId = ztuple.zids().last().unwrap();
    //         for zid in zids_of_node[usize::from(*node)].iter().filter(|zid| **zid > largest_zid) {
    //             let appzipper: &AppOffZipper = &appzipper_of_node_zid[&(*node,*zid)];
    //             if appoffztuple.offztuple.arity < max_arity {
    //                 // arity is low so can attempt to merge
    //                 if let Some(new_ztuple) = appoffztuple.merge_multiarg(appzipper, *zid, &ztuple) {
    //                     worklist_additions.push(new_ztuple);
    //                 }
    //             }
    //             if let Some(new_ztuples) = appoffztuple.merge_multiuse(appzipper, *zid, &ztuple) {
    //                 worklist_additions.extend(new_ztuples);
    //             }
    //         }

    //         // 6) get the cost of applying the invention at this node
    //         let cost: i32 =
    //             COST_TERMINAL // the new primitive for this invention
    //             + COST_NONTERMINAL * appoffztuple.args.len() as i32 // the chain of app()s needed to apply the new primitive
    //             + appoffztuple.args.iter()
    //                 .map(|arg| node_costs.cost_under_inv(*arg, inv))
    //                 .sum::<i32>(); // sum costs of actual args
    //         // println!("COST: {} -> {} at {}", extract(*node,egraph).cost(), cost, extract(*node,egraph));
    //         // 4) Push invention + cost into NodeCosts
    //         node_costs.new_cost_under_inv(*node, inv, cost);            

    //     }
    //     // println!("benefited: {}", !node_costs.best_inventions(programs_node, 1).is_empty());
    //     // 6) after all nodes are processed, add the best k=1 toplevel inventions to the list, sort/prune it if it's too long
    //     best_inventions.extend(node_costs.best_inventions(programs_node, 1).into_iter().map(|(inv,cost)| (invs[inv].clone(),cost)));
    //     if best_inventions.len() > 300 {
    //         best_inventions.sort_by(|(_,cost1),(_,cost2)| cost1.cmp(cost2));
    //         best_inventions.truncate(100);
    //     }

    //     // if ztuple.elems.len() == 3 && ztuple.arity == 1 { panic!("check this out")}

    //     invs.clear();

    //     node_costs.clear(); // wipe caches, but keep allocated memory for reuse

    //     // 7) add worklist additions to the worklist
    //     // todo ofc one step further of pruning would be checking which roots these correspond to and filtering singles wrt that
    //     // filter_singles(&mut worklist_additions);
    //     // note that sadly you cant prune based on what shows up only once bc you actually have to go by roots bc a single node could have multiple roots and thus be totally fine
    //     worklist_additions.sort();
    //     worklist_additions.dedup();
    //     worklist.extend(worklist_additions);
    //     // worklist.extend(worklist_additions.into_iter().collect::<HashSet<ZTuple>>()); // very important to dedup and no Ord so must use hashset
    // }

    // println!("processed {} ztuples", num_processed);

    // best_inventions.sort_by(|(_,cost1),(_,cost2)| cost1.cmp(cost2));
    // best_inventions.truncate(100);
    // best_inventions

/// sorts v, removes the last copy of every
/// unique value, and dedups. So this is the same
/// as deduping but keeping only things that appear
/// more than once.
/// AHHH 
#[inline]
fn filter_singles<T: Ord>(v: &mut Vec<T>) {
    v.sort();
    let mut i = 0;
    while i + 1 < v.len() {
        if v[i] != v[i+1] {
            v.remove(i);
        } else {
            i += 1;
        }
    }
    v.dedup();
}


#[derive(Debug)]
struct NodeCost {
    inventionless_cost: i32,
    inventionful_cost: HashMap<Inv, i32>
}
impl NodeCost {
    fn new(inventionless_cost: i32) -> Self {
        NodeCost {
            inventionless_cost,
            inventionful_cost: Default::default()
        }
    }
    /// improve the cost using a new invention, or do nothing if we've already seen
    /// a better cost for this invention. Also skip if inventionless cost is better.
    fn new_cost_under_inv(&mut self, inv: &Inv, cost:i32) {
        if cost < self.inventionless_cost {
            if !self.inventionful_cost.contains_key(inv)
               || cost < self.inventionful_cost[&inv]  {
                self.inventionful_cost.insert(inv.clone(), cost);
            }
        }
    }
    /// cost under an invention if it's useful for this node, else inventionless cost
    fn cost_under_inv(&self, inv: &Inv) -> i32 {
        self.inventionful_cost.get(inv).cloned().unwrap_or(self.inventionless_cost)
    }
    /// best inventions - a very slow way
    fn best_inventions(&self, k: usize) -> Vec<(Inv,i32)> {
        let mut invs: Vec<(Inv,i32)> = self.inventionful_cost.iter().map(|(i,c)| (i.clone(),*c)).collect();
        // reverse order sort
        invs.sort_by(|(_,c1),(_,c2)| c1.cmp(c2));
        invs.truncate(k);
        invs
    }
}

#[derive(Debug)]
struct NodeCosts {
    costs: HashMap<Id,NodeCost>,
    remap: HashMap<Id,Id>
}
impl NodeCosts {
    fn new(treenodes: &[Id], remap: HashMap<Id,Id>, egraph: &EGraph) -> Self {
        let costs = treenodes.iter().map(|node| (*node,NodeCost::new(egraph[*node].data.inventionless_cost))).collect();
        NodeCosts { costs, remap }
    }
    fn cost_under_inv(&self, node: Id, inv: &Inv) -> i32 {
        let remapped_node = if self.costs.contains_key(&node) {node} else {self.remap[&node]};
        self.costs[&remapped_node].cost_under_inv(inv)
    }
    fn new_cost_under_inv(&mut self, node: Id, inv: &Inv, cost:i32) {
        self.costs.get_mut(&node).unwrap().new_cost_under_inv(inv, cost);
    }
    fn useful_invs(&self, node: Id) -> impl Iterator<Item=Inv> + '_ {
        let remapped_node = if self.costs.contains_key(&node) {node} else {self.remap[&node]};
        self.costs[&remapped_node].inventionful_cost.keys().cloned()
    }
    fn best_inventions(&self, node: Id, k: usize) -> Vec<(Inv,i32)> {
        let remapped_node = if self.costs.contains_key(&node) {node} else {self.remap[&node]};
        self.costs[&remapped_node].best_inventions(k)
    }
}


fn best_inventions(invs_of_node: &HashMap<Id,Vec<AppliedInv>>, remap: &HashMap<Id,Id>, programs_node: Id, egraph: &EGraph) -> NodeCosts {
    let treenodes: Vec<Id> = toplogical_ordering(programs_node,egraph);

    // todo make wayyyyy more efficient by switching out Inv everywhere in the interals with Id or usize
    // first get inventionless costs
    let mut node_costs = NodeCosts::new(&treenodes, remap.clone(), egraph);

    for node in treenodes.iter() {
        // using an invention at this node
        // println!("node: {}", extract(*node,egraph));
        if invs_of_node.contains_key(node) {
            println!("node: {} has cost {}", extract(*node,egraph), extract(*node,egraph).cost()); // todo temp
            for appinv in invs_of_node[node].iter() {
                let cost: i32 =
                    COST_TERMINAL // the new primitive for this invention
                    + COST_NONTERMINAL * appinv.args.len() as i32 // the chain of app()s needed to apply the new primitive
                    + appinv.args.iter()
                        .map(|arg| node_costs.cost_under_inv(*arg, &appinv.inv))
                        .sum::<i32>(); // sum costs of actual args
                appinv.print(egraph);
                println!("which has cost: {}", cost);
                node_costs.new_cost_under_inv(*node, &appinv.inv, cost);
            }
        }

        let enode = egraph[*node].nodes[0].clone();

        // inventions that helped our children
        let child_inventions: Vec<Inv> = enode.children().iter()
            .map(|id| node_costs.useful_invs(*id))
            .flatten()
            .collect();
        
        match enode {
            Lambda::IVar(_) => { panic!("unreachable"); }
            Lambda::Var(_) | Lambda::Prim(_) => {},
            Lambda::App([f,x]) => {                                
                for inv in child_inventions {
                    let fcost = node_costs.cost_under_inv(f, &inv);
                    let xcost = node_costs.cost_under_inv(x, &inv);
                    let cost = COST_NONTERMINAL+fcost+xcost;
                    node_costs.new_cost_under_inv(*node, &inv, cost);
                }
            }
            Lambda::Lam([b]) => {
                // just map +1 over the costs
                for inv in child_inventions {
                    let bcost = node_costs.cost_under_inv(b, &inv);
                    let cost = COST_NONTERMINAL+bcost;
                    node_costs.new_cost_under_inv(*node, &inv, cost);
                }
            }
            Lambda::Programs(roots) => {
                // union together all the useful inventions of diff programs
                
                // count num occurences of each invention
                let mut counts: HashMap<Inv,i32> = child_inventions.iter().cloned().map(|i| (i,0)).collect();
                for inv in child_inventions {
                    counts.insert(inv.clone(), counts[&inv] + 1);
                }

                // keep only inventions used by 2+ programs
                let inventions: Vec<Inv> = counts.into_iter()
                    .filter_map(|(i,c)| if c > 1 { Some(i) } else { None }).collect();
                
                for inv in inventions {
                    let cost = roots.iter().map(|root| {
                            node_costs.cost_under_inv(*root, &inv)
                        }).sum();
                    node_costs.new_cost_under_inv(*node, &inv, cost);
                }
            }
        }

    }
    node_costs
}

struct CompressionResult {
    inv: InventionExpr,
    rewritten: Expr,
}

/// takes a (programs ...) expr, returns the best Invention and the Expr rewritten under that invention
fn compression_step(
    programs_expr: &Expr,
    args: &CompressionArgs,
    out_dir: &str,
    new_inv_name: &str,
) -> Option<CompressionResult> {

    // build the egraph. We'll just be using this as a structural hasher we don't use rewrites at all. All eclasses will always only have one node.
    let mut egraph: EGraph = Default::default();
    let programs_id = egraph.add_expr(programs_expr.into());
    egraph.rebuild();

    println!("Initial egraph:\n\t{}\n", egraph_info(&egraph));
    if args.render_initial {
        save(&egraph, "0_programs", &out_dir);
    }

    let tstart = std::time::Instant::now();

    let treenodes: Vec<Id> = toplogical_ordering(programs_id, &egraph);
    // println!("Topological ordering:");
    // treenodes.iter().for_each(|&id| {
    //     println!("id={}: {}", id, extract(id,&egraph));
    // });

    let InversionResult { applams_of_treenode, best_inventions_of_treenode} =
        beta_inversions(
            programs_id,
            args.max_arity,
            // args.beam_size,
            args.no_cache,
            &mut egraph
        );

    egraph.rebuild(); // hopefully doesnt matter at all anyways if we're just using the egraph as a structurla hasher (not sure if we needed to do this thruout inversions)

    let elapsed = tstart.elapsed().as_millis();

    println!("Inventionless (cost={:?}):\n{}\n",
        egraph[programs_id].data.inventionless_cost,
        extract(programs_id, &egraph)
    );

    let top_invs: Vec<Invention> = best_inventions_of_treenode[&programs_id].top_inventions();

    // print the top args.print_inventions inventions
    for (i,inv) in top_invs.iter().take(args.print_inventions).enumerate() {
        let inv_expr = inv.to_expr(&egraph).body;
        let inv_str = &format!("inv{}_{}",inv.body,inv.arity);
        let rewritten = extract_under_inv(programs_id, *inv, inv_str, &applams_of_treenode, &best_inventions_of_treenode, &egraph);
        println!("\nInvention {} {:?} (inv_cost={:?}; rewritten_cost={:?}):\n{}\n Rewritten:\n{}",
            i,
            inv,
            inv_expr.cost(),
            rewritten.cost(),
            inv_expr,
            rewritten,
        );
        if args.render_inventions {
            inv_expr.save(&format!("inv{}",i), &out_dir);
        }
    }

    println!("Final egraph: {}",egraph_info(&egraph));

    // print out the largest variable we've seen (useful to make sure our egraph isnt exploding due to Vars)
    for i in 0..1000 {
        if search(format!("(${})",i).as_str(),&egraph).is_empty() {
            println!("Largest variable: ${}",i-1);
            break;
        }
    }

    println!("Cands useful at top level: {}",top_invs.len());
    println!("Core stuff took: {}ms ***\n", elapsed);

    if args.render_final {
        println!("Rendering final egraph");
        save(&egraph, "final", &out_dir);
    }

    if top_invs.is_empty() {
        return None
    }

    // return the top invention
    let top_inv = top_invs[0].clone();
    let top_inv_expr = top_inv.to_expr(&egraph);
    let top_inv_rewritten = extract_under_inv(programs_id, top_inv.clone(), new_inv_name, &applams_of_treenode, &best_inventions_of_treenode, &egraph);
    Some(CompressionResult {
        inv: top_inv_expr,
        rewritten: top_inv_rewritten,
    })
}

pub fn compression(
    programs_expr: &Expr,
    args: &CompressionArgs,
    out_dir: &str,
) -> (Vec<(InventionExpr,String)>,Expr) {
    let mut rewritten: Expr = programs_expr.clone();
    let mut invs: Vec<(InventionExpr,String)> = Default::default();
    let mut rewrittens: Vec<Expr> = Default::default();
    let mut cost_improvement: Vec<i32> = Default::default();

    let tstart = std::time::Instant::now();

    for i in 0..args.iterations {
        println!("\n=======Iteration {}=======",i);
        let inv_name = format!("inv{}",invs.len());
        if let Some(res) = compression_step(&rewritten, args, out_dir, &inv_name) {
            rewritten = res.rewritten.clone();
            println!("Chose Invention {}: {}\nRewritten (cost={})\n{}", inv_name, res.inv, res.rewritten.cost(), res.rewritten);
            invs.push((res.inv,inv_name));
            rewrittens.push(res.rewritten);
        } else {
            println!("No inventions found at iteration {}",i);
            break;
        }
        
    }

    println!("\n=======Compression Summary=======");
    println!("Found {} inventions", invs.len());
    println!("Cost Improvement: ({:.2}x better) {} -> {}", compression_factor(programs_expr,&rewritten), programs_expr.cost(), rewritten.cost());
    let mut prev_rewritten = programs_expr;
    for i in 0..invs.len() {
        let (inv,inv_name) = &invs[i];
        let rewritten = &rewrittens[i];
        println!("({:.2}x wrt prev; {:.2}x wrt orig) {}: {}", compression_factor(prev_rewritten, &rewritten), compression_factor(programs_expr, &rewritten), inv_name, inv);
        prev_rewritten = &rewritten;
    }
    println!("Time: {}ms", tstart.elapsed().as_millis());


    (invs,rewritten)
}