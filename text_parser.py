# /!\ Aya's Emergency Text Parser /!\
def formater_texte(fichier_entree, fichier_sortie):
    with open(fichier_entree, 'r', encoding='utf-8') as f_entree:
        contenu = f_entree.read()
    
    paragraphs = contenu.split('\n\n\n')
    
    formatted_paragraphs = []
    for paragraph in paragraphs:
        lines = paragraph.splitlines()
        formatted_paragraph = '| '.join([line.strip() for line in lines if line.strip() != ''])
        formatted_paragraphs.append(formatted_paragraph)
    
    contenu_formate = '\n\n'.join(formatted_paragraphs)
    
    with open(fichier_sortie, 'w', encoding='utf-8') as f_sortie:
        f_sortie.write(contenu_formate)

fichier_entree = 'site_text.txt'
fichier_sortie = 'site_text_parsed.txt'
formater_texte(fichier_entree, fichier_sortie)