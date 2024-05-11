# Data citation doi: 10.1038/ncomms5344

## Load Libraries
library(microbiome)
library(knitr)

## Load data
data(atlas1006) 
print(atlas1006)

# Rename the data
pseq <- atlas1006

# Alpha diversity
# 
alpha <- microbiome::alpha
tab <- alpha(pseq, index = "all")
kable(head(tab))

# Assign the estimated diversity to sample metadata
sample_data(pseq)$diversity <- tab$diversity_shannon

# Visualize the data
p <- plot_regression(diversity ~ age, meta(pseq)) +
  labs(x = "Age", y = "Alpha diversity")
p

# Technical biases
# Explore potential technical biases in the data. DNA extraction method has a remarkable effect on sample grouping.

# Use relative abundance data
ps <- microbiome::transform(pseq, "compositional")
# Pick core taxa
ps <- core(ps, detection = 0, prevalence = 80/100)
# For this example, choose samples with DNA extraction information available
ps <- subset_samples(ps, !is.na(DNA_extraction_method))
# Illustrate sample similarities with PCA (NMDS)
plot_landscape(ps, "NMDS", "bray", col = "DNA_extraction_method")
