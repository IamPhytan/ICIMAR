# Interface de Cinématique Inverse pour les Manipulateurs Redondants

Interface de calcul de cinématique pour les manipulateurs redondants

## Utilisation

### Architecture

Ajoutez les membres du bras à tracer dans le [fichier de configuration de l'architecture](./configurations/config.example/architecture.txt), avec la syntaxe suivante:

```md
<type-de-joint> <longueur-du-membre> <longueur-du-membre> <angle-en-degrés>
```

Les types de joints sont représentés par une lettre indiquant les joints suivants:

| Lettre | Type de joint |
| ------ | ------------- |
| `R`    | Rotorique     |
| `P`    | Prismatique   |

Par exemple, pour un membre long de 5 unités, large de 2 unités, avec un angle de 60 degrés
par rapport au membre précédent et relié à celui-ci par un joint rotorique:

```md
R 5 2 60
```

### Cibles

Ajoutez le nom du fichier de planification, les vitesses cartésiennes maximales de l'organe terminal et les cibles à atteindre par le bras dans le [fichier de configuration des cibles](./configurations/config.example/cibles.txt).

La syntaxe suivante doit être utilisée pour donner les vitesses cartésiennes maximales:

```md
<vitesse-maximale-en-x> <vitesse-maximale-en-y> <vitesse-angulaire-maximale-en-degres>
```

Par exemple, pour un organe terminal se déplaçant avec une vitese maximale de `2 m/s` en `x` et en `y` et avec une vitesse maximale de `5 °/s`:

```md
2 2 5
```

La syntaxe suivante doit être utilisée pour donner les cibles à atteindre par le bras:

```md
<coordonnee-en-x> <coordonnee-en-y> <angle-en-degres>
```

Par exemple, pour une cible à atteidnre au point `(5, 3)` avec un angle d'approche de `30°` par rapport à l'axe des x:

```md
5 3 30
```

### Obstacles

Ajoutez les membres du bras à tracer dans le [fichier de configuration des obstacles](./configurations/config.example/obstacles.txt), avec la syntaxe suivante:

```md
<coordonnee-en-x-du-centre> <coordonnee-en-y-du-centre> <rayon-de-l-obstacle>
```

Par exemple, pour un obstacle centré au point `(6, 2)` avec un rayon de 3:

```md
6 2 3
```

## Vidéos des exemples

### Exemple 1

Atteindre un point avec un robot PPPR

#### Planificateur _PosOnly_

>![Video de l'exemple](./videos/Exemple1-Planner_PosOnly-PPPR.mp4)

#### Planificateur _Critere_mid_prismatic_

>![Video de l'exemple](./videos/Exemple1-Planner_Critere_mid_Prismatic-PPPR.mp4)

### Exemple 2

#### Planificateur _PosOnly_

>![Video de l'exemple](./videos/Exemple2-Planner_PosOnly-RRRRRRRRRRRRRRRRRRRRRRRRRRRRRR.mp4)

#### Planificateur _Critere_Mem_Dist_

>![Video de l'exemple](./videos/Exemple2-Planner_Critere_Mem_Dist-RRRRRRRRRRRRRRRRRRRRRRRRRRRRRR.mp4)
