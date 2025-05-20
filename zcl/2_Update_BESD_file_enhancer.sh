#!/bin/bash
cd /BIGDATA2/scau_hzhang_1/USER/tengjy/Pig_GTEx_GWAS_and_eQTLs/SMR

for f in `ls ./PreDATA/BESD_file_enhancer/*.enqtl_allpairs.* | grep -P "epi|esi"`
do
    mv $f ${f}.old
done

./2_Update_BESD_file_enhancer.R