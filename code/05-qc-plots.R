# Author: Komal S. Rathi
# Function: QC plots for batch correction

suppressPackageStartupMessages(library(optparse))
suppressPackageStartupMessages(library(Rtsne))
suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(ggpubr))

# root directory
root_dir <- rprojroot::find_root(rprojroot::has_dir(".git"))
plotdir <- file.path(root_dir, "plots/")

# parameters
option_list <- list(
  make_option(c("--uncorrected_mat"), type = "character",
              help = "Combined expression matrix with multiple batches (RSEM TPM) (.rds)"),
  make_option(c("--corrected_mat"), type = "character",
              help = "Corrected expression matrix with multiple batches (RSEM TPM) (.rds)"),
  make_option(c("--combined_clin"), type = "character",
              help = "Combined clinical file with multiple batches (.rds)"),
  make_option(c("--tsne_plots"), type = "character",
              help = "Summary clustering plots (.pdf)"),
  make_option(c("--hist_plots"), type = "character",
              help = "Histogram of housekeeping genes (.pdf)"))

# parse parameters
opt <- parse_args(OptionParser(option_list = option_list))
uncorrected_mat <- opt$uncorrected_mat
corrected_mat <- opt$corrected_mat
combined_clin <- opt$combined_clin
tsne_plots <- opt$tsne_plots
tsne_plots <- file.path(plotdir, tsne_plots)
hist_plots <- opt$hist_plots
hist_plots <- file.path(plotdir, hist_plots)

# read input data
uncorrected_mat <- readRDS(uncorrected_mat)
corrected_mat <- readRDS(corrected_mat)
combined_clin <- readRDS(combined_clin)

# arrange with clinical file
uncorrected_mat <- uncorrected_mat[,rownames(combined_clin)]
corrected_mat <- corrected_mat[,rownames(combined_clin)]

# house keeping genes
hkgenes <- c("ACTB", "TUBA1A", "TUBB", "GAPDH", "LDHA", "RPL19")

# t-SNE (uncorrected matrix)
set.seed(100) # set seed for reproducibility
tsneOut <- Rtsne(t(log2(uncorrected_mat + 1)), check_duplicates = FALSE, theta = 0)
tsneData <- data.frame(tsneOut$Y, combined_clin)

p <- ggplot(tsneData, aes(X1, X2,
                          color = batch,
                          shape = batch)) +
  geom_jitter(size = 4, width = 0.5, height = 0.5, alpha = 0.5) +
  theme_bw() + ggtitle('t-SNE before batch correction') +
  theme(plot.title = element_text(size = 12, face = "bold", hjust = 0.5),
        legend.title=element_text(size=10),
        legend.text=element_text(size=8)) + guides(size = F)

# house keeping genes only
set.seed(100) # set seed for reproducibility
uncorrected_mat.hk <- uncorrected_mat[rownames(uncorrected_mat) %in% hkgenes,]
tsneOut <- Rtsne(t(log2(uncorrected_mat.hk + 1)), check_duplicates = FALSE, theta = 0)
tsneData <- data.frame(tsneOut$Y, combined_clin)

r <- ggplot(tsneData, aes(X1, X2,
                          color = batch,
                          shape = batch)) +
  geom_jitter(size = 4, width = 0.5, height = 0.5, alpha = 0.5) +
  theme_bw() + ggtitle('t-SNE before batch correction\n(Housekeeping genes)') +
  theme(plot.title = element_text(size = 12, face = "bold", hjust = 0.5),
        legend.title=element_text(size=10),
        legend.text=element_text(size=8)) + guides(size = F)

# t-SNE (corrected matrix)
set.seed(100) # set seed for reproducibility
tsneOut <- Rtsne(t(log2(corrected_mat + 1)), check_duplicates = FALSE, theta = 0)
tsneData <- data.frame(tsneOut$Y, combined_clin)

q <- ggplot(tsneData, aes(X1, X2,
                          color = batch,
                          shape = batch)) +
  geom_jitter(size = 4, width = 0.5, height = 0.5, alpha = 0.5) +
  theme_bw() + ggtitle('t-SNE after batch correction') +
  theme(plot.title = element_text(size = 12, face = "bold", hjust = 0.5),
        legend.title=element_text(size=10),
        legend.text=element_text(size=8)) + guides(size = F)

# house keeping genes only
set.seed(100) # set seed for reproducibility
corrected_mat.hk <- corrected_mat[rownames(corrected_mat) %in% hkgenes,]
tsneOut <- Rtsne(t(log2(corrected_mat.hk + 1)), check_duplicates = FALSE, theta = 0)
tsneData <- data.frame(tsneOut$Y, combined_clin)

s <- ggplot(tsneData, aes(X1, X2,
                          color = batch,
                          shape = batch)) +
  geom_jitter(size = 4, width = 0.5, height = 0.5, alpha = 0.5) +
  theme_bw() + ggtitle('t-SNE after batch correction\n(Housekeeping genes)') +
  theme(plot.title = element_text(size = 12, face = "bold", hjust = 0.5),
        legend.title=element_text(size=10),
        legend.text=element_text(size=8)) + guides(size = F)

# save t-SNE plots
ggarrange(p, q, r, s, common.legend = T) %>%
  ggexport(filename = tsne_plots, width = 12, height = 10)

# distribution of housekeeping genes
# uncorrected  mat
uncorrected_mat.hk <- uncorrected_mat.hk %>% 
  rownames_to_column('gene') %>% 
  gather(-gene, key ="sample_id", value = 'value') %>%
  inner_join(combined_clin, by = "sample_id")
p <- ggplot(uncorrected_mat.hk, aes(x = log2(value + 1), fill =  batch)) + 
  geom_density(alpha = .3) +
  theme_bw() +
  ggtitle('House Keeping Genes (Before ComBat correction)') +
  xlab("log2(TPM + 1)")

# corrected mat
corrected_mat.hk <- corrected_mat.hk %>% 
  as.data.frame() %>%
  rownames_to_column('gene') %>% 
  gather(-gene, key ="sample_id", value = 'value') %>%
  inner_join(combined_clin, by = "sample_id")
q <- ggplot(corrected_mat.hk, aes(x = log2(value + 1), fill =  batch)) + 
  geom_density(alpha = .3) +
  theme_bw() +
  ggtitle('House Keeping Genes (After ComBat correction)') +
  xlab("log2(ComBat corrected value + 1)")

# save plots
ggarrange(p, q, ncol = 2, common.legend = T) %>%
  ggexport(filename = hist_plots, width = 12, height = 6)