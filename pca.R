

######### 
######### PCA pour voir si les pays forment des groupes similaires entre eux...
######### 

library("FactoMineR")
library("factoextra")
library(corrplot)
library(psy)


############### ACP
###############

# Data mining... = analyse multidimensionnelle de données...

# On part de l'idée d'une matrice de corrélation dans laquelle on a toutes les combinaisons possibles entre les variables quantitatives (binaires, continues, etc.).
# La question est la suivante : si l'on veut traiter les corrélations entre les variables d'une matrice, on ne peut pas inclure les données manquantes.
# Cependant, si l'on exclut tous les individus présentant une donnée manquante en utilisant use="complete.obs", on risque de vider notre base.
# Ainsi, on enlève les données manquantes pour chaque variable que l'on croise en utilisant use="pairwise.complete.obs".

# On va regarder le calcul d'une matrice de corrélation avec R.

# On travaille avec la base de données edv_sa
# On sélectionne d'abord les variables et on les stocke dans un vecteur.
# Ensuite, on crée la matrice pour examiner l'ensemble des corrélations.



### préparer les données 
pib_kmeans <- edv_sa_hlm %>% group_by(country) %>%
  #select(pib_pc, inf_deflacteur)%>% 
  summarise(mean_mort_inf = mean(mort_inf, na.rm = T),
    mean_urbain = mean(pop_urbaine, na.rm = T),
    mean_chomage = mean(chomage, na.rm = T),
    #mean_inactive = mean(pop_inactive, na.rm = T),
    mean_pib = mean(pib_pc, na.rm = T),
    mean_inf=mean(inf_deflacteur, na.rm = T),
    mean_s_alim=mean(s_alim, na.rm=T),
    #mean_edv=mean(edv, na.rm=T),
    #mean_co2=mean(co2, na.rm=T),
    #mean_pex=mean(p_extreme, na.rm=T),
    mean_rev_50=mean(rev_50_inf, na.rm=T),
    #mean_rev_50_s=mean(rev_50_inf_s, na.rm=T),
    #mean_rev_50_2=mean(rev_50_inf_2, na.rm=T),
    mean_rev_10=mean(rev_10_sup, na.rm=T),
    #mean_rev_10_s=mean(rev_10_sup_s, na.rm=T),
    #mean_rev_10_2=mean(rev_10_sup_2, na.rm=T),
    mean_gini=mean(mean_gini_s, na.rm=T),
    mean_heath_pib=mean(health_pib, na.rm=T),
    mean_dpt3=mean(dpt3, na.rm=T)
  )


var<- c("mean_mort_inf","mean_urbain", 'mean_chomage',"mean_pib","mean_inf","mean_s_alim",  'mean_rev_50', 'mean_rev_10', 'mean_gini', "mean_heath_pib", 'mean_dpt3')


# corrélation entre variables
cor(pib_kmeans[,var], use = "complete.obs")
round(cor(pib_kmeans[,var],use = "complete.obs"), digits = 3)
var

corrplot(cor(pib_kmeans[,var],use = "complete.obs"), method="circle")
corrplot(cor(pib_kmeans[,var], use= "pairwise.complete.obs"), method="circle")


### si jamais j'ai une vd et qq vi :
expliquer<- "mean_mort_inf"
explicatives <- c("mean_urbain", 'mean_chomage',"mean_pib","mean_inf","mean_s_alim",  'mean_rev_50', 'mean_rev_10', 'mean_gini', "mean_heath_pib", 'mean_dpt3')
fpca(data=pib_kmeans, y=expliquer, x=explicatives, partial="No")

### on lance : 
respca<-PCA(pib_kmeans[,var], quanti.sup = "mean_mort_inf")

# On observe les différents éléments du résultat :
respca$eig
respca$var$contrib
respca$var$coord
respca$var$cos2

respca$ind$contrib
respca$ind$coord


### TABLEAU CONTRIB VARIABLES 

as.data.frame(respca$var$contrib[,1:2]) 


###C TABLEAU IND QUI CONTRIBUENT FORTEMENT AUX AXES
dfcontribution.individus <-as.data.frame(respca$ind$contrib[1:10,1:2])
dfcontribution.individus

dfcontribution.individus[dfcontribution.individus$Dim.1, ]

sort(dfcontribution.individus$Dim.1, decreasing = TRUE)
order(dfcontribution.individus$Dim.1, decreasing = TRUE)

order(dfcontribution.individus[dfcontribution.individus$Dim.1 >3, 1], decreasing = TRUE)



### Description des dimensions
dimdesc(respca)
dimdesc(respca, proba=0.2)


### Coloriage des individus en fonction de leur modalite
plot(respca, cex=0.8, habillage = "mean_mort_inf",  title="Graphe des individus")

### Graphes sur les dimensions 1 et 2

plot(respca, choix="ind", cex=0.8, title="Graphe des individus", axes=1:2)
plot(respca, choix="var", title="Graphe des variables", axes=1:2)


## contribution des dimensions
fviz_eig(respca, addlabels = TRUE, ylim = c(0, 80), main = "Explained variance by dimension")

# Contributions des variables à PC1
fviz_contrib(respca, choice = "var", axes = 1, top = 10)
# Contributions des variables à PC2
fviz_contrib(respca, choice = "var", axes = 2, top = 10)


### contribution des individus
fviz_contrib(respca, choice = "ind", axes = 1:2)


