extends Node2D
var cuadricula_seleccionada_mouse : Vector2 = Vector2(-1,-1) #Almacena la cuadricula que fue seleccionada por el codigo

@onready var tile_map_hud: TileMapLayer = $tile_map_hud
@onready var label_coordenadas: Label = $"../coordenadas_local"

func _input(_event):
	pass

func _ready() -> void:
	pass
func _process(_delta: float) -> void:
	if coordenada_global_del_mouse_a_tilemap() != cuadricula_seleccionada_mouse: #Si la coordenada actual no esta seleccionada
		tile_map_hud.set_cell(cuadricula_seleccionada_mouse,2,Vector2(0,0),0)#Dibuja el tilemap  de contorno
		cuadricula_seleccionada_mouse = coordenada_global_del_mouse_a_tilemap() #Actualiza la coordenada de la nueva seleccionada
		tile_map_hud.set_cell(cuadricula_seleccionada_mouse, 0, Vector2i(0,0), 0) #Dibuja el hud de la cuadricula seleccionada
	#----------Todo lo que interactue con cuadricula_seleccionada_mouse que se ejecute por debajo de esto-------------
	label_coordenadas.text = "coordenadas del tilemap: " + str(coordenada_global_del_mouse_a_tilemap())
	#imprime en la pantalla las coordenadas exactas segun la posicion del mouse
func coordenada_global_del_mouse_a_tilemap() -> Vector2:
	#devuelve la ubicacion global del mouse convertida en las coordenadas del tilemap
	return tile_map_hud.local_to_map(get_viewport().get_mouse_position())
	
	
#---------func de tilemap-----------
func local_to_map(valor : Vector2):
	return tile_map_hud.local_to_map(valor)
	
func map_to_local(valor : Vector2):
	return tile_map_hud.map_to_local(valor)
