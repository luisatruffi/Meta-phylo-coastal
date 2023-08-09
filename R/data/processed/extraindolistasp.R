##Criando arvore filogenetica

library(here)

tab <- read.csv("R/data/raw/M.Luisa_07.08.2023.csv")
str(tab)
table(tab$suitable_for_master_project)

##sobrescrevendo a tabela para trabalhar somente com os artigos que passaram na triagem

tab <- tab[tab$suitable_for_master_project == "yes" , ]

##corrigir erros de digitacao, ou entradas que vao dar erro no pacote
tab[tab$n_sp_paper   ==  "Elymus farctus (dominant in the patch)", "n_sp_paper" ]<- "Elymus farctus"
tab[tab$t_sp_paper   ==  "Haplopappus ericoides (sinonimo de Ericameria ericoides)", "t_sp_paper" ] <-"Haplopappus ericoides"

sp <- c(tab$t_sp_paper, tab$n_sp_paper)
sp<- unique(sp)
sp<- sp[order(sp)]


sp
sp <- unique(sp)
##exploracao dos dados
length(sp)
length(unique(tab$doi))
length(unique(tab$outcome))

##padronizacao da nomenclatura das sps
library(devtools)
#devtools::install_github("idiv-biodiversity/LCVP")

#devtools::install_github("idiv-biodiversity/lcvplants")

# load the package

library(lcvplants)

# padronizando os nomes
tabsp <- lcvp_search(sp)
str(tabsp)


##> tabsp <- lcvp_search(sp)
##Warning message:
##  More than one name was matched for some species. Only the first 'accepted' (if present)
##name was returned. Consider using the function lcvp_fuzzy_search to return all names for 
##these species:
##  Arenaria leptocladus, Bromus diandrus, Chamaecrista chamaecristoides var. chamaecristoides,
##Cistus salviifolius, Cutandia philistaea, Ehrharta calycina, Elymus mollis, 
##Erica multiflora, Haplopappus ericoides, Helichrysum stoechas, Myrica pensylvanica, 
##Oenothera biennis, Plantago psyllium, Polycarpon succulentum, Prunus serotina,
##Retama raetam, Schizachyrium scoparium var. littoralis, Solidago sempervirens,
##Uniola paniculata, Valantia hispida 

##refazer a lista usando o lcvp_fuzzy_search

#fuzzy <- lcvp_fuzzy_search(sp)


#tabela para criacao da arvore atraves da funcao VPhylomaker2
library(stringr)
inputvphylo <- data.frame( species = tabsp$Output.Taxon, genus = 
                             word(tabsp$Output.Taxon,1), family =
                             tabsp$Family, species.relative = NA,genus.relative = NA)
str(inputvphylo)
unique(inputvphylo$species)
unique(inputvphylo$family)

##assim eu consigo pegar so os 2 primeiros nomes, é melhor pra plotar, mas nao esta funcionando com o outro script pra o calculo das distancias
#talvez so usar na hora de plotar, mas deixar no arquivo do jeito que esta
inputvphylo2 <- inputvphylo
inputvphylo2$species <- word(inputvphylo2$species, 1,2)

library(V.PhyloMaker2)
treecompleta <- phylo.maker(inputvphylo, tree = GBOTB.extended.LCVP, 
                            nodes = nodes.info.1.LCVP,  scenarios = "S3")
tree2nomes <- phylo.maker(inputvphylo2, tree = GBOTB.extended.LCVP, 
                          nodes = nodes.info.1.LCVP,  scenarios = "S3")

##salvando as arvores
#write.tree(treecompleta$scenario.3, "R/output/arvore.07.08.2023")
#write.tree(tree2nomes$scenario.3, "R/output/arvore.2nomes.07.08.2023")

##check tree
library(ape)

filogenia <- read.tree("R/data/processed/arvore.2nomes.07.08.2023")
plot(filogenia, cex = 0.5, show.tip.label = T)
plot.phylo(filogenia, show.tip.label = T, show.node.label = F, cex = 0.7)

