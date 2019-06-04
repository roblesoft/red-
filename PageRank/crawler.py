import re
import os
from indexer import indexer

def crawler():
    path = '/mnt/c/Users/user/Documents/red-cliente-servidor/PageRank/world_wide_web/'
    world_wide_web = indexer('/mnt/c/Users/user/Documents/red-cliente-servidor/PageRank/world_wide_web/')

    matriz_de_transicion = [ [0 for j in range(len(world_wide_web))] for page in world_wide_web.keys()]
 
    for key, value in world_wide_web.items():
        pagina = open(path + "www." + value + '.com.html', 'r')
        pag = open(path + "www." + value + '.com.html', 'r')
        links = 0
        for linea in pagina:
            if re.findall('www.([a-zA-Z]+).com', linea):
                links += 1
        for linea in pag:
            if re.findall('www.([a-zA-Z]+).com', linea):
                for encontrado in re.finditer('www.([a-zA-Z]+).com', linea):
                    sub_cadena = list(encontrado.span())
                    direccion = (linea[sub_cadena[0]:sub_cadena[1]])[4: -4]
                    lookup = {value: key for key, value in world_wide_web.items()}
                    matriz_de_transicion[lookup[direccion]][key]= 1/links
    #for row in matriz_de_transicion:
    #    print("\n")
    #    for col in row:
    #        print("| {:.2f} |\t ".format(col), end="")

    #print("")
    return matriz_de_transicion, world_wide_web
