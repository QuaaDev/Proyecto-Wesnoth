extends Node
class_name carga_terrain_assets
#Cosas a arreglar:
#Tema de mayusculas/minusculas
#Si un valor no existe en el get, que sucede? Como se procede?

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
func obtener_path (origen : String, vecino : String) -> String:
	return get(origen)[vecino]
