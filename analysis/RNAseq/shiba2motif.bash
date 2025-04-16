
snakemake \
-s shiba2motif.smk \
--configfile config_shiba2motif.yaml \
--cores 32 \
--use-singularity \
--singularity-args "--bind $HOME:$HOME" \
--rerun-incomplete
