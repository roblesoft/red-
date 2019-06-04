
def pageRank(matriz):
    from numpy.linalg import matrix_power
    import numpy as np
    from functools import reduce
    from math import fabs
    from ThreadReturn import ThreadReturn
    import time
    import queue
    from threading import Thread
    import threading

    pesos_iniciales = [1/(len(matriz)) for pagina in range(len(matriz))]
    def arreglo(resultado, pesos, mat, inicio, fin):
        for i in range(inicio, fin):
            fila = []
            for j in range(len(mat)):
                fila.append(pesos[i] * mat[i][j])
            resultado.append(fila)
    def sumfilas(mat, matresul, ini, fin):
        for i in range(ini, fin):
            mat.append(reduce(lambda x, y: x + y, matresul[i]))

    def sistema_dinamico(mat, pesos, exponente=1):
        array = np.array(mat)
        mat = matrix_power(mat, exponente).tolist()
        matriz_resultado = []
        #for i in range(len(mat)):
        #    fila = []
        #    for j in range(len(mat)):
        #        fila.append(pesos[i] * mat[i][j])
        #    matriz_resultado.append(fila)
        divisor = len(mat)
        inicio = 0
        hilos = 5
        lista_hilos = list()
        for hilo in range(0, hilos):
            partes = int(len(mat) / hilos)
            if divisor % hilos != 0:
                partes += 1
                divisor -= 1
            final = (inicio + int(partes))
            thread = Thread(target=arreglo, args=(matriz_resultado, pesos, mat, inicio, final))
            inicio = final
            lista_hilos.append(thread)
        for hilo in lista_hilos:
            hilo.start()

        divisor = len(mat)
        inicio = 0
        lista_hilos = list()
        pesos_nuevos = []
        for hilo in range(0, hilos):
            partes = int(len(mat) / hilos)
            if divisor % hilos != 0:
                partes += 1
                divisor -= 1
            final = (inicio + int(partes))
            hilo = Thread(target=sumfilas, args=(pesos_nuevos, matriz_resultado, inicio, final))
            inicio = final
            hilo.start()

        return pesos_nuevos

    def checkUmbral(pesos_inicio, pesos_finales, exp=1):
        success = 0
        for valor in range(len(pesos_iniciales)):
            umbral = fabs(pesos_finales[valor] - pesos_inicio[valor])
            if  umbral >= 0.0 and umbral <= 0.001:
                success += 1

        hilo_de_pesos_ini = ThreadReturn(target=sistema_dinamico, args=(matriz, pesos_iniciales, exp), name='pesos_ini')
        hilo_de_pesos_ini.start()
        #pesos_ini = sistema_dinamico(matriz, pesos_iniciales, exp)


        if success != len(pesos_finales):
            exp += 1
            hilos_de_pesos_finales = ThreadReturn(target=sistema_dinamico, args=(matriz, pesos_iniciales, exp), name='pesos_fin')
            hilos_de_pesos_finales.start()
            pesos_finales = hilos_de_pesos_finales.join()
            pesos_ini = hilo_de_pesos_ini.join()
            #pesos_finales = sistema_dinamico(matriz, pesos_iniciales, exp)
            return checkUmbral(pesos_ini, pesos_finales, exp)
        else:  
            pesos_ini = hilo_de_pesos_ini.join()
            return pesos_ini


    pesos_finales = sistema_dinamico(matriz, pesos_iniciales)
    pesos = checkUmbral(pesos_iniciales, pesos_finales, 1)
    return pesos