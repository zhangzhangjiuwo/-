#!/bin/bash
cd /BIGDATA2/scau_hzhang_1/USER/tengjy/Pig_GTEx_GWAS_and_eQTLs/SMR
mkdir output_SMR_lnc_PGRP

# bfile=/BIGDATA2/scau_hzhang_1/USER/tengjy/Pig_GTEx_GWAS_and_eQTLs/DLY120_VCF/DLY120
bfile=/BIGDATA2/scau_hzhang_1/Pig_GTEx/ref_WGS_panel_chr/PGRP

tis_main_final=("Adipose" "Large_intestine" "Small_intestine" "Blood" "Fetal_thymus" "Lymph_node" "Milk" "Spleen" "Cartilage" "Synovial_membrane" "Brain" "Embryo" "Heart" "Kidney" "Liver" "Lung" "Testis" "Muscle" "Oocyte" "Artery" "Ovary" "Uterus" "Placenta")
tis_sub_final=("Colon" "Duodenum" "Ileum" "Jejunum" "Macrophage" "Frontal_cortex" "Hypothalamus" "Pituitary" "Blastocyst" "Blastomere" "Morula")
tis_names=(${tis_main_final[*]} ${tis_sub_final[*]})

gwasfiles=(`ls ./PreDATA/gwas_summary/*.ma`)

# {0..33}
tis_i=${1}

tissue=${tis_names[tis_i]}
echo $tis_i
echo $tissue
mkdir ./output_SMR_lnc_PGRP/${tissue}

#/////////////////////////////////////////////////////#
#并发数
threadTask=2  # <<<--- 设置并行数 ！！！
#创建fifo管道
fifoFile="test_fifo"
rm -f ${fifoFile}
mkfifo ${fifoFile}
# 建立文件描述符关联
exec 9<> ${fifoFile}
rm -f ${fifoFile}
# 预先向管道写入数据
for ((i=0;i<${threadTask};i++))
do
    echo "" >&9
done
echo "wait all task finish,then exit!!!"
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\#
# for gf_i in ${2}
for gf_i in {0..191}
do
read -u9              # <<<--- 添加该行
{                     # <<<--- 添加该行
    gf=${gwasfiles[gf_i]}
    trait=${gf/"./PreDATA/gwas_summary/"/}
    trait=${trait/.ma/}
    echo $gf_i
    echo $trait
    if [ ! -f "./PreDATA/gwas_summary/${trait}.ma" ]; then
        echo "[Skipping] Can not find the ${trait}.ma in ./PreDATA/gwas_summary/"
        exit 1
    fi
    
    besdprefix=./PreDATA/BESD_file_lnc/${tissue}.lncqtl_allpairs
    smr --bfile ${bfile} --gwas-summary ${gf} --beqtl-summary ${besdprefix} --diff-freq 0.5 --diff-freq-prop 0.05 --out ./output_SMR_lnc_PGRP/${tissue}/${tissue}.lnc.${trait} --thread-num 23
    echo "" >&9      # <<<--- 添加该行
} &                  # <<<--- 添加该行
done
wait                 # <<<--- 添加该行

