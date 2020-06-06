# plink-182: "Assessing PCA Alternatives for Representing and Controlling for Population Stratification"

Group Members: Anubhav Singh Sachan, Marcus Fedarko

This repository holds our code for data simulation and evaluation for
benchmarking various dimensionality reduction methods on genotyping data.

(Note: in the process of doing merging, the git history got messed up a bit -- a lot of commits got duplicated in the history for some reason. So it's closer to 50 total commits than 100 :)

## Dataset

We're using genotyping data from phase 3 of the
[1000 Genomes Project](https://www.internationalgenome.org/) for benchmarking.
To save computational resources, we're just focusing on data from chromosome 21.
For the sake of simplicity, we're also omitting variants that match a number of
criteria, which are described in detail
[here](https://nbviewer.jupyter.org/github/fedarko/plink-182/blob/master/notebooks/01-Load-Data.ipynb#bcftools-query-options).

All told, our genotyping "matrix" includes 2,504 samples and 170,073 SNPs (aka "features").

### Re: data files included / not included in this repository

Some of the data files used / generated in the notebooks in this repository are
not actually included in this repository, due to being prohibitively large (this includes
the initial `vcf.gz` file, the filtered `vcf.gz` file with just the SNPs we're using, and
the genotyping matrix file). Once this notebook is cloned to a home directory on UCSD's
[DataHub](http://datahub.ucsd.edu/) site, rerunning the first notebook (`01-Load-Data.ipynb`) should
generate all of the necessary files. (You may need to rerun 

## Dimensionality reduction methods to test

| Method name | Availability | (Hyper)parameters to look into |
| --- | --- | --- |
| PCA | scikit-learn | [Whitening](http://ufldl.stanford.edu/tutorial/unsupervised/PCAWhitening/) |
| PCoA | scikit-bio | [Metrics](http://scikit-bio.org/docs/latest/generated/skbio.diversity.beta_diversity.html?highlight=beta_diversity#skbio.diversity.beta_diversity) (Jaccard, Bray-Curtis, ...) |
| t-SNE | scikit-learn | [Metrics, Perplexity, Epsilon, etc.](https://towardsdatascience.com/how-to-tune-hyperparameters-of-tsne-7c0596a18868) |
| UMAP | umap-learn | [Metrics, # Neighbors, Minimum Distance, etc.](https://umap-learn.readthedocs.io/en/latest/parameters.html)

(It's probably worth noting that we use the term "hyperparameter" interchangeably with "parameter" throughout this repository. Sorry.)

## What the directories in this repository contain

- **`notebooks`:** This directory contains a set of Jupyter Notebooks that perform steps 1, 2, 2.5, and 3 in the "Software Components" section below.
- **`GWASminiProject`:** This directory contains a set of Jupyter Notebooks that perform steps 4.1, 4.2, and 4.3 in the "Software Components" section below. It also contains some additional files produced in the course of running these notebooks.
- **`data`:** This directory contains some (but not all) of the data files generated in the `Data loading` and `GWASminiProject` notebooks.
  - It also contains `data/pop_to_superpop.tsv`, a simple TSV file which was copied directly from
[this page](https://www.internationalgenome.org/faq/which-populations-are-part-your-study/) of the 1000
Genomes Project website.
- **`dr_outputs`:** This directory contains files describing the sample "coordinates" for all of the dimensionality reduction method + hyperparameter combinations run. Each file should be loadable using [`numpy.loadtxt()`](https://numpy.org/doc/1.18/reference/generated/numpy.loadtxt.html) -- rows indicate samples (in the same order as in `data/sample_ids.txt`), and columns indicate axes / PCs in the reduced dataset (for PCA and PCoA, these columns are in descending order of the proportion of variance explained: so the first column is PC 1, the second is PC 2, etc.).
- **`cov_dr_outputs`**: This directory contains versions of the files in `dr_outputs` represented in plink's `.cov` format.
- **`dr_output_visualizations`**: This directory contains visualizations of many of the UMAP `dr_outputs` files. It also contains a short script, [`make_umap_gifs.py`](https://github.com/fedarko/plink-182/blob/master/dr_output_visualizations/make_umap_gifs.py), which uses [ImageMagick](https://imagemagick.org/index.php)'s command-line interface to create animated GIFs of the UMAP results (showing how increasing the `n_neighbors` parameter changes a UMAP visualization, given a constant `metric` and `min_dist` parameter).
  - Visualizations of the non-UMAP DR methods (PCA, PCoA, t-SNE) are rendered in notebook 2, described below.

## Software components

Note that, as mentioned above, many of the notebooks linked here use filepaths specific to
UCSD's DataHub site as it was set up in the Spring 2020 quarter. These notebooks will
therefore need to be modified in order to work with arbitrary datasets, or on other systems.

### 1. [Data loading](https://nbviewer.jupyter.org/github/fedarko/plink-182/blob/master/notebooks/01-Load-Data.ipynb)
Load genotyping data from 1000 Genomes from `vcf.gz` into a format that's easier
to work with for dimensionality reduction. Also, filter out certain types of variants.

### 2. [Run dimensionality reduction](https://nbviewer.jupyter.org/github/fedarko/plink-182/blob/master/notebooks/02-Run-Dimensionality-Reduction.ipynb)
Given the genotyping matrix that was produced from the "Data loading" notebook,
run it through the full "suite" of methods + hyperparameters to test.
This will produce one set of results (sample coordinates) per method + hyperparameter combination.

#### 2.5. [Convert dimensionality reduction results to plink's `.cov` format](https://nbviewer.jupyter.org/github/fedarko/plink-182/blob/master/notebooks/02.5-Convert-DR-Outputs-To-Plink-Format.ipynb)
Just a small step that will help with the GWAS work later.

### 3. [Evaluate dimensionality reduction results for _representing_ population stratification](https://nbviewer.jupyter.org/github/fedarko/plink-182/blob/master/notebooks/03-Evaluate-Representation.ipynb)
Given the 2D visualization produced by each dimensionality reduction method + hyperparameter
combination, use HBDSCAN\* to see how samples in this space "cluster" -- and evaluate how similar
these clusters are to the "ground truth" superpopulations.

### 4. Evaluate dimensionality reduction results for _controlling for_ population stratification

#### 4.1. [Simulate phenotype data](https://nbviewer.jupyter.org/github/fedarko/plink-182/blob/master/GWASminiProject/1.%20PhenotypeSimulation.ipynb)

#### 4.2. [Run GWASs on the simulated phenotypes using plink, with some of the dimensionality reduction results as covariates](https://nbviewer.jupyter.org/github/fedarko/plink-182/blob/master/GWASminiProject/2.%20plink%20runs.ipynb)

#### 4.3. [Create Manhattan and QQ plots for the GWASs](https://nbviewer.jupyter.org/github/fedarko/plink-182/blob/master/GWASminiProject/3.%20Create%20Plots.ipynb)
This helps us see how each method + hyperparameter set + PC count performed.

Note that the plotting code in this notebook was adapted from PSET 3.
