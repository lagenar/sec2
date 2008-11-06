import re
from latex.latex import make_doc
SERV = [
    {'nombre':'Programa principal',
     'modulos':['Inicializar_estructuras',
                'Abrir_archivos',
                'Abrir_arc_playeros',
                'Abrir_arc_surtidores',
                'abrir_arc_ventas_acum',
                'Cargar_estructuras',
                'Cargar_lista_surtidores',
                'Cargar_arbol_playeros',
                'Ultimo_dia_vtas_acum',
                'Leer_dia',
                'menu',
                'Guardar_datos',
                'Guardar_playeros',
                'Guardar_vtas_acumuladas',
                'Guardar_surtidores',
                'crear_lista_surt_por_capacidad',
                'insertar_surtidor_por_capacidad',
                'Crear_surtidor',
                'eliminar_lista_surtidores']},
    {'nombre':'Menu',
     'modulos':['Agregar_surtidor',
                'Agregar_playero',
                'Listar_surtidores',
                'Realizar_venta',
                'Cancelar_factura',
                'Calcular_comision_playero',
                'Listar_playeros_comision',
                'salir',
                'calcular_vtas_acumuladas',
                'Litros_vendidos_surtidor',
                'mostrar_ventas_dia'
                ]},
    {'nombre':'Agregar Surtidor',
     'modulos':['Leer_numero_surtidor',
                'Validar_nuevo_surtidor',
                'Surtidor_valido',
                'Surtidor_existente',
                'Buscar_surtidor',
                'Leer_tipo_combustible',
                'Leer_precio_combustible',
                'Validar_precio_combustible',
                'Precio_valido',
                'Leer_capacidad_surtidor',
                'Validar_capacidad_surtidor',
                'Capacidad_valida',
                'Insertar_surtidor',
                'Crear_surtidor',
                'Imprimir_error'
                ]},
    {'nombre':'Agregar playero',
     'modulos':['Leer_numero_playero',
                'Validar_nuevo_playero',
                'Playero_valido',
                'Playero_existente',
                'Buscar_playero',
                'Leer_nombre_playero',
                'Leer_porcentaje_comision',
                'Validar_porcentaje_comision',
                'Comision_valida',
                'Crear_playero',
                'Insertar_playero'
                ]},
    {'nombre':'Listar Surtidores',
     'modulos':['Litros_restantes_surtidor']},
    {'nombre':'Realizar Venta',
     'modulos':['validar_numero_surtidor',
                'validar_nodo_surtidor_venta',
                'validar_numero_playero',
                'validar_nodo_playero_venta',
                'leer_numero_factura',
                'validar_numero_factura',
                'factura_valida',
                'buscar_factura',
                'leer_litros_venta',
                'validar_litros_venta',
                'Capacidad_suficiente',
                'leer_hora',
                'validar_hora',
                'Hora_valida',
                'crear_nodo_venta',
                'insertar_venta',
                'calcular_monto_venta',
                'desea_reintentar']},
    {'nombre':'Cancelar factura',
     'modulos':['validar_numero_factura_cancelar',
                'eliminar_factura',
                'Eliminar_factura_surtidor',
                'Eliminar_nodo_ventas',
                'Buscar_mayor_nodo_ventas',
                'Eliminar_mayor_nodo_ventas']},
    {'nombre':'Calcular comision playero',
     'modulos':['comision_playero',
                'comision_playero_surtidor',
                'Calcular_comision']},
    {'nombre':'Listar playeros por comision',
     'modulos':['Crear_lista_playeros',
                'Insertar_lista_playero',
                'crear_nodo_lista_playero',
                'Eliminar_lista_playeros']}]
                
                
                
                
     
    
                
                
funcion = re.compile('(function|procedure) (.*)\([^{]*{\r\n([^}]*})')
parametros = re.compile('^@(.*)\r\n', re.MULTILINE)
descripcion = re.compile('^([^@][^}]*)}', re.MULTILINE)

def parse_file(filename='sec2.pas'):
    f = open(filename)
    data = f.read()
    modulos = funcion.findall(data)
    result = []
    for modulo in modulos:
	result.append({'nombre':modulo[1],
                       'parametros':parametros.findall(modulo[2]),
                       'descripcion':descripcion.findall(modulo[2])})
    return result
	
def get_mod(lista, mod):
    for m in lista:
        if m['nombre'] == mod.lower():
            return m
    raise Exception, mod

def doc(lista):
    for s in SERV:
        s['modulos'] = map(lambda x: get_mod(lista, x), s['modulos'])
    print make_doc(SERV)
    

if __name__ == "__main__":
    r = parse_file()
    doc(r)
    


