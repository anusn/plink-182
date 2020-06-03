#!/usr/bin/env python3
from subprocess import call
metrics = ["jaccard", "braycurtis", "canberra", "manhattan", "hamming"]
min_dists = [0.25, 0.5]

for md in min_dists:
    for m in metrics:
        call("convert -delay 200 -alpha set -dispose 2 UMAP_HPS_metric_{}_min_dist_{}_n_neighbors_*.png {}md{}.gif".format(m, md, m, md), shell=True)
