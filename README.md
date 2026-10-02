# Gestionnaire de recettes

Application développée en Python permettant de récupérer et consulter des recettes de cuisine ainsi que des informations sur la disponibilité de produits en magasin.

Le projet combine web scraping, base de données PostgreSQL et interface graphique.

## Fonctionnalités

- Récupération automatique de recettes depuis Marmiton
- Extraction des ingrédients, étapes, ustensiles et temps de préparation
- Stockage des recettes au format JSON
- Gestion d'une base de données PostgreSQL
- Recherche de recettes par nom
- Consultation des détails d'une recette
- Gestion des ingrédients, ustensiles, magasins et disponibilités
- Affichage des prix et disponibilités de produits
- Interface graphique réalisée avec Tkinter

## Technologies utilisées

- Python
- PostgreSQL
- SQL
- Tkinter
- Requests
- BeautifulSoup
- psycopg2
- JSON

## Structure du projet

```text
├── main.py
├── scrapper.py
├── script.sql
├── update.sql
├── recettes.json
└── pdf/
```

- `main.py` : interface graphique et connexion à PostgreSQL
- `scrapper.py` : récupération des recettes
- `script.sql` : création de la base de données
- `update.sql` : mise à jour et ajout de données
- `recettes.json` : recettes récupérées par le scraper

## Installation

Installer les dépendances nécessaires :

```bash
pip install requests beautifulsoup4 psycopg2-binary
```

Créer une base PostgreSQL nommée :

```text
gestion_recettes
```

Puis exécuter `script.sql`.

Lancer ensuite le scraper :

```bash
python scrapper.py
```

Puis exécuter `update.sql`.

Enfin, lancer l'application :

```bash
python main.py
```

## Contexte

Projet réalisé dans le cadre de ma Licence Informatique à l'Université d'Artois.