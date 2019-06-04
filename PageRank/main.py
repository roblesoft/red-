from crawler import crawler
from pageRank import pageRank
import pandas as pd
import time

def main():
    matriz_de_transicion, world_wide_web = crawler()

    tiempo_inicio = time.time()
    pagerank = pageRank(matriz_de_transicion)
    dt = {'Paginas': list(world_wide_web.values()), 'Rank': pagerank}
    df = pd.DataFrame(data=dt)
    print(df)
    df.to_csv('Pagerank.csv', encoding='utf-8', index=False)

if __name__ == '__main__':
    main()
