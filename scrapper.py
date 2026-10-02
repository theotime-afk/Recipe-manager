""" lancer le scrapper
    python3 -m venv venv
    source venv/bin/activate
    pip install requests
    pip install beautifulsoup4
    pip install mysql-connector-python
    python3 scrapper.py


    """



import requests
from bs4 import BeautifulSoup
import json



url = "https://www.marmiton.org/recettes"

headers = {
    "User-Agent": "Mozilla/5.0 (X11; Linux x86_64; rv:147.0) Gecko/20100101 Firefox/147.0",
    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
    "Accept-Language": "fr-FR,fr;q=0.9",
}
response = requests.get(url, headers=headers)


soup = BeautifulSoup(response.text, "html.parser")

recettes = soup.find_all("a", class_="card-content__title")

print("Nombre de recettes trouvées :", len(recettes))
recettes_data = []


for r in recettes[:20]:
    titre = r.text.strip()
    lien = "https://www.marmiton.org" + r["href"]
    print("\nRecette :", titre)
    print("Lien :", lien)
    page = requests.get(lien, headers=headers)
    soup_recette = BeautifulSoup(page.text, "html.parser")
    #ingré
    ingredients = soup_recette.find_all("span", class_="ingredient-name")
    
    #etape
    prep_block = soup_recette.find("div", class_="recipe-preparation")
    #temps
    temps_total = prep_block.find("div", class_="time__total").find("div").text.strip()
    temps_detail = {}
    for t in prep_block.find_all("div", class_="time__details")[0].find_all("div"):
        span = t.find("span")
        div = t.find("div")
        if span and div:
            temps_detail[span.text.replace(":", "").strip()] = div.text.strip()

  
    step_list = soup_recette.find("div", class_="recipe-step-list")
    etapes = []
    if step_list:
        containers = step_list.find_all("div", class_="recipe-step-list__container")
        for c in containers:
            p = c.find("p")  
            if p:
                etapes.append(p.text.strip())  
  
    #ustensile
    ustensiles_block = soup_recette.find("div", class_="mrtn-recette_utensils-items")
    ustensiles = []
    if ustensiles_block:
        for u in ustensiles_block.find_all("div", class_="card-utensil"):
            nom = u.get("data-name")
            if nom:
                ustensiles.append(str(nom))
  
    ingredients_text = [i.text.strip() for i in ingredients]
    recette_dict = {

        "nom": titre,
        "lien": lien,
        "ingredients": ingredients_text,
        "etapes": etapes,
        "ustensiles": ustensiles,
        "temps_total": temps_total,
        "temps_detail": temps_detail
    }
    recettes_data.append(recette_dict)


with open("recettes.json", "w", encoding="utf-8") as f:
    json.dump(recettes_data, f, ensure_ascii=False, indent=4)
    print("Fichier recettes.json créé avec succès !")

