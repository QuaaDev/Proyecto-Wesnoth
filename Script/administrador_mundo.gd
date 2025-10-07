extends Node
var mouse_sobre_unidad : Node2D
var unidad_a_mover : Node2D
@onready var tile_map: Node2D = $TileMap
var ubicaciones_ocupadas = {} #Diccionario que almacena las ubicaciones ocupadas junto a sus unidades

func _ready() -> void:
	for i in get_children():
		if i.name.contains("Unidad"):
			ubicaciones_ocupadas[i.coordenada_local_tilemap] = i
	print(ubicaciones_ocupadas)


func _input(event):
	if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT: #Si se apreta el mouse izq
				if event.pressed:
					if mouse_sobre_unidad != null and unidad_a_mover == null:
						#Se selecciona la unidad a interactuar
						unidad_a_mover = mouse_sobre_unidad
						unidad_a_mover.siendo_movido()
						print("Almaceno unidad")
					elif mouse_sobre_unidad != unidad_a_mover and unidad_a_mover != null and verificar_si_coordenadas_estan_libres():
						#Se selecciona la casilla a moverse
						print("muevo unidad")
						unidad_a_mover.ya_no_me_mueven()
						mover_unidad(unidad_a_mover)
						unidad_a_mover = null
					elif mouse_sobre_unidad != null and mouse_sobre_unidad == unidad_a_mover:
						#Se cancela el movimiento
						print("Cancelo movimiento")
						unidad_a_mover.ya_no_me_mueven()
						unidad_a_mover = null
					else:
						#Error
						print("Click Izquierdo condicion no reconocida, valores: ")
						
func mover_unidad(unidad : Node2D):
	var coordenadas_mouse = tile_map.coordenada_global_del_mouse_a_tilemap()
	var nueva_posicion_unidad = tile_map.map_to_local(coordenadas_mouse)
	ubicaciones_ocupadas.erase(unidad.get_coordenada_local_tilemap()) #Borra su anterior posicion ocupada del diccionario
	unidad.coordenada_local_tilemap = coordenadas_mouse #Actualiza la informacion q tiene la unidad
	ubicaciones_ocupadas[unidad.coordenada_local_tilemap] = unidad #Actualiza la informacion del diccionario
	unidad.position = nueva_posicion_unidad
	
	print(ubicaciones_ocupadas)
	#--------actualiza la posicion de la unidad----------
	
	
func verificar_si_coordenadas_estan_libres() -> bool:
	var coordenadas_mouse = tile_map.coordenada_global_del_mouse_a_tilemap() #Coordenada del tilemap
	if ubicaciones_ocupadas.has(coordenadas_mouse): #Verifica si la ubicacion esta dentro del diccionario
		print("Posicion ocupada por " + ubicaciones_ocupadas[coordenadas_mouse].name)
		return false
	else:
		print("Devuelvo true")
		return true
	
func obtener_unidad_bajo_mouse(unidad : Node2D) -> void: #Almacena referencia a la unidad bajo el mouse
	mouse_sobre_unidad = unidad
	#print("entro")
func limpiar_unidad_bajo_mouse() -> void:
	mouse_sobre_unidad = null
	#print("salgo")
