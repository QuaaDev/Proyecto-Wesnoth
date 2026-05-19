extends Node2D
var cuadricula_seleccionada_mouse : Vector2 = Vector2(-1,-1) #Almacena la cuadricula que fue seleccionada por el codigo

@onready var tile_map_hud: TileMapLayer = $tile_map_hud
@onready var tile_map_base: TileMapLayer = $tile_map_base
@onready var label_coordenadas: Label = $"../CanvasLayer/VBoxContainer/coordenadas_local"
@onready var terrain_carpet: autotile = $tile_map_base/TerrainCarpet

func _input(_event):
	pass

func _ready() -> void:
	AlgoritmoDijkstra.tile_map = self
	AlgoritmoDijkstra.tile_map_hud = tile_map_hud
	AlgoritmoDijkstra.tile_map_base = tile_map_base
	#Fog
	dibujar_fog(terrain_carpet.limite_del_mapa)
func _process(_delta: float) -> void:
	if coordenada_global_del_mouse_a_tilemap() != cuadricula_seleccionada_mouse: #Si la coordenada actual no esta seleccionada
		tile_map_hud.set_cell(cuadricula_seleccionada_mouse,1,Vector2(0,0),0)#Dibuja el tilemap  de contorno
		cuadricula_seleccionada_mouse = coordenada_global_del_mouse_a_tilemap() #Actualiza la coordenada de la nueva seleccionada
		tile_map_hud.set_cell(cuadricula_seleccionada_mouse, 0, Vector2i(0,0), 0) #Dibuja el hud de la cuadricula seleccionada
	#----------Todo lo que interactue con cuadricula_seleccionada_mouse que se ejecute por debajo de esto-------------
	label_coordenadas.text = "coordenadas del tilemap: " + str(coordenada_global_del_mouse_a_tilemap())
	#imprime en la pantalla las coordenadas exactas segun la posicion del mouse

func dibujar_fog(limite_del_mapa : Vector2i) -> void:
	#Carga todo el mapa con un fog
	for x in range(-1,limite_del_mapa.x+1):
		for y in range(-1,limite_del_mapa.y+1):
			tile_map_hud.set_cell(Vector2i(x,y),4,Vector2i(0,0),0)

func actualizar_fog() -> void:
	dibujar_fog(terrain_carpet.limite_del_mapa)
	var diccionario_bufon : Dictionary#Esto es para que el algoritmodijkstra ignore las posiciones de unidades
	var unidades_jugador = get_parent().get_unidades_del_jugador()
	for unidad in unidades_jugador:#Explora todas las unidades
		AlgoritmoDijkstra.moviendo_unidad(unidad, diccionario_bufon, false, true)
		#Obtiene el rango de movimiento, ya que movimiento = vision
		var rango_movimiento = AlgoritmoDijkstra.movimientos_disponibles#Almacena el rango de movimiento
		for i in rango_movimiento:
			tile_map_hud.set_cell(i,1,Vector2i(0,0),0)
			#Elimina el fog de la casilla
		




func coordenada_global_del_mouse_a_tilemap() -> Vector2:
	#devuelve la ubicacion global del mouse convertida en las coordenadas del tilemap
	return tile_map_hud.local_to_map(tile_map_hud.to_local(get_global_mouse_position()))
	#obtiene la posicion global del mouse, convierte las coordenadas a las locales de tilemap
	#y luego lo convierte a las coordenadas de las celdas
	
#---------func de tilemap-----------
func local_to_map(valor : Vector2) -> Vector2:
	return tile_map_hud.local_to_map(valor)
	
func map_to_local(valor : Vector2) -> Vector2:
	return tile_map_hud.map_to_local(valor)
#---------func de tilemap-----------
func limpiar_tiles_movimiento(tiles : Dictionary) -> void: #Limpia el tilemap de los tile de movimiento
	for i in tiles:
		tile_map_hud.set_cell(i, 1, Vector2i(0,0), 0)
func dibujar_tiles_de_ataque(tiles: Dictionary) -> void:
	for i in tiles:
		tile_map_hud.set_cell(i, 2, Vector2i(0,0), 0)
