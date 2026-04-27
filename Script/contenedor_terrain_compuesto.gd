extends Node
class_name terrain_compuesto

var terreno_origen : String
var terreno_vecino : String
var terreno_compuesto : String

func cargar_terrenos(origen : String, vecino : String):
	terreno_origen = origen
	terreno_vecino = vecino
	terreno_compuesto = origen + "-" + vecino
