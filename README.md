# plink-182: "Assessing PCA Alternatives for Representing and Controlling for Population Stratification"

Group Members: Anubhav Singh Sachan, Marcus Fedarko

This repository will hold our code for data simulation and evaluation for
benchmarking various dimensionality reduction methods on genotyping data.

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
generate all of the necessary files.

### Data acknowledgements

As mentioned above, the data we used is from phase 3 of the 1000 Genomes Project.

`data/pop_to_superpop.tsv` was copied directly from
[this page](https://www.internationalgenome.org/faq/which-populations-are-part-your-study/) of the 1000
Genomes Project website.

## Dimensionality reduction methods to test

| Method name | Availability | (Hyper)parameters to look into |
| --- | --- | --- |
| PCA | scikit-learn | [Whitening](http://ufldl.stanford.edu/tutorial/unsupervised/PCAWhitening/) |
| PCoA | scikit-bio | [Metrics](http://scikit-bio.org/docs/latest/generated/skbio.diversity.beta_diversity.html?highlight=beta_diversity#skbio.diversity.beta_diversity) (Jaccard, Bray-Curtis, ...) |
| t-SNE | scikit-learn | [Metrics, Perplexity, Epsilon, etc.](https://towardsdatascience.com/how-to-tune-hyperparameters-of-tsne-7c0596a18868) |
| UMAP | umap-learn | [Metrics, # Neighbors, Minimum Distance, etc.](https://umap-learn.readthedocs.io/en/latest/parameters.html)

## Software components

Not a comprehensive list, but we'll likely have to knock out all of these modules.

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

Probably it would be easiest to just get a list / barplot / etc. showing how the various method +
hyperparameter combinations all perform.

### 4. Evaluate dimensionality reduction results for _controlling for_ population stratification
This is going to be the more involved of the two evaluation steps, probably.

#### 4.1. Simulate phenotype data
Use GCTA / HAPGEN2 / etc.

#### 4.2. Run GWASs on the simulated phenotypes using the dimensionality reduction results as covariates
Using plink, probably (hence the project name :)

We will probably want to run multiple GWASs per method + hyperparameter set -- so that we can use different amounts of PCs and see how this impacts the GWASs. Something like the top 1, 2, 5, 10, 15 PCs (I dunno) might be good. If possible, using EIGENSOFT to figure out a "statistically significant" number of PCs and using that number here would be interesting.

Anyway, after running a GWAS, we should figure out the number of true and false hits. We should output these to a file or something, or otherwise store them somewhere.

#### 4.3. Analyze results
See how each method + hyperparameter set + PC count performed.

### 5. Test Suite (we may not have time for this)
For each of these steps, we should make an effort (where feasible) to split things up into small functions that we can add tests for. This isn't very critical, but it'll be a nice thing to have. Eventually we can set up Travis for continuous integration testing, etc.
