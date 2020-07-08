# 00. Data prep
Rscript code/00-data-prep.R \
--rsem_path data/TGEN_normals \
--outfile tgen-normals-gene-expression-rsem-tpm.polya.rds

# 01. Collapse RNA-seq
# GTEx Brain
Rscript code/01-collapse-matrices.R \
--mat data/gtex-brain-normals-gene-expression-rsem-tpm.polya.rds  \
--gene_sym TRUE \
--outfile gtex-brain-normals-gene-expression-rsem-tpm.collapsed.polya.rds

# TGEN Brain
Rscript code/01-collapse-matrices.R \
--mat data/tgen-normals-gene-expression-rsem-tpm.polya.rds \
--gene_sym FALSE \
--outfile tgen-brain-normals-gene-expression-rsem-tpm.collapsed.polya.rds

# PNOC003 Cohort3
Rscript code/01-collapse-matrices.R \
--mat data/pnoc003_subset_Diagnosis-gene-expression-rsem-tpm.polya.rds \
--gene_sym FALSE \
--outfile pnoc003_subset_Diagnosis-gene-expression-rsem-tpm.collapsed.polya.rds

# 02. Combine collapsed matrices
Rscript code/02-combine-matrices.R \
--matrices "results/pnoc003_subset_Diagnosis-gene-expression-rsem-tpm.collapsed.polya.rds, results/gtex-brain-normals-gene-expression-rsem-tpm.collapsed.polya.rds, results/tgen-brain-normals-gene-expression-rsem-tpm.collapsed.polya.rds" \
--outfile pnoc003-cohort1-gtex-tgen-gene-expression-rsem-tpm.rds

# 02. Create Clinical for each study
# GTEx Brain
Rscript code/02-create-clin.R \
--mat results/gtex-brain-normals-gene-expression-rsem-tpm.collapsed.polya.rds \
--library polyA \
--study GTEx \
--outfile gtex-batch-metadata.rds

# TGEN Brain
Rscript code/02-create-clin.R \
--mat results/tgen-brain-normals-gene-expression-rsem-tpm.collapsed.polya.rds \
--library polyA \
--study TGEN \
--outfile tgen-batch-metadata.rds

# PNOC003 Cohort3
Rscript code/02-create-clin.R \
--mat results/pnoc003_subset_Diagnosis-gene-expression-rsem-tpm.collapsed.polya.rds \
--library polyA \
--study PNOC003_cohort1 \
--outfile pnoc003-cohort1-batch-metadata.rds

# 03. Combine Clinical
Rscript code/03-combine-clin.R \
--clin 'data/pnoc003-cohort1-batch-metadata.rds, data/gtex-batch-metadata.rds, data/tgen-batch-metadata.rds' \
--outfile pnoc003-cohort1-gtex-tgen-metadata.rds

# 04. Batch Correction
Rscript code/04-batch-correct.R \
--combined_mat results/pnoc003-cohort1-gtex-tgen-gene-expression-rsem-tpm.rds \
--combined_clin results/pnoc003-cohort1-gtex-tgen-metadata.rds \
--outfile pnoc003-cohort1-gtex-tgen-gene-expression-rsem-tpm-corrected.rds

# 05. QC Plots
Rscript code/05-qc-plots.R \
--uncorrected_mat results/pnoc003-cohort1-gtex-tgen-gene-expression-rsem-tpm.rds \
--corrected_mat results/pnoc003-cohort1-gtex-tgen-gene-expression-rsem-tpm-corrected.rds \
--combined_clin results/pnoc003-cohort1-gtex-tgen-metadata.rds \
--tsne_plots pnoc003-cohort1-gtex-tgen-tsne.pdf \
--hist_plots pnoc003-cohort1-gtex-tgen-hist.pdf