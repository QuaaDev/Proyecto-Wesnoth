extends Node
class_name carga_terrain_assets

var imprimir_errores : bool = false #Interruptor para el debug
#Cosas a arreglar:
#Tema de mayusculas/minusculas
#Valores mas altos tendran prioridad sobre valores mas bajos
enum Prioridad {
	Any = 0,
	Bosque = 2,
	Agua = 1,
	Pasto = 15,
	Desierto = 10
}

const Any : Dictionary = {
	Bosque = "uid://du6e3pfiqfr6h",
	Desierto = "uid://7evul0ioo4dw",
	Agua = "uid://crx8t2eq05dvm",
	Pasto = "uid://b37wdxv6qwx71"
}

const Desierto : Dictionary = {
	Pasto = "uid://djkmepytgxmbh"#Desierto-Pasto
}
func _ready() -> void:
	if !imprimir_errores:
		print("No se imprimiran errores sobre carga_terrain_assets")
	#print(obtener_path("Bosque", "brbrbr"))
	
func obtener_path (origen : String, vecino : String) -> String:
	if existe_la_combinacion(origen, vecino):
		return get(origen)[vecino]
	else:
		return "Error"
	
func existe_la_combinacion(origen : String, vecino : String) -> bool:
	if existe_la_variable(origen):#Comprueba si existe la variable para evitar errores
		if get(origen).has(vecino):#Comprueba si existe la key en el diccionario para evitar errores
			return true#----------return-------------------
		else:
			if imprimir_errores:
				push_error("No existe la key ",vecino," en el diccionario ", origen)
	else:
		if imprimir_errores:
			push_error("No existe la constante ",origen," devolviendo error")
	return false
func mayor_prioridad_que_vecino(terreno_x : String, terreno_y : String) -> bool:
	#Si el terreno X tiene menor prioridad que el terreno Y, este toma el terreno de Y en su layer.
	#Si el terreno X tiene mayor prioridad que el terreno Y, este saltea la ejecucion para que Y tome su layer luego
	var valor_x : int = -1
	var valor_y : int = 0
	if terreno_x in Prioridad:
		valor_x = Prioridad[terreno_x]
	if terreno_y in Prioridad:
		valor_y = Prioridad[terreno_y]
	if valor_x >= valor_y:
		return false
	else:
		return true

func existe_la_variable(nombre: String) -> bool:
	if get(nombre) == null: #Si es null, la constante no existe
		return false
	else: 
		return true
