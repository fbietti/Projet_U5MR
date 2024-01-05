# Projet_U5MR
Dans ce projet, vous trouverez les codes correspondant à la structuration et à l'analyse d'une base de données sur la mortalité infantile. Depuis février 2023, je travaille sur un projet visant à modéliser la mortalité infantile en Amérique du Sud. J'ai constaté que la mortalité infantile a été très étudiée pour les pays d'Afrique subsaharienne et d'Asie du Sud, pour les pays dits PMA (Pays les Moins Avancés) ou PME (Pays à Revenu Intermédiaire Inférieur), ainsi que pour les pays développés (par exemple, les pays membres de l'OCDE), mais moins pour les pays d'Amérique du Sud. La spécificité de la situation de ces pays a été moins documentée. C'est ainsi que cette recherche a vu le jour.

Ensuite, j'ai commencé à réfléchir sur la méthodologie pertinente. Après avoir travaillé avec des méthodes panel, j'ai décidé d'essayer une modélisation avec des méthodes hiérarchiques linéaires, ou HLM pour ces acronymes en anglais. Ces méthodes présentent un avantage par rapport aux méthodes panel : nous pouvons mesurer la relation des variables avec le temps.

Voici les courbes de la mortailté infantile en Amérique du Sud pour la période 2000-2020 :

![alt text](https://github.com/fbietti/Projet_U5MR/blob/main/plots/plot1.png)



## Fichier U5MR_dataset

Ce fichier contient toutes les commandes qui m'ont permis d'obtenir la base de données. Même si le modèle ne contient que 6 variables explicatives, la base de données en contient 65. Ces 65 variables proviennent de différentes enquêtes et bases de données : la Banque mondiale, le WDII, le Global Health Observatory et la Food and Agriculture Organization. 

## Fichier code_analyse

Ce fichier contient les commandes pour estimer les modèles. J'ai estimé trois modèles HLM. Le premier modèle est un modèle nul ou modèle 0. Il ne contient aucun prédicteur. Le modèle 1 contient tous les prédicteurs, mais il n'incorpore pas le temps (il a une version réduite avec seulement les variables statistiquement significatives). Le modèle 2 contient toutes les variables pour le temps (mais sans prendre en compte l'interaction des variables avec le temps et il contient aussi une version réduite). Le troisième modèle contient toutes les variables et leur interaction avec le temps (il a aussi une version réduite).

Voici les modèles null, 1 et 1 réduit : 
![alt text](https://github.com/fbietti/Projet_U5MR/blob/main/plots/plot2.png)

Ici les modèles 2 et sa version réduite :


![alt text](https://github.com/fbietti/Projet_U5MR/blob/main/plots/plot3.png)

Enfin, vous trouverez ici les modèles 3 et sa version réduite : 


![alt text](https://github.com/fbietti/Projet_U5MR/blob/main/plots/plot4.png)

# Fichier pca
Avant de commencer la modélisation, j'ai réalisé une analyse en composantes principales (ACP) afin d'obtenir une idée de la distribution des données. L'objectif était de déterminer quels pays sont similaires entre eux et quelles variables sont fortement corrélées, à l'exception du taux de mortalité infantile (U5MR). Je voulais savoir s'il existait des pays vraiment similaires entre eux et des groupes vraiment différents. Cette intuition s'est confirmée. La région possède des pays proches entre eux, formant des groupes assez distincts. 

Pour réaliser l'ACP, j'ai sélectionné un ensemble restreint de variables liées au niveau de revenus, aux inégalités, au PIB, au niveau de développement, aux dépenses publiques en santé et au marché du travail. J'ai inclus la variable sur la mortalité mais pas directement sur le calcul des dimensions. 

D'abord, vous pouvez voir la corrélation entre les variables incluses dans l'ACP :  
![alt text](https://github.com/fbietti/Projet_U5MR/blob/main/plots/plot5.png)

Ensuite, le graphique des individus en fonction de la variable mortalité infantile : 
![alt text](https://github.com/fbietti/Projet_U5MR/blob/main/plots/plot6.png)

Après, le graphique des variables : 

![alt text](https://github.com/fbietti/Projet_U5MR/blob/main/plots/plot7.png)

Puis, la variance expliquée par chaque dimension : 

![alt text](https://github.com/fbietti/Projet_U5MR/blob/main/plots/plot8.png)

Enfin, la contruibution de chaque individu pour le premier axe : 
![alt text](https://github.com/fbietti/Projet_U5MR/blob/main/plots/plot9.png)


