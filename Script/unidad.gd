extends Node2D
@onready var nodo_mundo = self.get_parent()
@onready var tile_map: Node2D = $"../TileMap"
var coordenada_local_tilemap : Vector2 #La coordenada local del tilemap

@export var equipo : int = 0

func _ready() -> void:
	self.add_to_group(str(equipo))
	#print(self.get_groups())
	coordenada_local_tilemap = tile_map.local_to_map(position)
	var coordenada_global = tile_map.map_to_local(coordenada_local_tilemap)
	self.position = coordenada_global #Centra a la unidad en la celda
	#Terminar esto luego, el codigo no funciona prq el nodo "tilemap" es un node2d, no un nodo XD
	pass



func siendo_movido() -> void:
	self.modulate = Color(18.892, 0.0, 0.0, 0.448)
	
func ya_no_me_mueven() -> void:
	self.modulate = Color(1.0, 1.0, 1.0, 1.0)


func _on_area_2d_mouse_entered() -> void:
	nodo_mundo.obtener_unidad_bajo_mouse(self)


func _on_area_2d_mouse_exited() -> void:
	nodo_mundo.limpiar_unidad_bajo_mouse()
