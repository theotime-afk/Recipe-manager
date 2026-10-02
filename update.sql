--gluten
UPDATE ingredient
SET allergene = (SELECT id_allergene FROM allergene WHERE LOWER(nom_allergie) = 'gluten')
WHERE LOWER(nom_ingredient) LIKE '%farine%'
   OR LOWER(nom_ingredient) LIKE '%pain%'
   OR LOWER(nom_ingredient) LIKE '%pâte%'
   OR LOWER(nom_ingredient) LIKE '%semoule%'
   OR LOWER(nom_ingredient) LIKE '%blé%';

-- lactose
UPDATE ingredient
SET allergene = (SELECT id_allergene FROM allergene WHERE LOWER(nom_allergie) = 'lactose')
WHERE LOWER(nom_ingredient) LIKE '%lait%'
   OR LOWER(nom_ingredient) LIKE '%beurre%'
   OR LOWER(nom_ingredient) LIKE '%crème%'
   OR LOWER(nom_ingredient) LIKE '%fromage%'
   OR LOWER(nom_ingredient) LIKE '%yaourt%';

--fruit coque
UPDATE ingredient
SET allergene = (SELECT id_allergene FROM allergene WHERE LOWER(nom_allergie) = 'fruit à coque')
WHERE LOWER(nom_ingredient) LIKE '%amande%'
   OR LOWER(nom_ingredient) LIKE '%noix%'
   OR LOWER(nom_ingredient) LIKE '%noisette%'
   OR LOWER(nom_ingredient) LIKE '%pistache%'
   OR LOWER(nom_ingredient) LIKE '%cajou%';

--oeuf
UPDATE ingredient
SET allergene = (SELECT id_allergene FROM allergene WHERE LOWER(nom_allergie) = 'oeuf')
WHERE LOWER(nom_ingredient) LIKE '%oeuf%'
   OR LOWER(nom_ingredient) LIKE '%oeufs%';

-- poisson
UPDATE ingredient
SET allergene = (SELECT id_allergene FROM allergene WHERE LOWER(nom_allergie) = 'poisson')
WHERE LOWER(nom_ingredient) LIKE '%poisson%'
   OR LOWER(nom_ingredient) LIKE '%saumon%'
   OR LOWER(nom_ingredient) LIKE '%thon%'
   OR LOWER(nom_ingredient) LIKE '%maquereau%';



INSERT INTO disponibilite (id_produit, id_magasin, en_stock, prix) VALUES

--oeuf
((SELECT id_ingredient FROM ingredient WHERE LOWER(nom_ingredient) LIKE '%oeuf%' LIMIT 1),(SELECT id_magasin FROM magasin WHERE nom_magasin = 'Carrefour'),TRUE,2.50),
((SELECT id_ingredient FROM ingredient WHERE LOWER(nom_ingredient) LIKE '%oeuf%' LIMIT 1),(SELECT id_magasin FROM magasin WHERE nom_magasin = 'Auchan'),FALSE,2.00),

--lait
(
(SELECT id_ingredient FROM ingredient WHERE LOWER(nom_ingredient) LIKE '%lait%' LIMIT 1),
(SELECT id_magasin FROM magasin WHERE nom_magasin = 'Lidl'),
FALSE,
2.10
),
(
(SELECT id_ingredient FROM ingredient WHERE LOWER(nom_ingredient) LIKE '%lait%' LIMIT 1),
(SELECT id_magasin FROM magasin WHERE nom_magasin = 'Intermarché'),
TRUE,
1.80
),

--mixeur
(
(SELECT id_ustensile FROM ustensile WHERE LOWER(nom_ustensile) LIKE '%mixeur%' LIMIT 1),
(SELECT id_magasin FROM magasin WHERE nom_magasin = 'Leclerc'),
TRUE,
20.00
),
(
(SELECT id_ustensile FROM ustensile WHERE LOWER(nom_ustensile) LIKE '%mixeur%' LIMIT 1),
(SELECT id_magasin FROM magasin WHERE nom_magasin = 'Auchan'),
TRUE,
25.00
),



--balance
(
(SELECT id_ustensile FROM ustensile WHERE LOWER(nom_ustensile) LIKE '%balance%' LIMIT 1),
(SELECT id_magasin FROM magasin WHERE nom_magasin = 'Lidl'),
FALSE,
10.99
);