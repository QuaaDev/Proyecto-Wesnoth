extends Node
class_name carga_terrain_assets

var imprimir_errores : bool = true #Interruptor para el debug
#Cosas a arreglar:
#Tema de mayusculas/minusculas
#Valores mas altos tendran prioridad sobre valores mas bajos
enum Prioridad {
	Any = 0,
	Bosque = 2,
	Agua = 1,
	Desierto = 10
}
const Blanco : Dictionary = {
	Negro = "uid://d0a42yhqderap",#blanco-negro
	Rojo = "uid://m7wtfl36bpe5",#blanco-rojo
	Verde = "uid://dersk2j5ltlxq"#blanco-verde
}
const Negro : Dictionary = {
	Blanco = "uid://dm3jpurp47x04", #negro-blanco
	Rojo = "uid://qxu7gbsjy6x0",#negro-rojo
	Verde = "uid://d4i7ljw0c5ovb"#negro-verde
}
const Rojo : Dictionary = {
	 Blanco = "uid://bijnbi605ss1a",
	 Negro = "uid://dy6qu6n7x5h57",
	 Verde = "uid://80r73n0c8bgg"
	
}

const Verde : Dictionary = {
	 Blanco = "uid://bbcupc8rq7alb",
	 Negro = "uid://dnsptjgwq1wyo",
	 Rojo = "uid://drnpukd1sgcu2"
	
}
const Any : Dictionary = {
	Bosque = "uid://du6e3pfiqfr6h",
	Desierto = "uid://7evul0ioo4dw",
	Agua = "uid://crx8t2eq05dvm"
}
func _ready() -> void:
	pass
	#print(obtener_path("Bosque", "brbrbr"))
func obtener_path (origen : String, vecino : String) -> String:
	if existe_la_variable(origen):#Comprueba si existe la variable para evitar errores
		if get(origen).has(vecino):#Comprueba si existe la key en el diccionario para evitar errores
			return get(origen)[vecino]#----------return-------------------
		else:
			if imprimir_errores:
				push_error("No existe la key ",vecino," en el diccionario ", origen)
	else:
		if imprimir_errores:
			push_error("No existe la constante ",origen," devolviendo error")
	return "Error"
	

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
