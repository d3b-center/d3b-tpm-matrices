library(tidyverse)
library(Rtsne)
library(sva)
library(ggpubr)

# pbta polya + stranded corrected TPM data
# collapsed gene symbols
pbta <- readRDS('~/Projects/OMPARE/data/Reference/PBTA/pbta-gene-expression-rsem-tpm-collapsed.polya.stranded.corrected.rds')

# subset to HGAT only (n = 186)
pbta.clin <- read.delim('~/Projects/OMPARE/data/Reference/PBTA/pbta-histologies.tsv')
pbta.clin <- pbta.clin %>%
  filter(experimental_strategy == "RNA-Seq",
         short_histology == "HGAT") %>%
  mutate(study_id = "OpenPBTA_Corrected_HGAT", subjectID = Kids_First_Biospecimen_ID) %>%
  dplyr::select(subjectID, study_id)
pbta <- pbta[,colnames(pbta) %in% pbta.clin$subjectID]

# PNOC008 TPM
# collapsed gene symbols
pnoc008 <- readRDS('~/Projects/OMPARE/data/Reference/PNOC008/PNOC008_TPM_matrix.RDS')
pnoc008.clin <- readRDS('~/Projects/OMPARE/data/Reference/PNOC008/PNOC008_clinData.RDS')
pnoc008.clin <- pnoc008.clin %>%
  dplyr::select(subjectID, study_id)

# combine clinical files
clin <- rbind(pnoc008.clin, pbta.clin)
clin <- clin %>%
  mutate(tmp = subjectID) %>%
  column_to_rownames('tmp')

# combine matrix
mat <- pnoc008 %>%
  rownames_to_column("gene") %>%
  inner_join(pbta %>% rownames_to_column("gene"),
             by = "gene") %>%
  column_to_rownames("gene")
mat <- mat[,rownames(clin)]

# t-SNE by combining both
set.seed(100) # set seed for reproducibility
tsneOut <- Rtsne(t(log2(mat+1)), check_duplicates = FALSE, theta = 0)
tsneData <- data.frame(tsneOut$Y, clin)

p <- ggplot(tsneData, aes(X1, X2,
                     color = study_id,
                     shape = study_id)) +
  geom_jitter(size = 4, width = 0.5, height = 0.5, alpha = 0.5) +
  theme_bw() + ggtitle('t-SNE before batch correction') +
  theme(plot.title = element_text(size = 12, face = "bold", hjust = 0.5),
        legend.title=element_text(size=10),
        legend.text=element_text(size=8)) + guides(size = F)
p

# batch correction
# logmat <- log2(mat + 1)
# corrected.mat <- rescaleBatches(as.matrix(logmat), batch = clin$study_id)
# combined <- runTSNE(corrected.mat, exprs_values="corrected")
# plotTSNE(combined, colour_by = "batch")

# batch correct using ComBat
corrected.mat <- ComBat(dat = log2(mat + 1), batch = clin$study_id)
set.seed(100) # set seed for reproducibility
tsneOut <- Rtsne(t(corrected.mat), check_duplicates = FALSE, theta = 0)
tsneData <- data.frame(tsneOut$Y, clin)

q <- ggplot(tsneData, aes(X1, X2,
                          color = study_id,
                          shape = study_id)) +
  geom_jitter(size = 4, width = 0.5, height = 0.5, alpha = 0.5) +
  theme_bw() + ggtitle('t-SNE after batch correction') +
  theme(plot.title = element_text(size = 12, face = "bold", hjust = 0.5),
        legend.title=element_text(size=10),
        legend.text=element_text(size=8)) + guides(size = F)
q

ggarrange(p, q, ncol = 2, common.legend = T)
