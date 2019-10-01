Salut

Quelques infos utiles :
- base poissons :
1/ dans « Fish_Intermediate_allstations_2003-2018 » (fichier de données brutes), bug dans COREMO ma base de saisie et d’archivage) qui m’oblige à exporter TOUTE la base, or j’ai fait une sélection : seuls les identifiants listés dans « Fish_Observation_allstations_2003-2018 » sont à prendre en compte
2/ certaines (rares) années l’identifiant bug… voici comment l’identifiant est construit :
NCLI01412312A
 => NCL (pour Nouvelle-Calédonie), I (??) 01 (année, campagne 2001-2002 pour le coup) 412312 (station) A (réplicat, il devrait toujours être A car une collecte de données par an par compartiment biologique et par station)
- base invertébrés : à partir de 2010 on a commencé à mesurer les bénitiers (code BEN) et trocas (code TRO). Les tailles sont saisies dans la colonne « Remarks ». Je ne pense pas qu’on s’en serve dans le cadre de ce projet, mais au cas où je le signale (que tu ne t’affoles pas en voyant des tonnes de chiffres!! car sur certains spots de NC c’est damé de bénitiers!!)
- base habitats : structure différente
Comme on a dit, je pense qu’il vaudrait mieux recréer un nouvel identifiant pour le projet REEF SCORE, sous la forme : Année_n° de la station_n° du transect
Par exemple : 05_01_01 (année 2005, station 1, transect 1)

Les données sont dans la Dropbox du projet.

N’hésite pas à me contacter

A plus

Sandrine

Pas fini en fait, quelques précisions sur base Benthos : 180807_BD_RORC_Benthos_v03f
L’onglet qui va t’intéresser est BD_annuelles_Benthos
Dans la colonne « Année » (J) : attention, décalage de un an => quand il est noté 2018, en fait les données ont été collectées en 2019
Si on doit homogénéiser avec poissons et invertébrés, il faut donc rajouter +1 an à Année.
N° Station est logiquement le même que celui dans bases Invertébrés et Poissons mais sait on jamais, à vérifier (avec le nom de la station c le plus simple).
Ne t’occupe pas des données de 1997 à 2001
Donc logiquement les données que je vais partager pour le projet courent de 2004 à 2019.
J’espère que cela n’est pas trop confus….. 🤪
Tinkiou

Sandrine
