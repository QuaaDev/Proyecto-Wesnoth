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
						#If el mouse esta sobre una unidad AND no hay unidad para mover:
						#Se selecciona la unidad a interactuar
						unidad_a_mover = mouse_sobre_unidad
						unidad_a_mover.siendo_movido()
						print("Almaceno unidad")
					elif mouse_sobre_unidad != unidad_a_mover and unidad_a_mover != null and verificar_si_coordenadas_estan_libres():
						#If La unidad a mover es diferente a la unidad que esta debajo del mouse AND unidad a mover tiene algun valor AND las coordenadas estan libres:
						#Se selecciona la casilla a moverse
						print("muevo unidad a espacio vacio")
						unidad_a_mover.ya_no_me_mueven()
						mover_unidad(unidad_a_mover)
						unidad_a_mover = null
					elif mouse_sobre_unidad != unidad_a_mover and unidad_a_mover != null and !verificar_si_coordenadas_estan_libres():
						#If La unidad a mover es diferente a la unidad que esta debajo del mouse AND unidad a mover tiene algun valor AND las coordenadas estan ocupadas:
						if verificar_si_son_aliados():
							#Si son aliados, no ataca
							print("Son aliadas las unidades, no puedes mover aqui")
						else:
							#Si son enemigos, lo ataca >:)
							ubicaciones_ocupadas[mouse_sobre_unidad.get_coordenada_local_tilemap()].morir()
							ubicaciones_ocupadas.erase(mouse_sobre_unidad) #Elimina la unidad que esta sobre el mouse
							mover_unidad(unidad_a_mover)
						pass
					elif mouse_sobre_unidad != null and mouse_sobre_unidad == unidad_a_mover:
						#If el mouse esta arriba de una unidad AND la unidad es la propia unidad que se mueve:
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
	unidad.position = nueva_posicion_unidad #Mueve a la unidad
	
	print(ubicaciones_ocupadas)
	#--------actualiza la posicion de la unidad----------
func verificar_si_son_aliados() -> bool:
	#Si son aliados devuelve true
	if mouse_sobre_unidad.equipo == unidad_a_mover.equipo:
		return true
	else: 
		return false
	
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
