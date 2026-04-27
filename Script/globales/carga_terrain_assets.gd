extends Node
class_name carga_terrain_assets

const Blanco : Dictionary = {
	Negro = "uid://d0a42yhqderap",#blanco-negro
	rojo = "uid://m7wtfl36bpe5",#blanco-rojo
	verde = "uid://dersk2j5ltlxq"#blanco-verde
}
const Negro : Dictionary = {
	Blanco = "uid://dm3jpurp47x04", #negro-blanco
	rojo = "uid://qxu7gbsjy6x0",#negro-rojo
	verde = "uid://d4i7ljw0c5ovb"#negro-verde
}

func obtener_path (origen : String, vecino : String) -> String:
	return get(origen)[vecino]
