# Projet_U5MR
In this project, you will find the codes corresponding to the structuring and analysis of a database on infant mortality. Since February 2023, I have been working on a project aimed at modeling infant mortality in South America. I have noticed that infant mortality has been extensively studied for Sub-Saharan African and South Asian countries, for so-called LDCs (Least Developed Countries) or LMICs (Lower Middle-Income Countries), as well as for developed countries (e.g., OECD member countries), but less so for South American countries. The specificity of the situation in these countries has been less documented. This is how this research came about.

Then, I started thinking about the appropriate methodology. After working with panel methods, I decided to try modeling with hierarchical linear models, or HLM for short. These methods offer an advantage over panel methods: we can measure the relationship of variables over time.

Here are the curves of infant mortality in South America for the period 2000-2020:
![alt text](https://github.com/fbietti/Projet_U5MR/blob/main/plots/plot1.png)


French version: 
Dans ce projet, vous trouverez les codes correspondant à la structuration et à l'analyse d'une base de données sur la mortalité infantile. Depuis février 2023, je travaille sur un projet visant à modéliser la mortalité infantile en Amérique du Sud. J'ai constaté que la mortalité infantile a été très étudiée pour les pays d'Afrique subsaharienne et d'Asie du Sud, pour les pays dits PMA (Pays les Moins Avancés) ou PME (Pays à Revenu Intermédiaire Inférieur), ainsi que pour les pays développés (par exemple, les pays membres de l'OCDE), mais moins pour les pays d'Amérique du Sud. La spécificité de la situation de ces pays a été moins documentée. C'est ainsi que cette recherche a vu le jour.

Ensuite, j'ai commencé à réfléchir sur la méthodologie pertinente. Après avoir travaillé avec des méthodes panel, j'ai décidé d'essayer une modélisation avec des méthodes hiérarchiques linéaires, ou HLM pour ces acronymes en anglais. Ces méthodes présentent un avantage par rapport aux méthodes panel : nous pouvons mesurer la relation des variables avec le temps.





## File U5MR_dataset
This file contains all the commands that allowed me to obtain the database. Even though the model contains only six explanatory variables, the database includes 65. These 65 variables come from different surveys and databases: the World Bank, WDII, the Global Health Observatory, and the Food and Agriculture Organization.

French version: 
Ce fichier contient toutes les commandes qui m'ont permis d'obtenir la base de données. Même si le modèle ne contient que 6 variables explicatives, la base de données en contient 65. Ces 65 variables proviennent de différentes enquêtes et bases de données : la Banque mondiale, le WDII, le Global Health Observatory et la Food and Agriculture Organization. 

## File code_analysis

This file contains the commands for estimating the models. I estimated three HLM models. The first model is a null model or model 0. It contains no predictors. Model 1 includes all predictors but does not incorporate time (it has a reduced version with only statistically significant variables). Model 2 includes all variables for time (but without considering the interaction of variables with time, and it also has a reduced version). The third model includes all variables and their interaction with time (it also has a reduced version).

Here are the null model, model 1, and reduced model 1:

![alt text](https://github.com/fbietti/Projet_U5MR/blob/main/plots/plot2.png)


Here are model 2 and its reduced version:

![alt text](https://github.com/fbietti/Projet_U5MR/blob/main/plots/plot3.png)

Finally, here are model 3 and its reduced version:

![alt text](https://github.com/fbietti/Projet_U5MR/blob/main/plots/plot4.png)

After that, I calculated the relationship between slopes and intercepts:
![alt text](https://github.com/fbietti/Projet_U5MR/blob/main/plots/plot10.png)


Frenche Version:
Ce fichier contient les commandes pour estimer les modèles. J'ai estimé trois modèles HLM. Le premier modèle est un modèle nul ou modèle 0. Il ne contient aucun prédicteur. Le modèle 1 contient tous les prédicteurs, mais il n'incorpore pas le temps (il a une version réduite avec seulement les variables statistiquement significatives). Le modèle 2 contient toutes les variables pour le temps (mais sans prendre en compte l'interaction des variables avec le temps et il contient aussi une version réduite). Le troisième modèle contient toutes les variables et leur interaction avec le temps (il a aussi une version réduite).


# Data set
You will find the file base_U5MR.csv, which you can use to reproduce the results presented in the code_analysis file.

French version:
Vous trouverez le fichier base_U5MR.csv avec lequel vous pouvez reproduire les résultats présentés dans le fichier Code_analyse

# File pca
Before starting the modeling, I conducted a Principal Component Analysis (PCA) to get an idea of the data distribution. The objective was to determine which countries are similar to each other and which variables are strongly correlated, except for the infant mortality rate (U5MR). I wanted to see if there were truly similar countries and distinct groups. This intuition was confirmed. The region has countries that are close to each other, forming quite distinct groups.

To perform the PCA, I selected a restricted set of variables related to income level, inequalities, GDP, development level, public health expenditures, and the labor market. I included the mortality variable but not directly in the calculation of dimensions.

First, you can see the correlation between the variables included in the PCA:
![alt text](https://github.com/fbietti/Projet_U5MR/blob/main/plots/plot5.png)


Then, the graph of individuals based on the infant mortality variable:
![alt text](https://github.com/fbietti/Projet_U5MR/blob/main/plots/plot6.png)


Next, the graph of the variables:
![alt text](https://github.com/fbietti/Projet_U5MR/blob/main/plots/plot7.png)



Then, we examined the variance explained by each dimension:
![alt text](https://github.com/fbietti/Projet_U5MR/blob/main/plots/plot8.png)



Finally, the contribution of each individual to the first axis:
![alt text](https://github.com/fbietti/Projet_U5MR/blob/main/plots/plot9.png)


French Version: 
Avant de commencer la modélisation, j'ai réalisé une analyse en composantes principales (ACP) afin d'obtenir une idée de la distribution des données. L'objectif était de déterminer quels pays sont similaires entre eux et quelles variables sont fortement corrélées, à l'exception du taux de mortalité infantile (U5MR). Je voulais savoir s'il existait des pays vraiment similaires entre eux et des groupes vraiment différents. Cette intuition s'est confirmée. La région possède des pays proches entre eux, formant des groupes assez distincts. 

Pour réaliser l'ACP, j'ai sélectionné un ensemble restreint de variables liées au niveau de revenus, aux inégalités, au PIB, au niveau de développement, aux dépenses publiques en santé et au marché du travail. J'ai inclus la variable sur la mortalité mais pas directement sur le calcul des dimensions. 


