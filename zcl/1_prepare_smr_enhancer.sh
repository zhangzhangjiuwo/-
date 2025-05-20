#!/bin/bash
cd /BIGDATA2/scau_hzhang_1/USER/tengjy/Pig_GTEx_GWAS_and_eQTLs/SMR
mkdir PreDATA
mkdir ./PreDATA/FastQTL_format_enhancer/
mkdir ./PreDATA/BESD_file_enhancer/

tis_main_final=("Adipose" "Large_intestine" "Small_intestine" "Blood" "Fetal_thymus" "Lymph_node" "Milk" "Spleen" "Cartilage" "Synovial_membrane" "Brain" "Embryo" "Heart" "Kidney" "Liver" "Lung" "Testis" "Muscle" "Oocyte" "Artery" "Ovary" "Uterus" "Placenta")
tis_sub_final=("Colon" "Duodenum" "Ileum" "Jejunum" "Macrophage" "Frontal_cortex" "Hypothalamus" "Pituitary" "Blastocyst" "Blastomere" "Morula")
tis_names=(${tis_main_final[*]} ${tis_sub_final[*]})

# for tis_i in {1..33}
for tis_i in ${1}
do
{
    tissue=${tis_names[tis_i]}
    echo $tis_i
    echo $tissue
    rm ./PreDATA/FastQTL_format_enhancer/${tissue}.enqtl_allpairs.txt.gz
    for CHR in {1..18}
    do
        echo $CHR
        zcat /BIGDATA2/scau_hzhang_1/USER/tengjy/Pig_GTEx_enhancer/eqtl_mapping/output_enhancer/${tissue}/${tissue}.cis_qtl_pairs.${CHR}.txt.gz | awk -F"\t" 'FNR>1{if($8!="")print $1"\t"$2"\t"$3"\t"$7"\t"$8}' | pigz >> ./PreDATA/FastQTL_format_enhancer/${tissue}.enqtl_allpairs.txt.gz
    done
}
done
wait

for tis_i in ${1}
do
{
    tissue=${tis_names[tis_i]}
    echo $tis_i
    echo $tissue
    smr --eqtl-summary ./PreDATA/FastQTL_format_enhancer/${tissue}.enqtl_allpairs.txt.gz --fastqtl-nominal-format --make-besd --out ./PreDATA/BESD_file_enhancer/${tissue}.enqtl_allpairs
    rm ./PreDATA/FastQTL_format_enhancer/${tissue}.enqtl_allpairs.txt.gz
}
done
wait

# rm -r /BIGDATA2/scau_hzhang_1/USER/tengjy/Pig_GTEx_GWAS_and_eQTLs/SMR/PreDATA/FastQTL_format_enhancer

# for i in {0..33}
# do
# yhbatch -p bigdata -J tjy$i ./1_prepare_smr_enhancer.sh $i
# done
# wait

