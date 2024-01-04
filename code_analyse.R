#######
#######
#######Code HLM modèle cours 
#######

# install.packages("sjPlot")
# install.packages("broom")

#Paquetes 
library(tidyverse)
library(lme4)
library(lmerTest)
library(readxl)
library(jtools)
library(sjPlot)
library(broom)
# library(sjmisc)
# library(sjlabelled)
library("tibble")

#Cargamos base de datos 
library(tibble)
library(ggplot2)
library(ggthemes)


write.csv2(edv_sa_hlm,'./edv_sa_hlm.csv', row.names = F )

# Assuming your DataFrame is named df
edv_sa_hlm <- as_tibble(edv_sa_hlm)


#modèle null 
M0 <- lmer(mort_inf ~ 1 + (1|ID), REML = F, data = edv_sa_hlm)
summary(M0)
summ(M0)

#modèle 1 (avec toutes les variables retenues mais sans inclure le temps)
#M1 <- lmer(log(mort_inf) ~ 1 + co2  +educ+ chomage + s_alim + chomage_j_femmes + part_pop_active_femmes + pop_rurale + health_pib +health_gdp+ dpt3+ palma+ mvc1+anemia_nonp+anemia_p+educ_gdp+(1|ID), REML = F, data = edv_sa_hlm)
M1 <- lmer(mort_inf ~ 1+s_alim3+pop_urbaine+aptotal+mvc1+dpt3+ratio_hpibpc+(1|ID), REML = F, data = edv_sa_hlm)
summary(M1)
summ(M1)
tab_model(M0, M1)

summary(edv_sa_hlm$s_alim3)

#modèle 1 réduit (sans inclure le temps)
M1red <- lmer(mort_inf ~ 1+s_alim3+aptotal+pop_urbaine+(1|ID), REML = F, data = edv_sa_hlm)

summary(M1red)
summ(M1red)

tab_model(M1red)


#tableau comparatif des modèles 
tab_model(M0, M1, M1red)

# pour exporter le tableau
# tab_model(M0, M1, M1red, file = "Compa1.doc")



#modèle 2 (avec la variable temps)
M2 <- lmer((mort_inf) ~ 1+mvc1+dpt3+s_alim3+pop_urbaine+aptotal+ratio_hpibpc+t+(1+t|ID), REML = F, data = edv_sa_hlm)

summary(M2)
summ(M2)
tab_model(M2)


hist((edv_sa_hlm$s_alim3))

  #modèle 2 réduit (avec temps)
#

M2red <- lmer((mort_inf) ~ 1+s_alim3+aptotal+pop_urbaine+t+(1+t|ID), REML = F, data = edv_sa_hlm)

# M2red <- lmer((mort_inf) ~ 1+ratio_hpibpc+t+ratio_hpibpc*t+ (1+t|ID), REML = F, data = edv_sa_hlm)


colnames(edv_sa_hlm)


edv_sa_hlm %>%
  #filter(country == "Argentina") %>%
  group_by(year) %>%
  summarise(avg_value = mean(aptotal, na.rm = TRUE)) %>%
  print(n=21)

summary(M2red)
summ(M2red)
tab_model(M2red) 



tab_model(M2, M2red)

colnames(edv_sa_hlm)
summary(edv_sa_hlm$politicalv)

# modelo3 (interacciones en el tiempo 
M3 <- lmer(mort_inf ~ 1+mvc1+dpt3+s_alim3+pop_urbaine+aptotal+ratio_hpibpc+t+mvc1*t+dpt3*t+s_alim3*t+pop_urbaine*t+aptotal*t+ratio_hpibpc*t+(1+t|ID), REML = F, data = edv_sa_hlm)
#control = lmerControl(optimizer ="Nelder_Mead")

summary(M3)
summ(M3)
tab_model(M3)

#
M3red <- lmer((mort_inf) ~ 1+aptotal+s_alim3+pop_urbaine+t+pop_urbaine*t+aptotal*t+s_alim3*t+(1+t|ID), REML = F, data = edv_sa_hlm)
#control = lmerControl(optim

summary(M3red)
summ(M3red)
tab_model(M3red)

### optimizador para convergencia control = lmerControl(optimizer ="Nelder_Mead")

tab_model(M3, M3red)



### Table full model
tab_model(M0, M1, M2, M3)

tab_model(M0, M1red, M2red, M3red)





#####################################################
#####################################################
# On estime les modèles pour chaque pays et on obtient les ordonnées à l'origne et les pentes des courbes

edv_sa_hlm$ID <- as.factor(edv_sa_hlm$ID) #
class(edv_sa_hlm$ID)


b <- edv_sa_hlm %>%                                      
  group_by(ID) %>%                                
  do(model = tidy(lm(mort_inf ~ t,data = .))) %>%    
  unnest(model)                                 


int_slopes <- b %>%     #Pivot_wider: réduire les lignes et augmenter les colonnes  
  pivot_wider(id_cols = c(ID),  # Colonnes que l'on veut pas faire tourner 
              names_from = term,  #  
              values_from = estimate) %>%  #  
  rename(intercept = `(Intercept)`, # 
         pente = t) %>% 
  mutate(Pays = unique(edv_sa_hlm$country)) #Agregamos el nombre del pais

#Graficamos interceptos vs pendientes 
int_slopes %>% 
  ggplot(aes(intercept, pente)) +
  geom_point(col="firebrick", size=2) +
  theme_minimal()+
  geom_text(aes(label=Pays),vjust=1.5) +
  scale_y_continuous(limits = c(-2.5,0.5)) +
  scale_x_continuous(limits = c(0,80),
                     breaks = seq(0,80,10))+
  theme_economist()# 



