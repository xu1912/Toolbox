fn="GO_Quad"
~/bin/plink --bfile $fn --geno 0.1 --maf 0.05 --hwe 0.00001 --write-snplist --out $fn

##### Prepare a common_snp_list.txt having 1 column showing the SNP rs id of the common ones in 4 studies.
~/bin/plink --bfile $fn --extract common_snp_list.txt --make-bed --out $fn"_com"

##Filter individuals with missing SNPs > 5%.
~/bin/plink --bfile $fn"_com" --mind 0.05 --make-bed --out $fn"_com_f"

fn="GO_Omni"
~/bin/plink --bfile $fn --geno 0.1 --maf 0.05 --hwe 0.00001 --write-snplist --out $fn
~/bin/plink --bfile $fn --extract common_snp_list.txt --make-bed --out $fn"_com"
~/bin/plink --bfile $fn"_com" --mind 0.05 --make-bed --out $fn"_com_f"
fn="GO_v1"
~/bin/plink --bfile $fn --geno 0.1 --maf 0.05 --hwe 0.00001 --write-snplist --out $fn
~/bin/plink --bfile $fn --extract common_snp_list.txt --make-bed --out $fn"_com"
~/bin/plink --bfile $fn"_com" --mind 0.05 --make-bed --out $fn"_com_f"
fn="GO_v3"
~/bin/plink --bfile $fn --geno 0.1 --maf 0.05 --hwe 0.00001 --write-snplist --out $fn
~/bin/plink --bfile $fn --extract common_snp_list.txt --make-bed --out $fn"_com"
~/bin/plink --bfile $fn"_com" --mind 0.05 --make-bed --out $fn"_com_f"


#### Merge 4 studies
~/bin/plink --bfile GO_v3_com_f --merge-list mergefiles.txt --make-bed --out merged_GO

#### Update SNP position using Reference "all_refSNP.map"
~/bin/plink --bfile merged_GO --update-chr all_refSNP.map 1 3 --update-map all_refSNP.map 2 3 --update-alleles ALL.SHAPEIT2_phase1_snp.list --make-bed --out merged_GO_refSNP_corrected

#### Recode to VCF format for Phasing. Divide whole genome data into chromsomes 1 to 22 denoted by $SLURM_ARRAY_TASK_ID.
~/bin/plink --bfile merged_GO_refSNP_corrected --chr $SLURM_ARRAY_TASK_ID --recode vcf  --out merged_GO_vcf_chr$SLURM_ARRAY_TASK_ID

#### Phasing and convert to VCF format for imputation.
~/bin/shapeit -T 2 --main 20 -V merged_GO_vcf_chr$SLURM_ARRAY_TASK_ID.vcf -M genetic_map/genetic_map_chr$SLURM_ARRAY_TASK_ID"_combined_b37.txt" -O chr$SLURM_ARRAY_TASK_ID"_phased.out"
~/bin/shapeit -convert --input-haps chr$SLURM_ARRAY_TASK_ID"_phased.out" --output-vcf chr$SLURM_ARRAY_TASK_ID"_phased.vcf"

#### Imputation.
~/bin/Minimac3-omp --cpus 4 --rsid --refHaps /lustre/project/hdeng2/xc/ref/ALL.chr$SLURM_ARRAY_TASK_ID.SHAPEIT2_integrated_phase1_v3.20101123.snps_indels_svs.genotypes.all.noMono.vcf.gz --haps chr$SLURM_ARRAY_TASK_ID"_phased.vcf" --prefix chr$SLURM_ARRAY_TASK_ID"_impute_rsid" --doseOutput

#### Convert imputation output dosage file to plink format. Imputaiton quality control set as R2>0.6.
gzip -c chr$SLURM_ARRAY_TASK_ID"_impute_rsid.info" > chr$SLURM_ARRAY_TASK_ID"_impute_rsid.info.gz"
~/bin/gcta64 --dosage-mach-gz chr$SLURM_ARRAY_TASK_ID"_impute_rsid.dose.gz" chr$SLURM_ARRAY_TASK_ID"_impute_rsid.info.gz" --imput-rsq 0.6 --extract common_snp_list.txt --make-bed --out chr$SLURM_ARRAY_TASK_ID"_imputed_f"

#### Megre chromosomes 1 to 22 into one file.
~/bin/plink --bfile chr1_imputed_f --merge-list merge_chr_files.txt --make-bed --out merged_imputed

#### Fill in SNP position info. The info missed after imputation.
~/bin/plink --bfile merged_imputed --update-chr all_refSNP.map 1 3 --update-map all_refSNP.map 2 3 --make-bed --out merged_imputed_pos_corc

#### Prepare for gene annotation.
awk '{print $1"\t"$4"\t"$2}' merged_imputed_pos_corc.bim > merged_imputed_snp.map

#### Gene annotation
~/bin/plink --annotate merged_imputed_snp.map ranges=glist-hg19 --out merged_imputed_snp_gene

#### Get snp list in gene region.
grep "(0)" merged_imputed_snp_gene.annot > merged_imputed_snp_in_gene.annot

#### Extract SNPs in gene region and pruning using LD > 0.9.
~/bin/plink --bfile merged_imputed_pos_corc --extract merged_imputed_snp_in_gene.list --indep-pairwise 50 5 0.9 --make-bed --out merged_imputed_in_gene
~/bin/plink --bfile merged_imputed_in_gene --extract merged_imputed_in_gene.prune.in --make-bed --out merged_imputed_in_gene_pruned_0.9

#### Prepare for gene annotation for SNPs passed LD pruning.
awk '{print $1"\t"$4"\t"$2}' merged_imputed_in_gene_pruned_0.9.bim > merged_imputed_in_gene_pruned_0.9_snp.map

#### Gene annotation
~/bin/plink --annotate merged_imputed_in_gene_pruned_0.9_snp.map ranges=glist-hg19 --out merged_imputed_in_gene_pruned_0.9_snp
