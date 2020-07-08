# Author: Komal S. Rathi
# Function: Create clinical file (batch information)

# load libraries
suppressPackageStartupMessages(library(optparse))
suppressPackageStartupMessages(library(tidyverse))

# root directory
root_dir <- rprojroot::find_root(rprojroot::has_dir(".git"))
outdir <- file.path(root_dir, "data/")

# parameters
option_list <- list(
  make_option(c("--mat"), type = "character",
              help = "Expression Matrix (RSEM TPM) (.RDS)"),
  make_option(c("--library"), type = "character",
              help = "Library Preparation Method"),
  make_option(c("--study"), type = "character",
              help = "Study identifier"),
  make_option(c("--outfile"), type = "character",
              help = "Output filename (.RDS)"))

# parse parameters
opt <- parse_args(OptionParser(option_list = option_list))
mat <- opt$mat
library <- opt$library
study <- opt$study
outfile <- opt$outfile
outfile <- file.path(outdir, outfile)

# read data
mat <- readRDS(mat)

# create clinical file with input
clin <- data.frame(sample_id = colnames(mat), study_id = study, library = library)
clin <- clin %>%
  mutate(tmp = sample_id,
         batch = paste0(study, '_', library)) %>%
  column_to_rownames('tmp')

# save output
saveRDS(clin, file = outfile)
