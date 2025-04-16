
snakemake \
-s /rhome/naotok/SnakeNgs/snakefile/preprocessing_RNAseq.smk \
--configfile config_preprocessing.yaml \
--cores 32 \
--use-singularity \
--singularity-args "--bind $HOME:$HOME" \
--rerun-incomplete
