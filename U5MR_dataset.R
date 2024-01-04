#on installe le package WDI
# install.packages('WDI')
# install.packages('plm')
# install.packages('questionr')
# install.packages('wooldidge')
# 

#On active le package
library(WDI)
library(questionr)
library(ggplot2)
library(tidyverse)
library(plm)
library(knitr)
library(broom)
library(lmtest)
library(wooldidge)

# le package R pour obtenir des données de la banque mondiale contient une fonction research:
WDIsearch("poverty")

# la fonction WDI nous permet d'accéder aux datasets à travers leur code. Il faut simplement connaître l'ID du dataset
# pour ces analyses j'ai téléchargé les datasats suivants: 
# edv c'est pour Espérance De Vie... car à l'origine c'était le thème qui l'intéressait avant de changer vers la mortalité infantile (U5)
# sa c'est pour South America... pour l'ensemble de pays chosis pour l'étude

edv_sa <- WDI(indicator=c('SP.DYN.LE00.IN', 'EN.ATM.CO2E.PC', 'SE.XPD.TOTL.GD.ZS', 'EN.ATM.GHGT.KT.CE', 'SH.DYN.MORT', 'SP.URB.TOTL.IN.ZS', 'NY.GDP.MKTP.CD', 'SL.UEM.TOTL.ZS', 'FP.CPI.TOTL.ZG', 'SI.POV.GINI', 'SI.POV.DDAY', 'SN.ITK.DEFC.ZS', 'EN.ATM.GHGT.KT.CE', 'SP.POP.DPND', 'SE.ADT.1524.LT.FE.ZS', 'EG.FEC.RNEW.ZS', 'SL.UEM.1524.FE.ZS', 'SL.TLF.CACT.FE.ZS','SP.RUR.TOTL.ZS','NY.GDP.PCAP.CD','NY.GDP.DEFL.KD.ZG','SP.DYN.IMRT.IN', 'SI.DST.FRST.20', 'SI.DST.10TH.10' ), country=c('AR','BO','BR', 'CL', 'CO', 'EC', 'PY', 'PE', 'UY', 'VE'), start=1989, end=2020)

#j'ai l'habitude de sauvegarder les données en local...
edv_sa1 <- read.csv2('./edv_sa.csv')

# le nom des colonnes c'est le nom de l'ID... je les ai modifiés pour les identifier plus facilement
colnames(edv_sa)[5:27] <- c("edv","co2", "educ", 'ges',"mort_inf", "pop_urbaine", "pib", "chomage", "inflation", "gini", "p_extreme", "s_alim", "pop_inactive", 'alpha_femmes_15_24', 'conso_e_renouv', 'chomage_j_femmes', 'part_pop_active_femmes','pop_rurale','pib_pc','inf_deflacteur','tmi_1an', 'rev_20_inf','rev_10_sup')

# l'échelle de la variable pib pouvait produire un pb à future pour les régressions... donc, je l'ai modfiée en anticipant ce problème
edv_sa$pib<-edv_sa$pib/1e6
summary(edv_sa$gini)


# A partir d'ici les manipulations deviennent un peu plus difficiles à comprendre
# mais en gros, j'ai téléchargé des données du site #cela sort de la base wdi https://wid.world/fr/donnees/
# d'abord j'ai ajouté à edv_sa les variables : health_pib, mean_palma, mean_gini et la part du revenu detenu par le 50% plus pauvre et par le 10% plus riche de chaque pays 

 inqal <- read.csv2('./ineqla.csv', sep = ';')


 edv_sa$health_pib <- inqal$health_pib
 edv_sa$palma <- inqal$mean_palma
 edv_sa$mean_gini <- inqal$mean_gini
 edv_sa$rev_10_sup <- inqal$mean_d10
 edv_sa$rev_50_inf <- inqal$d50inf
# 
# j'ai repeté l'opération pour d'autres variables obtenues du même site
#inequality_al <- read.csv2('./wid_data.csv', sep = ';')
#
edv_sa$rev_50_inf <- inequality_al$revenu_p0p50
edv_sa$rev_10_sup <- inequality_al$revenu_90p100

#quelques transformations nécessaires:
edv_sa$rev_50_inf <- as.numeric(edv_sa$rev_50_inf)
edv_sa$rev_10_sup <- as.numeric(edv_sa$rev_10_sup)
edv_sa$health_pib <- as.numeric(edv_sa$health_pib)
# 


# pour les données sur le niveau de couverture du vaccin DPT3 et j'ai modifié la variable health_pib
#ces nouvelles données viennent du WHO : https://www.who.int/data/gho/data/indicators

tmi_2 <- read.csv2('./tmi_2.csv', sep = ';', header = T)
edv_sa$health_pib <- tmi_2$health_pct_pib
edv_sa$dtp3 <- tmi_2$Vaccin_dtp3_WUENIC
#rm(tmi_2)

#write.csv2( edv_sa,'./edv_sa_8920.csv',row.names = F)


# comme je m'interessais seulement aux données 2000/2020... j'ai fait une petit selection:
edv_sa0020 <- edv_sa[edv_sa$year>=1999,]

#Avant de choisir une méthode HLM, j'ai tenté une analyse de panel, c'est pour quoi il fallait changer le type de df
#edv_sa0020 <- pdata.frame(edv_sa0020, index=c('country', 'year'))



# ensuite... 
#helth_gdp <- read.csv2("./health.csv", sep = ",", header = T)
#helth_gdp <- helth_gdp[, c(8,10,30)]
#helth_gdp <- helth_gdp %>%
#  arrange(Location)
#helth_gdp <- helth_gdp %>%
#  rename(health_gdp=Value)
#health_gdp <-helth_gdp$health_gdp

### je crée la variable t
### edv_sa0020$t <- as.numeric(edv_sa0020$year)-1

### je cree la colonne ID

edv_sa0020$ID <- as.numeric(as.factor(edv_sa0020$country))


##### Je crée le df edv_sa_hlm pour les analyses HLM
#edv_sa_hlm <-edv_sa0020[edv_sa0020$year!=1999,]
#edv_sa_hlm$t<- edv_sa_hlm$t-1



####changer l'ordre des colonnes, ID de la c40 a la c1
###edv_sa0020 <- edv_sa0020[, c(40, 1:39)]

####changer l'ordre des colonnes, t de la c40 à la c5
####df <- df[, c(1, 38, seq(2, 37), seq(39, ncol(df)))]
####edv_sa0020 <- edv_sa0020[, c(seq(1, 5), 40, seq(6, 39))]




### je cree la colonne health_gdp chez edv_sa_hlm
edv_sa_hlm$health_gdp<-as.numeric(health_gdp)

# J'ai téléchargé du site WHO les données sur la couberture pour le vaccin du sarampion (Dose 1).
mvc1 <-read.csv2('./mvc1.csv', sep=",")
mvc1 <- mvc1[, c(8,10,30)]
mvc1 <- mvc1 %>%
  arrange(Location)%>%
  rename(mvc1=Value)
mvc1 <-mvc1$mvc1
edv_sa_hlm$mvc1<-as.numeric(mvc1)


### anemia non p col
### 

#anemia_nonp <- read.csv2('./anemia_nonp.csv', sep=',')
#anemia_nonp <- anemia_nonp[, c(8,10,24)]
#anemia_nonp$FactValueNumeric<-as.numeric(as.character(anemia_nonp$FactValueNumeric))
#anemia_nonp <- anemia_nonp %>%
#  rename(Value=FactValueNumeric)
  
#df <- data.frame(Location=unique(anemia_nonp$Location), Period=rep(2020, 10), Value=rep(NA, 10))
#anemia_nonp<-rbind(anemia_nonp,df)

#anemia_nonp <- anemia_nonp %>%
#  arrange(Location, Period) %>%
#  rename(anemia_nonp=Value)

#anemia_nonp<- anemia_nonp$anemia_nonp
#edv_sa_hlm$anemia_nonp<-anemia_nonp


### anemia p

# anemia_p <- read.csv2('./anemia_p.csv', sep=',')
# anemia_p <- anemia_p[, c(8,10,24)]
# anemia_p$FactValueNumeric<-as.numeric(as.character(anemia_p$FactValueNumeric))
# anemia_p <- anemia_p %>%
#   rename(Value=FactValueNumeric)
# 
#df <- data.frame(Location=unique(anemia_nonp$Location), Period=rep(2020, 10), Value=rep(NA, 10))
# anemia_p<-rbind(anemia_p,df)
# 
# anemia_p <- anemia_p %>%
#   arrange(Location, Period) %>%
#   rename(anemia_p=Value)
# 
# anemia_p<- anemia_p$anemia_p
# edv_sa_hlm$anemia_p<-anemia_p



###### educ gdp
educ_gdp <- WDI(indicator=c('SE.XPD.TOTL.GB.ZS'), country=c('AR','BO','BR', 'CL', 'CO', 'EC', 'PY', 'PE', 'UY', 'VE'), start=2000, end=2020)

educ_gdp <- educ_gdp %>%
     arrange(country,year) %>%
     rename(educ_gdp='SE.XPD.TOTL.GB.ZS')


educ_gdp<- educ_gdp$educ_gdp
edv_sa_hlm$educ_gdp<-educ_gdp

###############################
###############################
###############################
############################### water


water <- read.csv2('./water.csv', sep=',')

# Charger le package tidyr
library(tidyr)

# Utiliser pivot_wider pour convertir en format "large"
water <- water %>%
  pivot_wider(names_from = Dim1, values_from = Value)

water<-water[,c(8,10,33:35)]

water <- water %>%
  arrange(Location) 

water$Total <- as.numeric(water$Total)
water$Rural <- as.numeric(water$Rural)
water$Urban <- as.numeric(water$Urban)


# Harmoniser les données
water <- water %>%
  group_by(Location,Period) %>%
  summarize(
    Total = ifelse(all(is.na(Total)), NA, sum(Total, na.rm = TRUE)),
    Rural = ifelse(all(is.na(Rural)), NA, sum(Rural, na.rm = TRUE)),
    Urban = ifelse(all(is.na(Urban)), NA, sum(Urban, na.rm = TRUE)),
  ) %>%
  ungroup()

water <- water %>%
  rename(WaterT = Total,
         WaterR = Rural,
         WaterU = Urban)

water$waterU_S<-ifelse(water$Location=="Venezuela (Bolivarian Republic of)", water$WaterT,water$WaterU)

water$WaterT_S<-ifelse(water$Location=="Argentina" & is.na(water$WaterT), water$WaterU,water$WaterT)


waterT<-water$WaterT
waterR<-water$WaterR
waterU<-water$WaterU
waterU_S<-water$waterU_S
waterT_S<-water$WaterT_S



edv_sa_hlm$waterT <- waterT
edv_sa_hlm$waterR <- waterR
edv_sa_hlm$waterU <- waterU
edv_sa_hlm$waterU <- waterU
edv_sa_hlm$waterU_S <- waterU_S
edv_sa_hlm$waterT_S <- waterT_S


################@
################
################
################anemia
################

anemia <- read.csv2('./anemia.csv', sep = ',')
anemia <- anemia[, c(8,10,24)]
anemia$Value<-as.numeric(anemia$FactValueNumeric)
anemia<-anemia[,-3]


anemia <- anemia %>%
  arrange(Location, Period) 

anemia<-rbind(anemia,df)

anemia <- anemia$Value
edv_sa_hlm$anemia <- anemia
summary(edv_sa_hlm$anemia)


##############
##############
##############health pc
##############
##############

health_pc <- read.csv2('./health_pc.csv', sep=',')
health_pc <- health_pc[, c(8,10,30)]

health_pc <- health_pc %>%
  arrange(Location, Period) 

health_pc$Value <- as.numeric(health_pc$Value)

health_pc <- health_pc$Value

edv_sa_hlm$health_pc <- health_pc


#################
#################
#################
#################anemia prev
#################

anemia_prev <- read.csv2('./anemia_prev.csv', sep = ',')

anemia_prev <- anemia_prev %>%
  arrange(Location, Period) 
anemia_prev <- anemia_prev[, c(8,10,13,24)]

anemia_prev <- anemia_prev %>%
  pivot_wider(names_from = Dim1, values_from = FactValueNumeric)


#df <- data.frame(Location=unique(anemia_prev$Location), Period=rep(2020, 10), Total=rep(NA, 10),Severe=rep(NA, 10), Mild=rep(NA, 10), Moderate=rep(NA, 10))
#anemia_prev<-rbind(anemia_prev,df)

anemia_prev <- anemia_prev %>%
  arrange(Location, Period) %>%
  rename(aptotal=Total,
         apsevere= Severe,
         apmild= Mild,
         apmoderate=Moderate)


aptotal <- as.numeric(anemia_prev$aptotal)
edv_sa_hlm$aptotal <- aptotal
summary(edv_sa_hlm$aptotal)

apsevere <- as.numeric(anemia_prev$apsevere)
edv_sa_hlm$apsevere <- apsevere
summary(edv_sa_hlm$apsevere)

apmild <- as.numeric(anemia_prev$apmild)
edv_sa_hlm$apmild <- apmild
summary(edv_sa_hlm$apmild)

apmoderate <- as.numeric(anemia_prev$apmoderate)
edv_sa_hlm$apmoderate <- apmoderate
summary(edv_sa_hlm$apmoderate)

anemia_prev$nonp <- anemia_nonp
anemia_prev$preg <- anemia_p



###############
###############
###############
###############alim

alim1 <- read.csv2('./alim.csv', sep=',')
alim <- alim[,c(4,8,10,12)]

alim <- alim %>%
  pivot_wider(names_from = Item, values_from = Value)

alim <- alim[nchar(alim$Year) > 4,]
alim$Year<- substr(alim$Year, start = 1, stop = 4)
alim <- alim[,c(1:3,26)]

alim <- alim %>%
  rename(#s_alim3=`Prevalence of undernourishment (percent) (3-year average)`)
         fats3= `Average fat supply (g/cap/day) (3-year average)`)
#         apmild= Mild,
#         apmoderate=Moderate)

alim$s_alim3 <- gsub("<", "", alim$s_alim3)
alim$s_alim3 <- as.numeric(alim$s_alim3)

summary(alim$s_alim3)

fats3<-alim$fats3
edv_sa_hlm$fats3<-as.numeric(fats3)

s_alim3<- alim$s_alim3

edv_sa_hlm$s_alim3<-s_alim3

#alim1 <- alim[,c(1,2,13:22)]
#alim1 <- alim1[alim1$Year!=c("2000-2002", "2001-2003", "2002-2004", "2003-2005", "2004-2006", "2005-2007", "2006-2008", "2007-2009", "2008-2010", "2009-2011", "2010-2012", "2011-2013", "2012-2014", "2013-2015", "2014-2016", "2015-2017", "2016-2018", "2017-2019", "2018-2020", "2019-2021", "2020-2022"),]

#alim1 <- alim1[nchar(alim1$Year) <= 4,]

#chaine_sans_special <- gsub("#", "", chaine)

#alim1 <- alim1 %>%
#  arrange(Area, Year)
#%>%
#  rename(aptotal=Total,
#         apsevere= Severe,
#         apmild= Mild,
#         apmoderate=Moderate)

#alim1<- alim1 %>%
#  rename(#lowbirth=`Prevalence of low birthweight (percent)`,
        #calories= `Minimum dietary energy requirement  (kcal/cap/day)`,
        #stunted= `Number of children under 5 years of age who are stunted (modeled estimates) (million)`
      # prevanemia =`Prevalence of anemia among women of reproductive age (15-49 years)`)

alim1$prevanemia <- as.numeric(alim1$prevanemia)    

alim1$`Prevalence of anemia among women of reproductive age (15-49 years)`    
alim1$Year<- as.numeric(alim1$Year)

alim1<-alim1[alim1$Year<2021,]

lowbirth <- as.numeric(alim1$lowbirth)
edv_sa_hlm$lowbirth <- lowbirth
calories <- as.numeric(alim1$calories)
edv_sa_hlm$calories <- calories
stunted <- alim1$stunted
edv_sa_hlm$stunted <- stunted

##################@
##################
##################food insec
##################
##################il ne commence qu'en 2014

food_insec <- read.csv2('./food_insec.csv', sep = ',')

food_insec <- food_insec[,c(4,8,10,12)]

food_insec <- food_insec %>%
  pivot_wider(names_from = Item, values_from = Value)


# food_insec<- food_insec %>%
#   rename(#lowbirth=`Prevalence of low birthweight (percent)`,
#     prefoodiF= `Prevalence of severe food insecurity in the female adult population (percent) (3-year average)`,
#     prefoodiM= `Prevalence of severe food insecurity in the male adult population (percent) (3-year average)`,
#     prefoodiT =`Prevalence of severe food insecurity in the total population (percent) (3-year average)`)
# 

food_insec$prefoodiT <- as.numeric(food_insec$prefoodiT )
food_insec$prefoodiM <- as.numeric(food_insec$prefoodiM )
food_insec$prefoodiF <- as.numeric(food_insec$prefoodiF )
food_insec$Year <- as.character(food_insec$Year )

food_insec$year<-as.numeric(factor(food_insec$Year, levels = unique(food_insec$Year)))
#food_insec$year <- food_insec[nchar(food_insec$Year) <= 4,]
food_insec$year<-substr(food_insec$Year, 1, 4)

food_insec$year<- as.numeric(food_insec$year)

alim <- alim[nchar(alim$Year) > 4,]
alim$Year<- substr(alim$Year, start = 1, stop = 4)


###### maternal mortality 
###### 

maternal <- read.csv2('./maternalm.csv', sep = ',')

maternal <-maternal %>%
  rename(country=Location, Year= Period, maternalm = FactValueNumeric)
  #select(Location, Period, FactValueNumeric)%>%
  #arrange(Location, Period, FactValueNumeric)
maternal$maternalm <- as.numeric(maternal$maternalm)

maternalm <- maternal$maternalm

edv_sa_hlm$maternalm<-maternalm

### maternal mortality rate


maternal_mr <- read.csv2('./maternalmr.csv', sep = ',')

maternal_mr <-maternal_mr %>%
  rename(country=Location, Year= Period, maternalmr = FactValueNumeric)
#  select(Location, Period, FactValueNumeric)%>%
#  arrange(Location, Period, FactValueNumeric)
maternal_mr$maternalmr <- as.numeric(maternal_mr$maternalmr)

maternalmr <- maternal_mr$maternalmr

edv_sa_hlm$maternalmr <- maternalmr


########## pol violence

politicalv <- read.csv2('./politicalv.csv', sep=',')
politicalv<- politicalv[c(1:210),]
politicalv<- politicalv[,c(1,3,5)]


politicalv <-politicalv %>%
  rename(country=Country.Name, year= Time, politicalv = Political.Stability.and.Absence.of.Violence.Terrorism..Estimate..PV.EST.)

politicalv <- as.numeric(politicalv$politicalv)
edv_sa_hlm$politicalv <- as.numeric(politicalv)


# maternal_mr <-maternal_mr %>%
#   rename(country=Location, Year= Period, maternalmr = FactValueNumeric)
# #  select(Location, Period, FactValueNumeric)%>%
# #  arrange(Location, Period, FactValueNumeric)
# maternal_mr$maternalmr <- as.numeric(maternal_mr$maternalmr)




# ########### graph lines time series
# ggplot(data=food_insec[food_insec$Area=="Argentina",],mapping=aes(x =year ))+# Create a plot with two lines and a legend
#   geom_line(aes(y = prefoodiF, color = "Women"), size = 1) +
#   geom_point(aes(y = prefoodiF, color = "Women"), size = 2) +
#   geom_line(aes(y = prefoodiT, color = "Total"), size = 1) +
#   geom_point(aes(y = prefoodiT, color = "Total"), size = 2) +
#   labs(title = "Food insecurity in Argentina",
#        x = "Year (first of 3 years)",
#        y = "Food insecurity (3 years average)",
#       caption = "Data source: World Health Organization") +
#   scale_color_manual(values = c("Women" = "purple", "Total" = "brown")) +
#   # theme(legend.title = element_blank())+  # Optional: To remove legend title
#   # theme(plot.title = element_text(hjust = 0.5, face = "bold"),
#   #      plot.caption = element_text(face = "italic")) +
#   theme_economist()
# 
# 


help(theme_economist)

  
#####################edv_sa_hlm$ratio_dptsalim <- edv_sa_hlm$dpt3/edv_sa_hlm$s_alim3
### colonne ratio
edv_sa_hlm$ratio_hpibpc <- (edv_sa_hlm$health_pc/edv_sa_hlm$pib_pc)*100





