extends Node2D
@onready var nodo_mundo = self.get_parent()
@onready var tile_map: Node2D = $"../TileMap"
func _ready() -> void:
	#var coordenada_local_tilemap = tile_map.local_to_map(position)
	#var coordenada_global = tile_map.map_to_local(coordenada_local_tilemap)
	#print(coordenada_global)
	#Terminar esto luego, el codigo no funciona prq el nodo "tilemap" es un node2d, no un nodo XD
	pass
