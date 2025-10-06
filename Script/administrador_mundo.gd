extends Node
var mouse_sobre_unidad : Node2D
var unidad_a_mover : Node2D
@onready var tile_map: Node2D = $TileMap


func obtener_unidad_bajo_mouse(unidad : Node2D) -> void: #Almacena referencia a la unidad bajo el mouse
	mouse_sobre_unidad = unidad
	#print("entro")
func limpiar_unidad_bajo_mouse() -> void:
	mouse_sobre_unidad = null
	#print("salgo")
func _input(event):
	if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT: #Si se apreta el mouse izq
				if event.pressed:
					if mouse_sobre_unidad != null and unidad_a_mover == null:
						unidad_a_mover = mouse_sobre_unidad
						print("Almaceno unidad")
					elif mouse_sobre_unidad != unidad_a_mover and unidad_a_mover != null:
						print("muevo unidad")
						mover_unidad(unidad_a_mover)
						unidad_a_mover = null
					elif mouse_sobre_unidad != null and mouse_sobre_unidad == unidad_a_mover:
						print("Cancelo movimiento")
						unidad_a_mover = null
					else:
						print("Click Izquierdo condicion no reconocida, valores: ")
func mover_unidad(unidad : Node2D):
	var coordenadas_mouse = tile_map.coordenada_global_del_mouse_a_tilemap()
	var nueva_posicion_unidad = tile_map.map_to_local(coordenadas_mouse)
	unidad.position = nueva_posicion_unidad
