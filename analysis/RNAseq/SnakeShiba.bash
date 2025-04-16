
snakemake \
-s /rhome/naotok/Shiba/SnakeShiba \
--configfile config_Shiba.yaml \
--cores 32 \
--use-singularity \
--singularity-args "--bind $HOME:$HOME" \
--rerun-incomplete
