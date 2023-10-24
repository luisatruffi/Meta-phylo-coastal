---
output: html_document
---


# Does the phylogenetic distance determine the outcome of plant interactions in coastal dunes?

This repository contains the scripts and data used in a meta-analysis about the effect of the phylogenetic distance on the outcome of plant-plant interactions in coastal dunes.

<br>
Data was extracted from the articles selected through our inclusion criteria and each outcome was registred in M.Luisa_07.08.2023.csv (file: R/data/raw).
<br>
The analysis are in the R/data/processed file. We standardized species names and generated the phylogenetic tree in extraindolistasp.R. We ploted the phylogenetic tree in plot.arvore.R. We calculated the phylogenetic distance between interacting plants and added this distance to a column in the M.Luisa_07.08.2023.csv and saved this as tab.dist.filo.07.08.2023.csv which is used in the next script in inserindo_distancias_filo.R. We calculated the effect size for each outcome, ran ours hierarchical mixed effect meta-analysis, calculated the heterogeneity, publication bias, did the graphs for each model in Analise_sem_gimnos_08.08.2023.R.

All output figures and phylogenetic tree are stored in the R/output.

<br>
This a work in progress


Authors: Luisa Truffi de Oliveira Costa and Camila de Toledo Castanho
