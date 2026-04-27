extends Node
class_name terrain_compuesto

var terreno_origen : String
var terreno_vecino : String
var terreno_compuesto : String
var id : int

func cargar_terrenos(origen : String, vecino : String)-> void:
	terreno_origen = origen
	terreno_vecino = vecino
	terreno_compuesto = origen + "-" + vecino

func cargar_id(nueva_id : int) -> void:
	id = nueva_id
