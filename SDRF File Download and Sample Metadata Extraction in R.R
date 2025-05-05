
# Description 
# This R script automates the download of an SDRF file from ArrayExpress, 
# extracts relevant metadata (e.g., cell line, stimulus, and time), 
# cleans the data by removing duplicates, and presents it in a formatted table.
# It utilizes packages like httr, knitr, and miodin for bioinformatics data processing and visualization.



# ─────────────────────────────────────────────────────────────────────────────
# Required packages
# ─────────────────────────────────────────────────────────────────────────────
if (!require("httr")) install.packages("httr")
if (!require("knitr")) install.packages("knitr")
if (!requireNamespace("BiocManager", quietly = TRUE)) install.packages("BiocManager")
if (!require("miodin")) BiocManager::install("miodin")
if (!require("magrittr")) install.packages("magrittr")  # for %>% pipe

library(httr)
library(knitr)
library(miodin)
library(magrittr)

#---------------------------------------------------------------------
# Define URLs and file paths
#---------------------------------------------------------------------
sdrf_url <- "https://www.ebi.ac.uk/arrayexpress/files/E-MTAB-8548/E-MTAB-8548.sdrf.txt"

#---------------------------------------------------------------------
# Set local destination path
#---------------------------------------------------------------------
destination_path <- "C:/Users/Dell/Documents/Assignment_1_a24ahmou/E-MTAB-8548.sdrf.txt"

#---------------------------------------------------------------------
# Download the SDRF file
#---------------------------------------------------------------------
GET(sdrf_url, write_disk(destination_path, overwrite = TRUE))
cat("✔️ File downloaded successfully to:", destination_path, "\n")

#---------------------------------------------------------------------
# Read the SDRF file
#---------------------------------------------------------------------
sdrf <- read.delim(destination_path, check.names = FALSE)

#---------------------------------------------------------------------
# Display available columns
#---------------------------------------------------------------------
print("Available columns:")
print(colnames(sdrf))

#---------------------------------------------------------------------
# Extract relevant columns with corrected names
#---------------------------------------------------------------------
samples <- sdrf[, c("Source Name", 
                    "Characteristics[cell line]", 
                    "Factor Value[stimulus]", 
                    "Factor Value[time]")]

#---------------------------------------------------------------------
# Rename for clarity
#---------------------------------------------------------------------
colnames(samples) <- c("SampleName", "CellLine", "Stimulus", "Time")

#---------------------------------------------------------------------
# Remove duplicates and clean
#---------------------------------------------------------------------
samples <- unique(samples)
rownames(samples) <- samples$SampleName
samples$SampleName <- NULL

#---------------------------------------------------------------------
# Display the cleaned samples table nicely
#---------------------------------------------------------------------
print("Cleaned sample metadata:")
knitr::kable(samples, caption = "Sample Metadata Extracted from E-MTAB-8548 SDRF File")
