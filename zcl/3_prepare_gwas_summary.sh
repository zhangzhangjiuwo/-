#!/bin/bash
cd /BIGDATA2/scau_hzhang_1/USER/tengjy/Pig_GTEx_GWAS_and_eQTLs/SMR
mkdir ./PreDATA/gwas_summary

files=(`ls /BIGDATA2/scau_hzhang_1/Pig_GTEx/metaGWAS_summary_v2/formatted_summary/*/*.gz`)
# files=("BODYL.txt.gz" "D21WT.txt.gz")
echo ${#files[@]} 
# for i in {0..191}
for i in {0..191}
do
{
    trait=${files[i]/*harmonized_gwas_/}
    trait=${trait/_se_metal.txt.gz/}
    trait=${trait/_fastgwa_gcta.txt.gz/}
    echo ${i}
    echo ${trait}
    file=${files[i]}
    zcat ${file} | awk -F"\t" '{print $1" "$5" "$6" "$7" "$10" "$11" "$8" "$12}' | sed 's/variant_id effect_allele non_effect_allele frequency effect_size standard_error pvalue sample_size/SNP A1 A2 freq b se p N/g' > ./PreDATA/gwas_summary/${trait}.ma
} &
done
wait

