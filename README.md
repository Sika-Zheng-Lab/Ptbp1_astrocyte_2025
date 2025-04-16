# Ptbp1_astrocyte_2025

This repository contains the data analysis code used in the manuscript:

Genetic Ptbp1 depletion does not induce neuronal RNA splicing patterns in mature astrocytes. <br>
Min Zhang, Naoto Kubota, David Nikom, Ayden Arient, Sika Zheng.<br>
2025.

## Dependencies

### Snakemake pipeline

- [preprocessing_RNAseq.smk](https://naotokubota.github.io/SnakeNgs/usage/preprocessing_RNAseq/) and [kb-nac.smk](https://naotokubota.github.io/SnakeNgs/usage/kb-nac/) in [SnakeNgs](https://github.com/NaotoKubota/SnakeNgs) (v0.2.0)
- SnakeShiba in [Shiba](https://github.com/Sika-Zheng-Lab/Shiba) (v0.4.0)

### Docker image

- [naotokubota/my_notebook:1.6.3](https://hub.docker.com/repository/docker/naotokubota/my_notebook)
- [naotokubota/scanpy_jupyter:1.3.9](https://hub.docker.com/repository/docker/naotokubota/scanpy_jupyter)
