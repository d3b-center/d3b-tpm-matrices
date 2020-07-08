# 01. Collapse RNA-seq
# PNOC003 Cohort3a polya
Rscript code/01-collapse-matrices.R \
--mat data/cohort3a_subset-gene-expression-rsem-tpm.polya.rds \
--gene_sym FALSE \
--outfile cohort3a_subset-gene-expression-rsem-tpm.collapsed.polya.rds

# PNOC003 Cohort3a stranded
Rscript code/01-collapse-matrices.R \
--mat data/cohort3a_subset-gene-expression-rsem-tpm.stranded.rds \
--gene_sym FALSE \
--outfile cohort3a_subset-gene-expression-rsem-tpm.collapsed.stranded.rds

# 02. Combine collapsed matrices (Cohort 3a + GTEx + TGEN)
Rscript code/02-combine-matrices.R \
--matrices "results/cohort3a_subset-gene-expression-rsem-tpm.collapsed.polya.rds, results/cohort3a_subset-gene-expression-rsem-tpm.collapsed.stranded.rds, results/gtex-brain-normals-gene-expression-rsem-tpm.collapsed.polya.rds, results/tgen-brain-normals-gene-expression-rsem-tpm.collapsed.polya.rds" \
--outfile pnoc003-cohort3a-gtex-tgen-gene-expression-rsem-tpm.rds

# 02. Combine collapsed matrices for immune deconvolution (Cohort 3a polyA + stranded)
Rscript code/02-combine-matrices.R \
--matrices "results/cohort3a_subset-gene-expression-rsem-tpm.collapsed.polya.rds, results/cohort3a_subset-gene-expression-rsem-tpm.collapsed.stranded.rds" \
--outfile pnoc003-cohort3a-gene-expression-rsem-tpm.rds


# 02. Create Clinical for each study
# PNOC003 Cohort3a polyA
Rscript code/02-create-clin.R \
--mat results/cohort3a_subset-gene-expression-rsem-tpm.collapsed.polya.rds \
--clin data/hgat_all_primary.rds \
--id_col 'Kids_First_Biospecimen_ID' \
--lib_col 'library' \
--study_col 'cohort' \
--outfile pnoc003-cohort3a-polya-batch-metadata.rds

# PNOC003 Cohort3a stranded
Rscript code/02-create-clin.R \
--mat results/cohort3a_subset-gene-expression-rsem-tpm.collapsed.stranded.rds \
--clin data/hgat_all_primary.rds \
--id_col 'Kids_First_Biospecimen_ID' \
--lib_col 'library' \
--study_col 'cohort' \
--outfile pnoc003-cohort3a-stranded-batch-metadata.rds

# 03. Combine Clinical (Cohort 3a + GTEx + TGEN)
Rscript code/03-combine-clin.R \
--clin 'data/pnoc003-cohort3a-polya-batch-metadata.rds, data/pnoc003-cohort3a-stranded-batch-metadata.rds, data/gtex-batch-metadata.rds, data/tgen-batch-metadata.rds' \
--outfile pnoc003-cohort3a-gtex-tgen-metadata.rds

# 04. Batch Correction (Cohort 3a + GTEx + TGEN)
Rscript code/04-batch-correct.R \
--combined_mat results/pnoc003-cohort3a-gtex-tgen-gene-expression-rsem-tpm.rds \
--combined_clin results/pnoc003-cohort3a-gtex-tgen-metadata.rds \
--outfile pnoc003-cohort3a-gtex-tgen-gene-expression-rsem-tpm-corrected.rds

# 05. QC Plots (Cohort 3a + GTEx + TGEN)
Rscript code/05-qc-plots.R \
--uncorrected_mat results/pnoc003-cohort3a-gtex-tgen-gene-expression-rsem-tpm.rds \
--corrected_mat results/pnoc003-cohort3a-gtex-tgen-gene-expression-rsem-tpm-corrected.rds \
--combined_clin results/pnoc003-cohort3a-gtex-tgen-metadata.rds \
--tsne_plots pnoc003-cohort3a-gtex-tgen-tsne.pdf \
--hist_plots pnoc003-cohort3a-gtex-tgen-hist.pdf
