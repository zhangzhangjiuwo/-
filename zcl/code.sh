#!/bin/bash

#---使用bedtools intersect寻找两个文件的交集

plink --merge-list /BIGDATA2/scau_hzhang_1/Pig_GTEx/ref_WGS_panel_chr/plink2_format/list.txt --make-bed --out /BIGDATA2/scau_hzhang_1/USER/xzt/LeadSNP_LD/PGRP_v1
