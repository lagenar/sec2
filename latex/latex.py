doc = r"""\documentclass{article}
\author{Lucas Moauro}
\date{}
\title{Sec II: Sistema de expendio de combustible}
\begin{document}
\maketitle
\newpage
%(servicios)s\end{document}
"""

servicio = r"""\section{%(servicio)s}
%(modulos)s"""

modulo = r"""\subsection{%(modulo)s}
%(parametros)s\newline
%(descripcion)s
"""

parametro = r"""\textbf{%(nombre)s}\newline
"""

def escape(str):
    return str.replace('_', r'\_').rstrip()

def make_doc(services):
    servs = ''
    for service in services:
        modules = ''
        for module in service['modulos']:
            pars = ''
            for p in module['parametros']:
                pars += escape(parametro % {'nombre':p})
            modules += modulo % {'modulo':escape(module['nombre']),
                                 'parametros':pars,
                                 'descripcion':escape(module['descripcion'][0])}
        servs += servicio % {'servicio':service['nombre'],
                                'modulos': modules}
    return doc % {'servicios':servs}
