def indexer(path):
    """busca todos los archivos html en el word wide web"""
    import os
    directorio = os.listdir(path)
    paginas = [pagina[4:-9] for pagina in directorio]
    world_wide_web = {}
    for index in range(len(paginas)):
        world_wide_web[index] = paginas[index]
    return world_wide_web