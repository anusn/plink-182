CHR_21_VCF_GZ=/datasets/cs284s-sp20-public/1000Genomes/ALL.chr21.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz

bcftools query -e'AF<0.01' -e'AF>0.99' -e'MULTI_ALLELIC=1' -f "[%GT\t]\n" $CHR_21_VCF_GZ | \
  sed 's/0|0/0/g' | sed 's/0|1/1/g' | sed 's/1|0/1/g' | sed 's/1|1/2/g'
  > /home/mfedarko/project/chr_21_genotypes.tab
