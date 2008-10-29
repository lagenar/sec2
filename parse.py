import re

funcion = re.compile('(function|procedure) (.*)\([^{]*{\n([^}]*})')
parametros = re.compile('^@(.*)\n', re.MULTILINE)
descripcion = re.compile('^([^@].*)\n}', re.MULTILINE)

def parse_file(filename='sec2.pas'):
    f = open(filename)
    data = f.read()
    modulos = funcion.findall(data)
    for modulo in modulos:
        pars = parametros.findall(modulo[2])
        desc = descripcion.findall(modulo[2])
        print modulo[1]
        for p in pars:
            print p
        for d in desc:
            print d

if __name__ == "__main__":
    parse_file()


