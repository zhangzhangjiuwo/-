#!/bin/bash
cd /BIGDATA2/scau_hzhang_1/USER/tengjy/Pig_GTEx_GWAS_and_eQTLs/SMR/SMR_plot
mkdir output_SMR_plot_lnc

# prepare glist
# awk -F"\t" 'FNR>1{if($2<=18)print $2" "$3" "$4" "$1" "$5}' /BIGDATA2/scau_hzhang_1/USER/tengjy/Pig_GTEx_exon_lnc/data/novel_lncrna.saf > Sus_scrofa.Sscrofa11.1.100.lncRNA.glist

bfile=/BIGDATA2/scau_hzhang_1/Pig_GTEx/ref_WGS_panel_chr/PGRP

pairs=($(cat passing_pairs_lnc.txt))
echo ${#pairs[@]}


#/////////////////////////////////////////////////////#
#并发数
threadTask=5  # <<<--- 设置并行数 ！！！
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
for i in {0..169}; do
read -u9              # <<<--- 添加该行
{                     # <<<--- 添加该行
    echo ${pairs[i]}
    OLD_IFS="$IFS"
    IFS=","
    arr=(${pairs[i]})
    IFS="$OLD_IFS"
    
    tissue=${arr[0]}
    trait=${arr[1]}
    gene=${arr[2]}
    gwasfile=/BIGDATA2/scau_hzhang_1/USER/tengjy/Pig_GTEx_GWAS_and_eQTLs/SMR/PreDATA/gwas_summary/${trait}.ma
    besdprefix=/BIGDATA2/scau_hzhang_1/USER/tengjy/Pig_GTEx_GWAS_and_eQTLs/SMR/PreDATA/BESD_file_lnc/${tissue}.lncqtl_allpairs
    smr --bfile ${bfile} --gwas-summary ${gwasfile} --beqtl-summary ${besdprefix} --diff-freq 0.5 --diff-freq-prop 0.05 --out ./output_SMR_plot_lnc/${tissue}-${trait}-${gene}.SMR_plot_lnc --plot --probe ${gene} --probe-wind 1000 --gene-list Sus_scrofa.Sscrofa11.1.100.lncRNA.glist
    echo "" >&9      # <<<--- 添加该行
} &                  # <<<--- 添加该行
done
wait                 # <<<--- 添加该行

