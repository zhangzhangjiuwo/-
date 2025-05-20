#!/bin/bash
cd /BIGDATA2/scau_hzhang_1/USER/tengjy/Pig_GTEx_GWAS_and_eQTLs/SMR/SMR_plot

yhbatch -p rhenv -J tjyP SMR_plot_pcg.sh
yhbatch -p rhenv -J tjyL SMR_plot_lnc.sh



