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


#modelo nulo 
M0 <- lmer(mort_inf ~ 1 + (1|ID), REML = F, data = edv_sa_hlm)
summary(M0)
summ(M0)

#modelo 1 (sin incluir el tiempo)
#M1 <- lmer(log(mort_inf) ~ 1 + co2  +educ+ chomage + s_alim + chomage_j_femmes + part_pop_active_femmes + pop_rurale + health_pib +health_gdp+ dpt3+ palma+ mvc1+anemia_nonp+anemia_p+educ_gdp+(1|ID), REML = F, data = edv_sa_hlm)
M1 <- lmer(mort_inf ~ 1+s_alim3+pop_urbaine+aptotal+mvc1+dpt3+ratio_hpibpc+(1|ID), REML = F, data = edv_sa_hlm)
summary(M1)
summ(M1)
tab_model(M0, M1)

summary(edv_sa_hlm$s_alim3)

#modelo 1 reducido (sin incluir tiempo)
M1red <- lmer(mort_inf ~ 1+s_alim3+aptotal+pop_urbaine+(1|ID), REML = F, data = edv_sa_hlm)

summary(M1red)
summ(M1red)

tab_model(M1red)


#tabla comparativa de los modelos 
tab_model(M0, M1, M1red)

# Si quieren exportar esta tabla a word (Se guarda en el directorio)
# tab_model(M0, M1, M1red, file = "Comparacion1.doc")



#modelo 2 (incluyendo el tiempo)
M2 <- lmer((mort_inf) ~ 1+mvc1+dpt3+s_alim3+pop_urbaine+aptotal+ratio_hpibpc+t+(1+t|ID), REML = F, data = edv_sa_hlm)

summary(M2)
summ(M2)
tab_model(M2)


hist((edv_sa_hlm$s_alim3))

  #modelo 2 reducido (Incluyendo el tiempo)
#

M2red <- lmer((mort_inf) ~ 1+s_alim3+aptotal+pop_urbaine+t+(1+t|ID), REML = F, data = edv_sa_hlm)

# M2red <- lmer((mort_inf) ~ 1+ratio_hpibpc+t+ratio_hpibpc*t+ (1+t|ID), REML = F, data = edv_sa_hlm)


colnames(edv_sa_hlm)


edv_sa_hlm %>%
  #filter(country == "Argentina") %>%
  group_by(year) %>%
  summarise(avg_value = mean(aptotal, na.rm = TRUE)) %>%
  print(n=21)


########### graph lines time series 
ggplot(data=edv_sa_hlm[edv_sa_hlm$country=="Argentina",],mapping=aes(x =year ))+# Create a plot with two lines and a legend
  geom_line(aes(y = anemia, color = "Total"), size = 1) +
  geom_point(aes(y = anemia, color = "Total"), size = 2) +
  geom_line(aes(y = ges, color = "health pc"), size = 1) +
  geom_point(aes(y = lowbirth, color = "health pc"), size = 2) +
  labs(title = "Undernourrishment in Argentina",
       x = "Year",
       y = "Undernourrishment (3 years average)",
       caption = "Data source: WHO and FAO") +
  #scale_color_manual(values = c("Total" = "purple", "health pc" = "brown")) +
  theme(legend.title = element_blank())+  # Optional: To remove legend title
  theme(plot.title = element_text(hjust = 0.5, face = "bold"),
        plot.caption = element_text(face = "italic")) 



summary(M2red)
summ(M2red)
tab_model(M2red) 



tab_model(M2, M2red)

########### graph lines time series 
ggplot(data=subset(edv_sa_hlm, !is.na(politicalv)),mapping=aes(x = year, y= politicalv ,col=country))+
#geom_point(size=1) +
 #geom_path() +
  geom_line(size=1)+
 #facet_wrap(~groupe, ncol=3)+
  labs(x = "Population using safely managed drinking-water services (%)",
       y = "Infant mortality rate (U5)",
       title = "U5MR by % population using safely managed drinking-water services",
       #subtitle = "",
       caption = "Data source: World Bank/World Health Organization")+ ##les étiquettes des axex, le titre, la source 
  # theme(plot.title = element_text(hjust = 0.5, face = "bold"),
  #       plot.caption = element_text(face = "italic")) +
  theme_economist() 
    # geom_text(data = edv_sa_hlm %>% filter(year == 2005),
  #            aes(x=year, y=s_alim3, label=country), hjust=0,vjust=0)### pour la mise en forme du titre et de la source
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



########### graph lines time series 
ggplot(data=edv_sa_hlm,mapping=aes(x =t , y= pop_urbaine, col=country))+
  geom_line(size=1)+
  facet_wrap(~groupe, ncol=3)+
  labs(x = "Year",
       y = "ratio health pib pc",
       title = "",
       #subtitle = "",
       caption = "Data source: World Bank")+ ##les étiquettes des axex, le titre, la source
  theme(plot.title = element_text(hjust = 0.5, face = "bold"),
        plot.caption = element_text(face = "italic"))### pour la mise en forme du titre et de la source


###########
###########
###########tables 

### Table full model
tab_model(M0, M1, M2, M3)

tab_model(M0, M1red, M2red, M3red)





#####################################################
# Ajustamos regresiones para cada uno de los paises #
# y obtenemos sus pendientes e interceptos          #
#####################################################

edv_sa_hlm$ID <- as.factor(edv_sa_hlm$ID) #Cambiamos el ID a factor 
class(edv_sa_hlm$ID)


b <- edv_sa_hlm %>%                                     #"Fijamos" la base de datos 
  group_by(ID) %>%                               #Agrupamos por pais (su ID)
  do(modelo = tidy(lm(mort_inf ~ t,data = .))) %>%    #do es util para modelos por grupos 
  unnest(modelo)                                 #unnest para extraer componentes anidados o "desanidar"


### Ejemplo de unnest ###
# df <- tibble(
#   a = list(c("a", "b"), "c"),
#   b = list(1:2, 3),
#   c = c(11, 22)
# )
# df
# df %>% unnest(c(a, b))



int_slopes <- b %>%     #Pivot_wider: reducir filas y aumentar columnas 
  pivot_wider(id_cols = c(ID),  # Columnas que no quieres que se giren o pivoten 
              names_from = term,  # De que col toma los nombres para las nuevas columnas 
              values_from = estimate) %>%  # indica de que columna toma los valores 
  rename(intercepto = `(Intercept)`, # renombramos las columnas a nuestra conveniencia
         pendiente = t) %>% 
  mutate(Pais = unique(edv_sa_hlm$country)) #Agregamos el nombre del pais

#Graficamos interceptos vs pendientes 
int_slopes %>% 
  ggplot(aes(intercepto, pendiente)) +
  geom_point(col="firebrick", size=2) +
  theme_minimal()+
  geom_text(aes(label=Pais),vjust=1.5) +
  scale_y_continuous(limits = c(-2.5,0.5)) +
  scale_x_continuous(limits = c(0,80),
                     breaks = seq(0,80,10))+
  theme_economist()#Tema del paquete cowplot 



#Grafica panel de los paises en el tiempo 
str(edv_sa_hlm)


edv_sa_hlm %>% 
  ggplot(aes((year), mort_inf, group=ID)) +
  geom_smooth(method = lm, se=F, col="firebrick") +
  scale_x_continuous(expand = c(0,0), #quitamos espacio entre ejes y el grafico como tal
                     limits = c(2000,2020), #definimos un limite para eje x
                     breaks = seq(2000,2020,2))+  #valores de 2 en 2, desde 1996 hasta 2016
   geom_text(aes(label=country))+ #Incorrecto 
  theme_economist()#Tema del paquete cowplot 

## NOTA : Necesitamos solo la ultima observacion 
x <- c(1:10) 
last(x) #ultima obs del vector x 


edv_sa_hlm %>% 
  ggplot(aes(year, mort_inf, group=ID, col=country)) +
  geom_smooth(method = lm, se=F) +
  scale_x_continuous(expand = c(0,0), #quitamos espacio entre ejes y el grafico como tal
                     limits = c(2000,2020), #definimos un limite para eje x
                     breaks = seq(2000,2020,2)) + #valores de 2 en 2, desde 1996 hasta 2016
  geom_text(data = edv_sa_hlm %>% filter(year == last(year)), 
            aes(label=country), hjust=0,vjust=1) +
  theme_economist()#Tema del paquete cowplot 

# Las etiquetas no estan alineadas, esto se debe a que estamos etiquetando la ultima 
# observacion de la variable PPP (2014). Deben ser los DATOS AJUSTADOS  

fitted_models <- edv_sa_hlm %>%                               
  group_by(ID) %>%                               
  do(augment(lm(mort_inf ~ t, data = .), data=.))


edv_sa_hlm %>% 
  ggplot(aes(year, mort_inf, col=country)) +
  geom_smooth(method = lm, se=F) +
  #facet_wrap(~groupe, ncol=3)+
  scale_x_continuous(expand = c(0,0), #quitamos espacio entre ejes y el grafico como tal
  limits = c(0,20), #definimos un limite para eje x
  breaks = seq(0,20,2)) + #valores de 2 en 2, desde 1996 hasta 2016
  geom_text(data = fitted_models %>% filter(year == 2018),
           aes(x=year, y=.fitted, label=country), hjust=0,vjust=0) +
  cowplot::theme_cowplot()


