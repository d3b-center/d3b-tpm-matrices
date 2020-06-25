# Author: Komal S. Rathi
# Function: Combine TPM matrices from various RNAseq datasets

# load libraries
library(dplyr)
library(stringr)
library(tidyverse)

# function to merge rsem files
merge.res <- function(nm){
  sample_name <- gsub(".*/","",nm)
  sample_name <- gsub('[.].*','',sample_name)
  x <- data.table::fread(nm)
  if(nrow(x) > 1){
    x <- as.data.frame(x)
    x$sample_name <- sample_name
    return(x)
  } 
}

#### TGEN Brain normals
# combine all rsem files
tgen.expDat <- list.files(path = 'data/TGEN_normals/', pattern = "*.genes.results*", recursive = TRUE, full.names = T)
tgen.mat <- lapply(tgen.expDat, FUN = function(x) merge.res(x))
tgen.mat <- data.table::rbindlist(tgen.mat)

# separate gene_id and gene_symbol
tgen.mat <- tgen.mat %>% 
  mutate(gene_id = str_replace(gene_id, "_PAR_Y_", "_"))  %>%
  separate(gene_id, c("gene_id", "gene_symbol"), sep = "\\_", extra = "merge") %>%
  unique()

# uniquify gene_symbol
tgen.mat <- tgen.mat %>% 
  group_by(sample_name) %>%
  arrange(desc(TPM)) %>% 
  distinct(gene_symbol, .keep_all = TRUE) %>%
  dplyr::select(gene_symbol, sample_name, TPM) %>%
  spread(sample_name, TPM) %>%
  column_to_rownames('gene_symbol')

#### GTEx Brain normals
gtex.brain <- data.table::fread('data/Brain_TPM_matrix.txt')
gtex.brain <- gtex.brain %>%
  column_to_rownames('gene_symbol')

# Combine TGEN + GTEx
gtex.tgen.combined <- tgen.mat %>%
  rownames_to_column('gene') %>%
  inner_join(gtex.brain %>% rownames_to_column('gene'), by = 'gene') %>%
  column_to_rownames('gene')
saveRDS(gtex.tgen.combined, file = 'results/gtexbrain-tgen-combined-gene-expression-rsem-tpm-collapsed.polya.rds')

#### PBTA (polyA + rRNA corrected)
poly.str.corrected <- readRDS('data/pbta-gene-expression-rsem-tpm-collapsed.polya.stranded.corrected.rds')
saveRDS(poly.str.corrected, file = 'results/all-pbta-gene-expression-rsem-tpm.polya.stranded.combined.rds')

#### PNOC003 data
pnoc003.clin <- read.delim('data/pnoc003_clinical.tsv')
pnoc003.tpm <- poly.str.corrected[,colnames(poly.str.corrected) %in% pnoc003.clin$Kids_First_Biospecimen_ID]
saveRDS(pnoc003.tpm, file = 'results/pnoc003-pbta-gene-expression-rsem-tpm-collapsed.polya.rds')

# PNOC008 (??)
