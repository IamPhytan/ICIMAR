# Interface de Cinématique Inverse pour les Manipulateurs Redondants

Interface de calcul de cinématique pour les manipulateurs redondants

## Utilisation

### Architecture

Ajouter les membres du bras à tracer dans le [fichier de configuration de l'architecture](./architecture.txt), avec la syntaxe suivante :

```md
<type-de-joint> <longueur> <largeur> <angle>
```

Les types de joints sont représentés par une lettre indiquant les joints suivants:

| Lettre | Type de joint |
| ------ | ------------- |
| `R`    | Rotorique     |
| `P`    | Prismatique   |

Par exemple, pour un membre long de 5 unités, large de 2 unités, avec un angle de 60 degrés
par rapport au membre précédent et relié à celui-ci par un joint rotorique  :

```md
R 5 2 60
```
