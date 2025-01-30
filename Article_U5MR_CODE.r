
######données exportables

# 
# install.packages("knitr")
# install.packages("kableExtra")
# install.packages("summarytools")

library(summarytools)

library(knitr)
library(kableExtra)
library(gt)
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
library(ggrepel)



# 
# data <- cbind(edv_sa_hlm$country, edv_sa_hlm$year, edv_sa_hlm$t, edv_sa_hlm$mort_inf, edv_sa_hlm$mvc1, edv_sa_hlm$dpt3, edv_sa_hlm$s_alim3, edv_sa_hlm$aptotal, edv_sa_hlm$pop_urbaine, edv_sa_hlm$ratio_hpibpc)
# rm(data)
# 
# data <-edv_sa_hlm[,c(1,2,5,6,11,39,42,60,56, 12, 54)]
# write.csv2(data, './base_U5MR.csv', row.names = F)

base_UMR <- read.csv2('./base_U5MR.csv')

colnames(base_UMR)



##### ---- M0---- 
M0 <- lmer(log(mort_inf) ~ 1 + (1|ID), REML = F, data = base_UMR)
summary(M0)
summ(M0)

##### ----  M1 ---- 
M1 <- lmer(log(mort_inf) ~ 1 + dpt3+ mvc1+ s_alim3 + pop_urbaine+ aptotal + ratio_hpibpc + (1|ID), REML = F, data = base_UMR)
summary(M1)
summ(M1)
tab_model(M0, M1)


### ---- M1 residuals  ----- 
residuals <- resid(M1)
# Histogram of  residuals
hist(residuals, breaks = 30, main = "Histogram of residuals", xlab = "Residuals")

#Graphique Q-Q of residuals
qqnorm(residuals)
qqline(residuals)

shapiro.test(residuals)
ks.test(residuals, "pnorm", mean(residuals), sd(residuals))


# Créer un PDF vectoriel
pdf("figure1.pdf", width = 7, height = 5)
# Densitiy plot
plot(density(residuals), main = "Density Plot des Résidus Model 1", xlab = "Residuals", col = "blue")
# Ajouter une courbe normale
curve(dnorm(x, mean=mean(residuals), sd=sd(residuals)), add=TRUE, col="red", lwd=2)
dev.off()


##### ----- RED M1  -----
M1red <- lmer(log(mort_inf) ~ 1  + dpt3+ mvc1+ s_alim3 + pop_urbaine+ aptotal + (1|ID), REML = F, data = base_UMR)
summary(M1red)
summ(M1red)
tab_model(M1red)

### ---- RED M1 residuals  ----- 
residuals <- resid(M1red)
# Histogram of  residuals
hist(residuals, breaks = 30, main = "Histogram of residuals", xlab = "Residuals")

#Graphique Q-Q of residuals
qqnorm(residuals)
qqline(residuals)

shapiro.test(residuals)
ks.test(residuals, "pnorm", mean(residuals), sd(residuals))

# Créer un PDF vectoriel
pdf("figure2.pdf", width = 7, height = 5)
# Densitiy plot
plot(density(residuals), main = "Density Plot des Résidus Reduced Model 1", xlab = "Residuals", col = "blue")
# Ajouter une courbe normale
curve(dnorm(x, mean=mean(residuals), sd=sd(residuals)), add=TRUE, col="red", lwd=2)
dev.off()


##### ----  TABLE M0, M1 and RED M1 ---- 
tab_model(M0, M1, M1red)




##### ----  M2 (including time) ---- 
M2 <- lmer(log(mort_inf) ~ 1+mvc1+dpt3+s_alim3+pop_urbaine+aptotal+ratio_hpibpc+t+(1+t|ID), REML = F, data = base_UMR)

summary(M2)
summ(M2)
tab_model(M2)

### ---- M2 residualls  ---- 
residuals <- resid(M2)
# Histogramme des résidus
hist(residuals, breaks = 30, main = "Histogram of residuals", xlab = "Residuals")
#Graphique Q-Q des résidus
qqnorm(residuals)
qqline(residuals)

shapiro.test(residuals)
ks.test(residuals, "pnorm", mean(residuals), sd(residuals))

# Créer un PDF vectoriel
pdf("figure4.pdf", width = 7, height = 5)
# Densitiy plot
plot(density(residuals), main = "Density Plot des Résidus Model 2", xlab = "Residuals", col = "blue")
# Ajouter une courbe normale
curve(dnorm(x, mean=mean(residuals), sd=sd(residuals)), add=TRUE, col="red", lwd=2)
dev.off()

#### --- RED M2 ----

M2red <- lmer(log(mort_inf) ~ 1+s_alim3+pop_urbaine+aptotal+t+(1+t|ID), REML = F, data = base_UMR)

summary(M2red)
summ(M2red)
tab_model(M2red)

#### --- RED M2 residuals  ----
residuals <- resid(M2red)
# Histogramme des résidus
hist(residuals, breaks = 30, main = "Histogram of residuals", xlab = "Residuals")
qqnorm(residuals)
qqline(residuals)

shapiro.test(residuals)
ks.test(residuals, "pnorm", mean(residuals), sd(residuals))


# Créer un PDF vectoriel
pdf("figure5.pdf", width = 7, height = 5)
plot(density(residuals), main = "Density Plot des Résidus Reduced Model 2", xlab = "Residuals", col = "blue")
curve(dnorm(x, mean=mean(residuals), sd=sd(residuals)), add=TRUE, col="red", lwd=2)
dev.off()

### ---- TABLE MOD 2 and RED M2 ----
tab_model(M2, M2red)



##### ----  M3 (including interactions with time) ---- 
M3 <- lmer(log(mort_inf) ~ 1+mvc1+dpt3+s_alim3+pop_urbaine+aptotal+ratio_hpibpc+t+mvc1*t+dpt3*t+s_alim3*t+pop_urbaine*t+aptotal*t+ratio_hpibpc*t+(1+t|ID), REML = F, data = base_UMR)

summary(M3)
summ(M3)
tab_model(M3)

#### ---M3 residuals  ----
residuals <- resid(M3)
hist(residuals, breaks = 30, main = "Histogram of residuals", xlab = "Residuals")
qqnorm(residuals)
qqline(residuals)

shapiro.test(residuals)
ks.test(residuals, "pnorm", mean(residuals), sd(residuals))
plot(density(residuals), main = "Density Plot des Résidus", xlab = "Residuals", col = "blue")
curve(dnorm(x, mean=mean(residuals), sd=sd(residuals)), add=TRUE, col="red", lwd=2)



#### ---- RED M3 (including interactions with time) ----
M3red <- lmer(log(mort_inf) ~ 1+s_alim3+aptotal+pop_urbaine+t+s_alim3*t+aptotal*t+pop_urbaine*t+(1+t|ID), REML = F, data = base_UMR)

summary(M3red)
summ(M3red)
tab_model(M3red)

#### ---RED M3 residuals  ----
residuals <- resid(M3red)
hist(residuals, breaks = 30, main = "Histogram of residuals", xlab = "Residuals")
qqnorm(residuals)
qqline(residuals)

shapiro.test(residuals)
ks.test(residuals, "pnorm", mean(residuals), sd(residuals))
plot(density(residuals), main = "Density Plot des Résidus", xlab = "Residuals", col = "blue")
curve(dnorm(x, mean=mean(residuals), sd=sd(residuals)), add=TRUE, col="red", lwd=2)


### ---- TABLE MOD 3 and RED M3 ----

tab_model(M3, M3red)


##### ----  TABLE M0, M1, M2, M3 ---- 

tab_model(M0, M1, M2, M3)

##### ----  TABLE M0, RED M1, RED M2, RED M3 ---- 
tab_model(M0, M1red, M2red, M3red)




##### ---- Coef Vs intercept plot ----


coef_m2red <-coef(M2red)
coef_m2red <- coef_m2red$ID
colnames(coef_m2red)[1] <- "intercept"

country<-unique(base_UMR$country)
coef_m2$country <- country
coef_m2red$country <- country

# Créer un PDF vectoriel
pdf("figure3.pdf", width = 7, height = 5)
ggplot(data = coef_m2red, aes(x = intercept, y = t)) +
  geom_point(size = 3,) +  # Increase point size and set color
  geom_text_repel(aes(label = country), size = 3.5, color = "black", max.overlaps = 10) +  
  labs(x = "Intercept",
       y = "t Coefficient",
       title = "Intercept vs. t Coefficient",
       caption = "Source: Own from World Bank, FAO, and GHO") +
  theme_classic(base_size = 14) +  
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold", size = 16), 
    plot.caption = element_text(hjust = 0, face = "italic", size = 10),  
    axis.title = element_text(size = 14),  
    axis.text = element_text(size = 12),  
    panel.grid.major = element_line(size = 0.5, linetype = 'solid', color = "grey80"),  
    panel.grid.minor = element_blank(),  
    axis.line = element_line(color = "black")  
  )
dev.off()






##### ---- Summary Stats ---- 
summary_stats <- summary(base_UMR[,c(4:10)])

## kable format
table <- kable(summary_stats, "html") %>%
  kable_styling("striped", full_width = F) %>%
  add_header_above(c(" ", "U5MR" = 1, "MCV1 Coverage" = 1, "DPT3 Coverage" = 1, "Undernourrishment"=1, "Anemia prevalence women"=1, "% of urban population"=1, "Ratio health expenditure pc/GDP pc"=1))
writeLines(as.character(table), "statistiques_descriptives.html")

table

## other version  
## install.packages("skimr")
library(skimr)
library(labelled)

var_label(base_UMR$mort_inf) <- "U5MR"
var_label(base_UMR$dpt3) <- "DPT3 Coverage"
var_label(base_UMR$mvc1) <- "MCV1 Coverage"
var_label(base_UMR$s_alim3) <- "Undernourrishment"
var_label(base_UMR$aptotal) <- "Anemia prevalence women"
var_label(base_UMR$pop_urbaine) <- "% of urban population"
var_label(base_UMR$ratio_hpibpc) <- "Ratio health pib pc/pib pc"


desc_mt <- base_UMR[,-c(1:4)] %>% skim() %>%yank("numeric")%>% as_tibble()

for_table <- desc_mt %>% 
  select(Variable = 1,
         Mean = 4,
         SD = 5,
         Minimum = 6,
         Maximum = 10) %>% 
  mutate(across(where(is.numeric), ~round(., 1))) ### round : the output

for_table %>% 
  kable(caption = "Summary Statistics (n = 210)") %>% 
  kable_styling(
    bootstrap_options = "striped", 
    full_width = FALSE, 
    position = "center", 
    fixed_thead = TRUE 
  ) %>% 
  column_spec(1, bold = TRUE, border_right = TRUE)%>% 
  footnote(general = "Own with data from GHO, FAO and World Bank", ###  
           #number = c("Footnote 1; ", "Footnote 2; "),
           #alphabet = c("Footnote A; ", "Footnote B; "),
           #symbol = c("Footnote Symbol 1; ", "Footnote Symbol 2"),
           general_title = "Source: ", number_title = "Type I: ",
           #alphabet_title = "Type II: ", symbol_title = "Type III: ",
           footnote_as_chunk = T, title_format = c("italic", "underline"
           )  
  )

ccc