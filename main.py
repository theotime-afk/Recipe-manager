import tkinter as tk
from tkinter import ttk
import json

import psycopg2
conn = psycopg2.connect(
    dbname="gestion_recettes",
    user="postgres",
    password="",
    host="localhost"
)
cursor = conn.cursor()



with open("recettes.json", "r", encoding="utf-8") as f:
    recettes = json.load(f)

def afficher_recette(event):
    selection = liste_recettes.curselection()
    if not selection:
        return

    index = selection[0]
    recette = recettes[index]

    titre_label.config(text=recette["nom"])

    ingredients_text.delete(1.0, tk.END)
    for i in recette["ingredients"]:
        ingredients_text.insert(tk.END, "- " + i + "\n")

    etapes_text.delete(1.0, tk.END)
    for i, e in enumerate(recette["etapes"], start=1):
        etapes_text.insert(tk.END, f"{i}. {e}\n\n")

    ustensiles_text.delete(1.0, tk.END)
    for u in recette["ustensiles"]:
        ustensiles_text.insert(tk.END, "- " + u + "\n")

    temps_text.delete(1.0, tk.END)
    temps_text.insert(tk.END, "Temps total : " + recette["temps_total"] + "\n\n")

    for k, v in recette["temps_detail"].items():
        temps_text.insert(tk.END, f"{k} : {v}\n")

    


def rechercher():
    recherche = search_var.get().lower()

    liste_recettes.delete(0, tk.END)

    for r in recettes:
        if recherche in r["nom"].lower():
            liste_recettes.insert(tk.END, r["nom"])


produits = []

def charger_produits():
    produit_listbox.delete(0,tk.END)
    produits.clear()

    cursor.execute("SELECT id_ingredient, nom_ingredient FROM ingredient")
    for p in cursor.fetchall():
        produits.append(("ingredient", p[0],p[1]))
        produit_listbox.insert(tk.END, p[1])

    cursor.execute("SELECT id_ustensile, nom_ustensile FROM ustensile")
    for p in cursor.fetchall():
        produits.append(("ustensile",p[0],p[1]))
        produit_listbox.insert(tk.END, p[1])


def afficher_disponibilite(event):
    selection = produit_listbox.curselection()
    if not selection:
        return

    ind = selection[0]
    type_p,id_p,nom = produits[ind]

    dispo_text.delete(1.0, tk.END)
    dispo_text.insert(tk.END, f"{nom}")

    cursor.execute("""SELECT magasin.nom_magasin, disponibilite.en_stock,disponibilite.prix
                      FROM disponibilite
                      JOIN magasin ON disponibilite.id_magasin = magasin.id_magasin
                      where disponibilite.id_produit = %s """, (id_p,))

    res = cursor.fetchall()
    for m in res:
        statut = "disponible" if m[1] else "rupture"
        dispo_text.insert(tk.END, f"{m[0]}- {statut} - {m[2]}")






root = tk.Tk()
root.title("Gestionnaire de recettes")
root.geometry("900x600")

#recherche
search_var = tk.StringVar()

frame_top = tk.Frame(root)
frame_top.pack(fill="x", padx=10, pady=5)

tk.Label(frame_top, text="Rechercher une recette :").pack(side="left")

search_entry = tk.Entry(frame_top, textvariable=search_var)
search_entry.pack(side="left", padx=5)

tk.Button(frame_top, text="Rechercher", command=rechercher).pack(side="left")

#fenetre prin
main_frame = tk.Frame(root)
main_frame.pack(fill="both", expand=True)

#recette
liste_frame = tk.Frame(main_frame)
liste_frame.pack(side="left", fill="y")

liste_recettes = tk.Listbox(liste_frame, width=30)
liste_recettes.pack(fill="y", expand=True)

for r in recettes:
    liste_recettes.insert(tk.END, r["nom"])

liste_recettes.bind("<<ListboxSelect>>", afficher_recette)

#details
detail_frame = tk.Frame(main_frame)
detail_frame.pack(side="right", fill="both", expand=True)

titre_label = tk.Label(detail_frame, text="Sélectionnez une recette", font=("Arial", 18))
titre_label.pack(pady=10)

notebook = ttk.Notebook(detail_frame)
notebook.pack(fill="both", expand=True)

#ingre
ingredients_tab = tk.Frame(notebook)
notebook.add(ingredients_tab, text="Ingrédients")

ingredients_text = tk.Text(ingredients_tab)
ingredients_text.pack(fill="both", expand=True)

#etape
etapes_tab = tk.Frame(notebook)
notebook.add(etapes_tab, text="Étapes")

etapes_text = tk.Text(etapes_tab)
etapes_text.pack(fill="both", expand=True)

#ustensile
ustensiles_tab = tk.Frame(notebook)
notebook.add(ustensiles_tab, text="Ustensiles")

ustensiles_text = tk.Text(ustensiles_tab)
ustensiles_text.pack(fill="both", expand=True)

#temps
temps_tab = tk.Frame(notebook)
notebook.add(temps_tab, text="Temps")

temps_text = tk.Text(temps_tab)
temps_text.pack(fill="both", expand=True)

#mag
#magasin_tab = tk.Frame(notebook)
#notebook.add(magasin_tab, text="Magasins")

#magasin_listbox = tk.Listbox(magasin_tab)
#magasin_listbox.pack(fill="both", expand=True)

dispo_tab = tk.Frame(notebook)
notebook.add(dispo_tab,text='Disponibilité')

produit_listbox = tk.Listbox(dispo_tab)
produit_listbox.pack(side="left", fill="y")

dispo_text = tk.Text(dispo_tab)
dispo_text.pack(side="right",fill="both",expand=True)

produit_listbox.bind("<<ListboxSelect>>", afficher_disponibilite)
charger_produits()



root.mainloop()