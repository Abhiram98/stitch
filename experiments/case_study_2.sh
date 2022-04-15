#!/bin/bash
set -e
#ulimit -v 50000000  # attempt to limit children to 50GB=50,000,000KB of virtual memory

if [ -z $STITCH_DIR ]
then
    echo "[case_study_2.sh] Please set environment variable \$STITCH_DIR to the stitch/ directory"
    exit 1
fi

OUT_DIR="cs2/quiet/$(TZ='America/New_York' date '+%Y-%m-%d_%H-%M-%S')"
mkdir -p $OUT_DIR

# Save some info about what state of the repo this experiment was run in
# to aid reporducibility
echo -n "Current git commit: " > $OUT_DIR/readme.md
git log -n 1 >> $OUT_DIR/readme.md
echo -n "Current git branch: " >> $OUT_DIR/readme.md
git rev-parse --abbrev-ref HEAD >> $OUT_DIR/readme.md

# compile Stitch
pushd $STITCH_DIR
cargo build --release --bin=compress
popd


for WL_PATH in $STITCH_DIR/data/cogsci/*.json; do
    WL=$(basename -s .json $WL_PATH)
    for SPLIT in 5 10 15 20 30 40 50 65 80 95 ; do
    for SEED in {1..50} ; do
    mkdir -p $OUT_DIR/$WL/$SPLIT
    echo "[case_study_2.sh] Starting workload $WL, split $SPLIT, seed $SEED"
    python3 split_data.py $SPLIT $SEED $WL_PATH "$WL-$SPLIT-$SEED-split.json"
    echo "[case_study_2.sh] Split data; seed used was $SEED, train test % was $SPLIT"
    echo "Running Stitch"
    #/usr/bin/time -v $STITCH_DIR/target/release/compress "$WL-$SPLIT-$SEED-split.json" --hole-choice=last --heap-choice=max-bound --verbose-best --fmt=split-programs-list --split-train-test --max-arity=3 --iterations=1 --no-mismatch-check --out=$OUT_DIR/$WL/$SPLIT/$SEED.json > $OUT_DIR/$WL/$SPLIT/$SEED.stderrandout 2>&1 &
    /usr/bin/time -v $STITCH_DIR/target/release/compress "$WL-$SPLIT-$SEED-split.json" --hole-choice=last --heap-choice=max-bound --fmt=split-programs-list --split-train-test --max-arity=3 --iterations=1 --no-mismatch-check --out=$OUT_DIR/$WL/$SPLIT/$SEED.json > $OUT_DIR/$WL/$SPLIT/$SEED.stderrandout 2>&1 &
    done
    wait  # move this up/down between loops to change how many jobs to run at once
    rm -v *-split.json
    done
done


echo "Done: $OUT_DIR"
