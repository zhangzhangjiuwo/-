#!/bin/bash
cd /BIGDATA2/scau_hzhang_1/USER/tengjy/Pig_GTEx_GWAS_and_eQTLs/SMR
mkdir PreDATA
mkdir ./PreDATA/FastQTL_format_pcg/
mkdir ./PreDATA/BESD_file_pcg/

tis_main_final=("Adipose" "Large_intestine" "Small_intestine" "Blood" "Fetal_thymus" "Lymph_node" "Milk" "Spleen" "Cartilage" "Synovial_membrane" "Brain" "Embryo" "Heart" "Kidney" "Liver" "Lung" "Testis" "Muscle" "Oocyte" "Artery" "Ovary" "Uterus" "Placenta")
tis_sub_final=("Colon" "Duodenum" "Ileum" "Jejunum" "Macrophage" "Frontal_cortex" "Hypothalamus" "Pituitary" "Blastocyst" "Blastomere" "Morula")
tis_names=(${tis_main_final[*]} ${tis_sub_final[*]})

# for tis_i in {1..33}
# do
# {
    # tissue=${tis_names[tis_i]}
    # echo $tis_i
    # echo $tissue
    # zcat /BIGDATA2/scau_hzhang_1/USER/tengjy/Pig_GTEx_pcg/eqtl_mapping/allpairs_pcg/${tissue}.eqtl_allpairs.txt.gz | awk -F"\t" 'FNR>1{print $1"\t"$2"\t"$3"\t"$7"\t"$8}' | pigz > ./PreDATA/FastQTL_format_pcg/${tissue}.eqtl_allpairs.txt.gz
# }
# done
# wait
# zcat /BIGDATA2/scau_hzhang_1/USER/tengjy/Pig_GTEx_GWAS_and_eQTLs/SMR/PreDATA/FastQTL_format_pcg/Fetal_thymus.eqtl_allpairs.txt.gz | awk -F"\t" '{if($5!="")print $0}' | pigz > /BIGDATA2/scau_hzhang_1/USER/tengjy/Pig_GTEx_GWAS_and_eQTLs/SMR/PreDATA/FastQTL_format_pcg/Fetal_thymus.eqtl_allpairs2.txt.gz
# rm /BIGDATA2/scau_hzhang_1/USER/tengjy/Pig_GTEx_GWAS_and_eQTLs/SMR/PreDATA/FastQTL_format_pcg/Fetal_thymus.eqtl_allpairs.txt.gz
# mv /BIGDATA2/scau_hzhang_1/USER/tengjy/Pig_GTEx_GWAS_and_eQTLs/SMR/PreDATA/FastQTL_format_pcg/Fetal_thymus.eqtl_allpairs2.txt.gz /BIGDATA2/scau_hzhang_1/USER/tengjy/Pig_GTEx_GWAS_and_eQTLs/SMR/PreDATA/FastQTL_format_pcg/Fetal_thymus.eqtl_allpairs.txt.gz

for tis_i in ${1}
do
{
    tissue=${tis_names[tis_i]}
    echo $tis_i
    echo $tissue
    smr --eqtl-summary ./PreDATA/FastQTL_format_pcg/${tissue}.eqtl_allpairs.txt.gz --fastqtl-nominal-format --make-besd --out ./PreDATA/BESD_file_pcg/${tissue}.eqtl_allpairs
    rm ./PreDATA/FastQTL_format_pcg/${tissue}.eqtl_allpairs.txt.gz
}
done
wait

rm -r /BIGDATA2/scau_hzhang_1/USER/tengjy/Pig_GTEx_GWAS_and_eQTLs/SMR/PreDATA/FastQTL_format_pcg

# for i in {1..33}
# do
# yhbatch -p bigdata -J tjy$i ./prepare_smr.sh $i
# done
# wait

