# Projet_U5MR
Dans ce projet, vous trouverez les codes correspondant à la structuration et à l'analyse d'une base de données sur la mortalité infantile. Depuis février 2023, je travaille sur un projet visant à modéliser la mortalité infantile en Amérique du Sud. J'ai constaté que la mortalité infantile a été très étudiée pour les pays d'Afrique subsaharienne et d'Asie du Sud, pour les pays dits PMA (Pays les Moins Avancés) ou PME (Pays à Revenu Intermédiaire Inférieur), ainsi que pour les pays développés (par exemple, les pays membres de l'OCDE), mais moins pour les pays d'Amérique du Sud. La spécificité de la situation de ces pays a été moins documentée. C'est ainsi que cette recherche a vu le jour.

Ensuite, j'ai commencé à réfléchir sur la méthodologie pertinente. Après avoir travaillé avec des méthodes panel, j'ai décidé d'essayer une modélisation avec des méthodes hiérarchiques linéaires, ou HLM pour ces acronymes en anglais. Ces méthodes présentent un avantage par rapport aux méthodes panel : nous pouvons mesurer la relation des variables avec le temps.

Voici les courbes de la mortailté infantile en Amérique du Sud pour la période 2000-2020 :

![alt text](https://github.com/fbietti/Projet_U5MR/tree/main/plots/plot1.png)



## Fichier U5MR_dataset

Ce fichier contient toutes les commandes qui m'ont permis d'obtenir la base de données. Même si le modèle ne contient que 6 variables explicatives, la base de données en contient 65. Ces 65 variables proviennent de différentes enquêtes et bases de données : la Banque mondiale, le WDII, le Global Health Observatory et la Food and Agriculture Organization. 

## Fichier code_analyse

Ce fichier contient les commandes pour estimer les modèles. J'ai estimé trois modèles HLM. Le premier modèle est un modèle nul ou modèle 0. Il ne contient aucun prédicteur. Le modèle 1 contient tous les prédicteurs, mais il n'incorpore pas le temps (il a une version réduite avec seulement les variables statistiquement significatives). Le modèle 2 contient toutes les variables pour le temps (mais sans prendre en compte l'interaction des variables avec le temps et il contient aussi une version réduite). Le troisième modèle contient toutes les variables et leur interaction avec le temps (il a aussi une version réduite).