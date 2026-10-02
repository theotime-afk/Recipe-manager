-- connexion a la bdd
-- sudo -u postgress psql -d gestion_recttes -f script.sql
--  sudo -u postgres psql
--  \c gestion_recttes

--CREATE DATABASE gestion_recettes;
--USE gestion_recettes;


-- evite doublon si relance script
DROP TABLE IF EXISTS utilise_ustensile CASCADE;
DROP TABLE IF EXISTS magasin CASCADE;
DROP TABLE IF EXISTS compositionmenu CASCADE;
DROP TABLE IF EXISTS compositionrecette CASCADE;
DROP TABLE IF EXISTS recette CASCADE;
DROP TABLE IF EXISTS preparation CASCADE;
DROP TABLE IF EXISTS ingredient CASCADE;
DROP TABLE IF EXISTS allergene CASCADE;
DROP TABLE IF EXISTS type CASCADE;
DROP TABLE IF EXISTS menu CASCADE;
DROP TABLE IF EXISTS ustensile CASCADE;

--renommage de la  table type en type_ingrédient
CREATE TABLE type_ingredient (
    id_type SERIAL PRIMARY KEY,
    type_nourriture VARCHAR(100) NOT NULL
);


CREATE TABLE allergene (
    id_allergene SERIAL PRIMARY KEY,
    nom_allergie VARCHAR(100) NOT NULL,
    description TEXT
);


CREATE TABLE ingredient (
    id_ingredient SERIAL PRIMARY KEY,
    nom_ingredient VARCHAR(100) NOT NULL,
    type INT,
    allergene INT,
    FOREIGN KEY (type) REFERENCES type_ingredient(id_type),
    FOREIGN KEY (allergene) REFERENCES allergene(id_allergene)
);


CREATE TABLE preparation (
    id_prepa SERIAL PRIMARY KEY,
    etapes_prepa TEXT,
    temps_prepa INT
);

CREATE TABLE recette (
    id_recette SERIAL PRIMARY KEY,
    nom_recette VARCHAR(100) NOT NULL,
    difficulte VARCHAR(50),
    description TEXT,
    id_prepa INT,
    temps_cuisson INT,
    FOREIGN KEY (id_prepa) REFERENCES preparation(id_prepa)
);


CREATE TABLE compositionRecette (
    id_recette INT,
    id_ingredient INT,
    quantite VARCHAR(50),
    CONSTRAINT pk_compositionRecette
        PRIMARY KEY (id_recette, id_ingredient),
    FOREIGN KEY (id_recette) REFERENCES recette(id_recette),
    FOREIGN KEY (id_ingredient) REFERENCES ingredient(id_ingredient)
);


CREATE TABLE menu (
    id_menu SERIAL PRIMARY KEY,
    detail_menu TEXT,
    nom_menu VARCHAR(100),
    prix_menu DECIMAL(6,2)
);


CREATE TABLE compositionMenu (
    id_recette INT,
    id_menu INT,
    PRIMARY KEY (id_recette, id_menu),
    FOREIGN KEY (id_recette) REFERENCES recette(id_recette),
    FOREIGN KEY (id_menu) REFERENCES menu(id_menu)
);


CREATE TABLE ustensile (
    id_ustensile SERIAL PRIMARY KEY,
    nom_ustensile VARCHAR(100)
);

CREATE TABLE utilise_ustensile (
    id_prepa INT,
    id_ustensile INT,
    CONSTRAINT pk_utilise_ustensile
        PRIMARY KEY (id_prepa, id_ustensile),
    FOREIGN KEY (id_prepa) REFERENCES preparation(id_prepa),
    FOREIGN KEY (id_ustensile) REFERENCES ustensile(id_ustensile)
);

CREATE TABLE magasin (
    id_magasin SERIAL PRIMARY KEY,
    nom_magasin VARCHAR(100),
    adresse VARCHAR(200),
    id_ingredient INT,
    id_ustensile INT,
    ville VARCHAR(100),
    FOREIGN KEY (id_ingredient) REFERENCES ingredient(id_ingredient),
    FOREIGN KEY (id_ustensile) REFERENCES ustensile(id_ustensile)
);

CREATE TABLE disponibilite (
    id_produit INT,
    id_magasin INT,
    en_stock BOOLEAN,
    prix DECIMAL(6,2),
    PRIMARY KEY (id_produit, id_magasin),
    FOREIGN KEY (id_magasin) REFERENCES magasin(id_magasin),
    FOREIGN KEY(id_produit) REFERENCES ingredient(id_ingredient)

);



--Insert into des données de disponibilité des ingredients/ustensile

INSERT INTO magasin (nom_magasin,adresse) VALUES
('Carrefour','lens'),
('Leclerc','Arras'),
('Lidl','Lille'),
('Intermarché','Douai'),
('Auchan','Arras');

INSERT INTO ingredient (nom_ingredient) VALUES
('Oeuf'),
('lait'),
('sel'),
('farine'),
('beurre'),
('poivre'),
('huile'),
('pain'),
('tomate');

INSERT INTO ustensile(nom_ustensile) VALUES
('Casserole'),
('four'),
('poele'),
('mixeur'),
('louche'),
('balance'),
('moule'),
('Saladier');



INSERT INTO disponibilite (id_produit,id_magasin,en_stock,prix) VALUES
(
(SELECT id_ingredient FROM ingredient WHERE nom_ingredient = 'Oeuf'),
(SELECT id_magasin FROM magasin WHERE  nom_magasin = 'Carrefour'),
TRUE,
2.50);









