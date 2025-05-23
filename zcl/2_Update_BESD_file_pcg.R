library(data.table)
"%&%" = function(a,b) paste0(a,b)
annot = fread("/BIGDATA2/scau_hzhang_1/USER/tengjy/Pig_GTEx_eQTL/eqtl_mapping/Sus_scrofa.Sscrofa11.1.100.tss.gz")
annot_gtf = fread("/BIGDATA2/scau_hzhang_1/USER/tengjy/Pig_GTEx_GWAS_and_eQTLs/QTLEnrich/PreDATA/Sus_scrofa.Sscrofa11.1.100.gene.gtf")

tis_main_final = c("Adipose", "Large_intestine", "Small_intestine", "Blood", "Fetal_thymus", "Lymph_node", "Milk", "Spleen", "Cartilage", "Synovial_membrane", "Brain", "Embryo", "Heart", "Kidney", "Liver", "Lung", "Testis", "Muscle", "Oocyte", "Artery", "Ovary", "Uterus", "Placenta")
tis_sub_final = c("Colon", "Duodenum", "Ileum", "Jejunum", "Macrophage", "Frontal_cortex", "Hypothalamus", "Pituitary", "Blastocyst", "Blastomere", "Morula")
tis_names = c(tis_main_final, tis_sub_final)

for (i in 1:34){
    tis = tis_names[i]
    message(tis)
    frq = fread("/BIGDATA2/scau_hzhang_1/USER/tengjy/Pig_GTEx_eQTL/snp_maf/maf/" %&% tis %&% ".geno.frq.gz")
    esi = fread("/BIGDATA2/scau_hzhang_1/USER/tengjy/Pig_GTEx_GWAS_and_eQTLs/SMR/PreDATA/BESD_file_pcg/" %&% tis %&% ".eqtl_allpairs.esi.old")
    epi = fread("/BIGDATA2/scau_hzhang_1/USER/tengjy/Pig_GTEx_GWAS_and_eQTLs/SMR/PreDATA/BESD_file_pcg/" %&% tis %&% ".eqtl_allpairs.epi.old")

    matIdx = match(esi$V2,frq$SNP)
    esi$V1 = frq$CHR[matIdx]
    esi$V5 = frq$A1[matIdx]
    esi$V6 = frq$A2[matIdx]
    esi$V7 = frq$MAF[matIdx]
    esi$V4 = gsub("^[0-9]+_|_(A|T|C|G)","",esi$V2)
    fwrite(esi,"/BIGDATA2/scau_hzhang_1/USER/tengjy/Pig_GTEx_GWAS_and_eQTLs/SMR/PreDATA/BESD_file_pcg/" %&% tis %&% ".eqtl_allpairs.esi", col.names=F, sep = "\t")


    annotIdx = match(epi$V2,annot$gene_id)
    epi$V1 = annot$`#chr`[annotIdx]
    epi$V4 = annot$end[annotIdx]
    epi$V5 = epi$V2
    epi$V6 = annot_gtf$strand[match(epi$V2,annot_gtf$gene_id)]
    fwrite(epi,"/BIGDATA2/scau_hzhang_1/USER/tengjy/Pig_GTEx_GWAS_and_eQTLs/SMR/PreDATA/BESD_file_pcg/" %&% tis %&% ".eqtl_allpairs.epi", col.names=F, sep = "\t")
}
