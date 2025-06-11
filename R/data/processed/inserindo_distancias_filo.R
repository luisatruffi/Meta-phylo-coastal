##Inserindo as distancias na tabela

tab <- read.csv("R/data/raw/MLuisaSuitable_20.08.2023.csv")
str(tab)
table(tab$suitable_for_master_project)


##corrigir erros de digitacao, ou entradas que vao dar erro no pacote

tab[tab$n_sp_paper   ==  "Elymus farctus (dominant in the patch)", "n_sp_paper" ]<- "Elymus farctus"
tab[tab$t_sp_paper   ==  "Haplopappus ericoides (sinonimo de Ericameria ericoides)", "t_sp_paper" ] <-"Haplopappus ericoides"


sp <- c(tab$t_sp_paper, tab$n_sp_paper)
sp <- unique(sp)
sp<- sp[order(sp)]


sp
sp <- unique(sp)

library(lcvplants)

# padronizando os nomes
tabsp <- lcvp_search(sp)
str(tabsp)


for(i in 1:nrow(tabsp)){
  for(x in 1:nrow(tab))
{
  if (tabsp[ i, "Search"] == tab[ x ,"n_sp_paper"] ) 
  tab[x, "n_sp_LCVP"] <- tabsp[i, "Output.Taxon"]
    if ( tabsp[ i, "Search"] == tab[ x ,"t_sp_paper"] )
      tab[x, "t_sp_LCVP"] <- tabsp[i, "Output.Taxon"]
}}

for(i in 1:nrow(tabsp)){
  for(x in 1:nrow(tab))
  {
    if (tabsp[ i, "Search"] == tab[ x ,"n_sp_paper"] ) 
      tab[x, "n_family_LCVP"] <- tabsp[i, "Family"]
    if ( tabsp[ i, "Search"] == tab[ x ,"t_sp_paper"] )
      tab[x, "t_family_LCVP"] <- tabsp[i, "Family"]
  }}

##inserindo a distancia filogenetica
tab$phylo_dist <- rep(NA, nrow(tab))

filogenia <- read.tree("R/output/arvores/arvore.07.08.2023")
dist <- cophenetic(filogenia)
class(dist)
colnames(dist)
table(dist)
row.names(dist)
tab[ , "t_sp_LCVP"]
##os nomes na coluna t_sp_LCVP e n_sp_LCVP nao batem com os row.names e colnames de dist
##padronizar os nomes de colnames e row.names de dist

#row.names(dist) <- gsub("[[:punct:]]", " ", row.names(dist))
#nao da certo porque tira tambem os espacos

row.names(dist) <- gsub("_", " ", row.names(dist))
row.names(dist) <- sub("-", "(", row.names(dist))
row.names(dist) <- sub("-", ")", row.names(dist))
#row.names(dist)<- gsub("\\.", "", row.names(dist))

colnames(dist) <- gsub("_", " ", colnames(dist))
colnames(dist) <- sub("-", "(", colnames(dist))
colnames(dist) <- sub("-", ")", colnames(dist))
#colnames(dist) <- gsub("\\.", "", colnames(dist))

colnames(dist)[which(colnames(dist) == "Stauracanthus spectabilis ()Daveau ex Cout.- Castro - T.E.Díaz & al. ")] <- "Stauracanthus spectabilis ((Daveau ex Cout.) Castro ) T.E.Díaz & al. [1990]"
row.names(dist)[which(row.names(dist) == "Stauracanthus spectabilis ()Daveau ex Cout.- Castro - T.E.Díaz & al. ")] <- "Stauracanthus spectabilis ((Daveau ex Cout.) Castro ) T.E.Díaz & al. [1990]"

##agora os nomes estao padronizados
##mas o for nao funciona
posicaoT <-rep(NA, nrow(tab))

for(i in 1:nrow(tab))
{
posicaoT[i] <- agrep(tab[i , "t_sp_LCVP"], row.names(dist))
}

posicaoN <-rep(NA, nrow(tab))

for(i in 1:nrow(tab))
{
  posicaoN[i] <- agrep(tab[i , "n_sp_LCVP"], row.names(dist))
}

for(i in 1:nrow(tab))
{
  tab[i , "phylo_dist"] <- dist[posicaoN[i], posicaoT[i]]
}
hist(tab$phylo_dist, breaks = 40)
summary(tab$phylo_dist)
plot(tab$phylo_dist)
hist((tab$phylo_dist), breaks = 50, xlab = "Phylogenetic distance", main ="")
max(tab$phylo_dist)
table(tab$phylo_dist)

write.csv( tab,file = "R/data/processed/tab.dist.filo.22.08.2023.csv")

