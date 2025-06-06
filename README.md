# Ptbp1_astrocyte_2025

This repository contains the data analysis code used in the manuscript:

PTBP1 Depletion in Mature Astrocytes Reveals Distinct Splicing Alterations Without Neuronal Features<br>
Min Zhang<sup>#</sup>, Naoto Kubota<sup>#</sup>, David Nikom<sup>#</sup>, Ayden Arient, Sika Zheng. (<sup>#</sup>Equal contribution)<br>
bioRxiv 2025.05.30.657115; doi: https://doi.org/10.1101/2025.05.30.657115

## Dependencies

### Snakemake pipeline

- [preprocessing_RNAseq.smk](https://naotokubota.github.io/SnakeNgs/usage/preprocessing_RNAseq/) and [kb-nac.smk](https://naotokubota.github.io/SnakeNgs/usage/kb-nac/) in [SnakeNgs](https://github.com/NaotoKubota/SnakeNgs) (v0.2.0)
- SnakeShiba in [Shiba](https://github.com/Sika-Zheng-Lab/Shiba) (v0.4.0)

### Docker image

- [naotokubota/my_notebook:1.6.3](https://hub.docker.com/repository/docker/naotokubota/my_notebook)
- [naotokubota/scanpy_jupyter:1.3.9](https://hub.docker.com/repository/docker/naotokubota/scanpy_jupyter)
