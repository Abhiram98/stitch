
This repo attempts to extend tool `stitch`  '''' exp stitch here '''' (presented in the POPL 2023 paper [Top-Down Synthesis For Library Learning](https://arxiv.org/abs/2211.16605)) to perform library extraction over a Python project, in a tool called `Leroy`.

# Leroy

## Start Here

This ReadMe is focuses on using _Leroy_ via commandline (Rust).

## Installation & Testing

- Install `rust` from [here](https://www.rust-lang.org/tools/install)
- Clone this repo
- ensure that `cargo run --release --bin=compress -- data/cogsci/nuts-bolts.json` runs without crashing
- Install `pybrary_extraction` module from setup.py, from the root of the repo: `pip install .`
- For a more thorough test, run `make test`

## Running Leroy
Run `pybrary_extraction/leroy.py`

```
python pybrary_extraction/leroy.py --py_files_dir data/python/ex1 --min-nodes-abstraction 0
```

Output goes into a temp directory at the level of this repository.

-  `leroy_library.py` contains the abstracted library functions.
- rewritten programs are also present in this directory.


## All command line arguments

From `python pybrary_extraction/leroy.py --help`

```
Usage: leroy.py [OPTIONS]

Options:
  --py_files_dir TEXT             directory containing python files to run
                                  leroy on.
  --iterations INTEGER            Number of iterations to run stitch for.
  --max-arity INTEGER             maximum number of parameters for an
                                  abstraction.
  --min-nodes-abstraction INTEGER
                                  minimum number of ast nodes in the
                                  abstraction
  --help                          Show this message and exit.
```

[!NOTE]  
> Information below details the modifications to stitch, to work for python programs.


## Running Stitch4Leroy

This section detials the modified version of stitch used internally by Leroy. 

Lets take a look at some simple examples of the `stitch` input format. Put the following in a new file `data/python/ex1.json`:
```json
[
    "Module (Assign (x 5) Expr (Call (print x)))",
    "Module (Assign (x 1) Assign (y 1) Assign (z BinOp (x Add y)) Expr (Call (print z)))"
]
```
As above, stitch input format is a json file containing a list of input programs, where each program is a string written in a lisp-like lambda calculus syntax.

Each element in the json array represents the following python programs, whose AST is encoded in a lispy format.

1. 
```python
x=5
print(x)
```

2.
```python
x=1
y=1
z=x+y
print(z)
```

To run _Stitch4Leroy_:
```
cargo run --release --bin=compress -- data/python/ex1.json --max-arity=3 --iterations=3 --prune-macro-abstractions
```

[//]: # (&#40;If you're having any trouble, check out other examples like `data/basic/simple1.json` to make sure you have the right format.&#41;)

The output should look like:
```
=======Compression Summary=======
Found 2 inventions
Cost Improvement: (1.48x better) 3129 -> 2119
fn_0 (1.24x wrt orig): utility: 202 | final_cost: 2523 | 1.24x | uses: 2 | body: [fn_0 arity=1: (Expr (Call print (__list__ #0)))]
fn_1 (1.48x wrt orig): utility: 201 | final_cost: 2119 | 1.19x | uses: 4 | body: [fn_1 arity=2: (Assign (__list__ #1) #0)]
Time: 1923ms
Wrote to "out/out.json"
```

Primer on the output format:
- `Cost Improvement: (1.48x better) 3129 -> 2119`
  - here we see that by the cost metric (which values terminals like `foo` and `a` as `100` and nonterminals like `app` and `lam` as `1`) our programs were rewritten to be 1.33x smaller. To see the actual rewritten programs you can include `--show-rewritten` in the command and the rewritten programs will appear a few lines above the compression summary:
    - `(foo (fn_0 a))` and `(bar (fn_0 b))`
- `fn_0`
  - this is the name the new primitive was assigned
- `(1.24x wrt orig)`
  - this is a *cumulative* measure of compression (ie "with respect to original"), so if we were learning more than one abstraction it would represent the accumulated compression over all previous abstractions
- `utility: 202`
  - This is the utility, which corresponds to the difference in program cost before and after rewriting.
- `final_cost: 2523`
  - final cost of programs after rewriting
- `1.24x`
  - compression gained from this abstraction - again, only relevant when learning more than one abstraction
- `uses: 2`
  - the abstraction is used twice in the set of programs
- `body: [fn_0 arity=1: (Expr (Call print (__list__ #0)))]`
  - this is the abstraction itself is equivalent to 
  ```python
  def fn_0(x):
      print(x)
  ```
  - the first abstraction variable is always `#0`, the second is `#1`, etc.

There's also a more complete output that is sent to `out/out.json` by default and can be consumed by other programs that are using stitch as a subroutine (if they arent using the Rust/Python bindings for it). A very important flag is `--rewritten-intermediates`, which includes the rewritten version in the output after *each* abstraction is found - this can be very helpful for understanding the abstractions you're learning.

## Common command-line arguments

- `--max-arity=2` or `-a2` controls max arity of abstraction found (default is 2). Try to keep the arity relatively low if you don't need high arity abstractions, as it can significantly increase runtime.
- `--iterations=10` or `-i10` controls how many iterations of compression to run. Each iteration produces one abstraction (which can build on the previous ones)
- `--threads=10` or `-t10` is a quick way to boost performance by multithreading (default is 1)

## Additional command line options from _Leroy_

- `--prune-macro-abstractions` this triggers the python-ast triggering module, to ensure that abstractions are valid python
- `--min-nodes-invention`: A minimum size to the abstractions. This helps prune small abstractions which aren't interesting in a language like python(ex: abstracting the addition operator)

## All command-line arguments
From `cargo run --release --bin=compress -- --help`
```
Usage: cargo run [OPTIONS] [ARGS]...

Arguments:
  [ARGS]...  Arguments for the binary or example to run

Options:
      --ignore-rust-version   Ignore `rust-version` specification in packages
      --message-format <FMT>  Error format
  -q, --quiet                 Do not print cargo log messages
  -v, --verbose...            Use verbose output (-vv very verbose/build.rs
                              output)
      --color <WHEN>          Coloring: auto, always, never
      --config <KEY=VALUE>    Override a configuration value
  -Z <FLAG>                   Unstable (nightly-only) flags to Cargo, see 'cargo
                              -Z help' for details
  -h, --help                  Print help

Package Selection:
  -p, --package [<SPEC>]  Package with the target to run

Target Selection:
      --bin [<NAME>]      Name of the bin target to run
      --example [<NAME>]  Name of the example target to run

Feature Selection:
  -F, --features <FEATURES>  Space or comma separated list of features to
                             activate
      --all-features         Activate all available features
      --no-default-features  Do not activate the `default` feature

Compilation Options:
  -j, --jobs <N>                Number of parallel jobs, defaults to # of CPUs.
      --keep-going              Do not abort the build as soon as there is an
                                error
  -r, --release                 Build artifacts in release mode, with
                                optimizations
      --profile <PROFILE-NAME>  Build artifacts with the specified profile
      --target [<TRIPLE>]       Build for the target triple
      --target-dir <DIRECTORY>  Directory for all generated artifacts
      --unit-graph              Output build graph in JSON (unstable)
      --timings[=<FMTS>]        Timing output formats (unstable) (comma
                                separated): html, json

Manifest Options:
      --manifest-path <PATH>  Path to Cargo.toml
      --frozen                Require Cargo.lock and cache are up to date
      --locked                Require Cargo.lock is up to date
      --offline               Run without accessing the network

Run `cargo help run` for more detailed information.
(mcsvenv) abhiram@Abhirams-MacBook-Pro stitch % cargo run --release --bin=compress -- -h                
    Finished release [optimized] target(s) in 0.12s
     Running `target/release/compress -h`
Stitch 
Stitch

USAGE:
    compress [OPTIONS] <FILE>

ARGS:
    <FILE>    json file to read compression input programs from

OPTIONS:
    -a, --max-arity <MAX_ARITY>
            Max arity of abstractions to find (will find arities from 0 to this number inclusive).
            Note that scaling with arity can be very expensive [default: 2]

        --abstraction-prefix <ABSTRACTION_PREFIX>
            Prefix used to generate names of new abstractions, by default we will name our
            abstractions fn_0, fn_1, fn_2, etc [default: fn_]

        --allow-single-task
            Allow for abstractions that are only useful in a single task (defaults to False like
            DreamCoder)

    -b, --batch <BATCH>
            How many worklist items a thread will take at once [default: 1]

        --cost-app <COST_APP>
            Sets cost for applications in the lambda calculus [default: 1]

        --cost-ivar <COST_IVAR>
            Sets cost for `#i` abstraction variables [default: 100]

        --cost-lam <COST_LAM>
            Sets cost for lambdas [default: 1]

        --cost-prim-default <COST_PRIM_DEFAULT>
            Sets cost for primitives like `+` and `*` [default: 100]

        --cost-var <COST_VAR>
            Sets cost for `$i` variables [default: 100]

        --dreamcoder-comparison
            Extra printouts related to running a dreamcoder comparison. Section 6.1 of Stitch paper
            https://arxiv.org/abs/2211.16605

        --dynamic-batch
            Threads will autoadjust how large their batches are based on the worklist size

        --eta-long
            Puts result into eta-long form when rewriting (also requires beta-normal form). This can
            be useful for programs that will be used to train top down synthesizers, but it also
            restricts what abstractions can be found a bit (i.e. only those that can be put in
            beta-normal eta-long form are allowed)

        --fmt <FMT>
            the format of the input file, e.g. 'programs-list' for a simple JSON array of programs
            or 'dreamcoder' for a JSON in the style expected by the original dreamcoder codebase.
            See [formats.rs] for options or to add new ones [default: programs-list] [possible
            values: dreamcoder, programs-list]

        --follow <FOLLOW>
            Pattern or abstraction to follow and give prinouts about. If `follow_prune=True` we will
            aggressively prune to only follow this pattern, otherwise we will just verbosely print
            when ancestors of this pattern are encountered

        --follow-prune
            For use with `follow`, enables aggressive pruning. Useful for ensuring that it is
            *possible* to find a particular abstraction by guiding the search directly towards it

        --fused-lambda-tags <FUSED_LAMBDA_TAGS>
            [default: ]

    -h, --help
            Print help information

        --hole-choice <HOLE_CHOICE>
            Method for choosing hole to expand at each step. Doesn't have a huge effect [default:
            depth-first] [possible values: random, breadth-first, depth-first, max-largest-subset,
            high-entropy, low-entropy, max-cost, min-cost, many-groups, few-groups, few-apps]

    -i, --iterations <ITERATIONS>
            Maximum number of iterations to run compression for (number of inventions to find,
            though stitch will stop early if no compressive abstraction exists) [default: 3]

        --inv-arg-cap
            Enables edge case handling where inverting the argument capture subsumption pruning is
            needed for optimality. Generally not relevant just included for completeness, see the
            footnoted section of Section 4.3 of the Stitch paper https://arxiv.org/abs/2211.16605

        --min-nodes-invention <MIN_NODES_INVENTION>
            minimum number of nodes in an abstraction [default: 0]

    -n, --inv-candidates <INV_CANDIDATES>
            [currently not used] Number of invention candidates compression_step should return in a
            *single* step. Note that these will be the top n optimal candidates modulo subsumption
            pruning (and the top-1 is guaranteed to be globally optimal) [default: 1]

        --no-curried-bodies
            Forbid abstraction bodies rooted to the left of an app (see also no_curried_metavars and
            eta_long)

        --no-curried-metavars
            Forbid metavariables to the left of an app

        --no-mismatch-check
            Disables the safety check for the utility being correct; you only want to do this if you
            truly dont mind unsoundness for a minute

        --no-opt
            Disable all optimizations

        --no-opt-arity-zero
            Disable the arity zero optimization, which searches first for the most compressive
            arity-zero abstraction since this is extremely fast to find and provides a good starting
            point for our upper bound pruning. In practice this isn't a very important optimization

        --no-opt-force-multiuse
            Disable *redundant argument elimination* pruning (aka "force multiuse"). Section 4.3 of
            Stitch paper https://arxiv.org/abs/2211.16605 This is a fairly important optimization
            (ablation study in Section 6.4 of Stitch paper)

        --no-opt-single-use
            Disable the single structurally hashed subtree match pruning. This is a very minor
            optimization that allows discarding certain abstractions that only match at a single
            unique subtree as long as that subtree lacks free variables, because arity zero
            abstractions are always superior in this case

        --no-opt-upper-bound
            Disable *upper bound* based pruning. Section 4.2 of Stitch paper
            https://arxiv.org/abs/2211.16605 This is an extremely important optimization (ablation
            study in Section 6.4 of Stitch paper)

        --no-opt-useless-abstract
            Disable *argument capture* pruning (aka "useless abstraction pruning"). Section 4.3 of
            Stitch paper https://arxiv.org/abs/2211.16605 This is an extremely important
            optimization (ablation study in Section 6.4 of Stitch paper)

        --no-other-util
            Switch to utility based purely on program size without adding in the abstraction size
            (aka the "structure penalty" in DreamCoder)

        --no-stats
            Disable stat logging - note that stat logging in multithreading requires taking a mutex
            so it can be a source of slowdown in the massively multithreaded case, hence this flag
            to disable it

    -o, --out <OUT>
            json output file [default: out/out.json]

        --previous-abstractions <PREVIOUS_ABSTRACTIONS>
            Number of previous abstractions that have been found before this round of compression -
            this is used to calculate what the next abstraction name should be - for example if 2
            abstractions have been found previously then the next abstraction will be fn_2 [default:
            0]

        --print-stats <PRINT_STATS>
            Print stats this often (0 means never) [default: 0]

        --prune-macro-abstractions
            Whether to prune incomplete/macro abstractions. This works if input data has lispy stuff
            with complete function calls

        --quiet
            Silence all printing within a compression step. See `silent` to silence all outputs
            between compression steps as well

    -r, --show-rewritten
            Print out programs rewritten under abstraction

        --rewrite-check
            Used for soundness testing. Whenever you finish an invention do a full rewrite to check
            that rewriting doesnt raise a cost mismatch exception

        --rewritten-dreamcoder
            Include the dreamcoder-format rewritten programs in the output

        --rewritten-intermediates
            For each abstraction learned, includes the rewritten programs right after learning that
            abstraction in the output. If `rewritten_dreamcoder` is also specified, then the
            rewritten programs in dreamcoder format will also be included

        --save-rewritten <SAVE_REWRITTEN>
            saves the rewritten frontiers in an input-readable format in a separate json from the
            normal output json

        --shuffle
            Shuffles the order of the programs passed in

        --silent
            Disables all prinouts except in the case of a panic. See also `quiet` to just silence
            internal printouts during each compression step In Python this defaults to True

        --structure-penalty <STRUCTURE_PENALTY>
            DreamCoder style structure penalty - must be positive. Overall utility is this
            difference in corpus size minus structure_penalty * abstraction_size [default: 1.0]

    -t, --threads <THREADS>
            Number of threads to use for compression (no parallelism if set to 1) [default: 1]

        --truncate <TRUNCATE>
            Truncate the list of programs (happens after shuffle if shuffle is also specified)

        --utility-by-rewrite
            Calculate utility exhaustively by performing a full rewrite. Used for debugging when
            cost mismatch exceptions are happening and we need something slow but accurate as a
            temporary solution

        --verbose-best
            Prints whenever a new best abstraction is found

        --verbose-rewrite
            Very verbose when rewriting happens - turns off --silent and --quiet which are usually
            forced on in rewriting

        --verbose-worklist
            Prints every worklist item as it is processed (will slow things down a ton due to
            rendering out expressions)
```
