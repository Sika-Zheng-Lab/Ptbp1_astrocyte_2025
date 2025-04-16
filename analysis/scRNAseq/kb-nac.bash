
snakemake -s /rhome/naotok/SnakeNgs/snakefile/kb-nac.smk \
--configfile config_kb-nac.yaml \
--cores 32 \
--use-singularity \
--singularity-args "--bind $HOME:$HOME" \
--rerun-incomplete
