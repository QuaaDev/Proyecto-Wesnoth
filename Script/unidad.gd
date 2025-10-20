extends Node2D
@onready var nodo_mundo = self.get_parent()
@onready var tile_map: Node2D = $"../TileMap"
var coordenada_local_tilemap : Vector2 #La coordenada local del tilemap
var es_mi_turno : bool = false
@export var puntos_movimiento_maximo = 2 #Cantidad maxima de movimientos por turno
var puntos_movimiento : int #Cantidad de movimientos en ejecucion
@export var equipo : int = 0

func _ready() -> void:
	self.add_to_group(str(equipo))
	#print(self.get_groups())
	actualizar_coordenada_local_tilemap()
	var coordenada_global = tile_map.map_to_local(coordenada_local_tilemap)
	self.position = coordenada_global #Centra a la unidad en la celda
	#Terminar esto luego, el codigo no funciona prq el nodo "tilemap" es un node2d, no un nodo XD

func morir():
	nodo_mundo.ubicaciones_ocupadas.erase(coordenada_local_tilemap) #Libera su posicion del mundo
	self.queue_free()

func actualizar_coordenada_local_tilemap() -> void: #Actualiza la variable coordenada_local_tilemap
	coordenada_local_tilemap = tile_map.local_to_map(position)#Posicion local del tilemap
	
func siendo_movido() -> void:
	self.modulate = Color(18.892, 0.0, 0.0, 0.448)
	
func ya_no_me_mueven() -> void:
	self.modulate = Color(1.0, 1.0, 1.0, 1.0)
	
func termino_mi_turno() -> void:
	es_mi_turno = false

func empezo_mi_turno() -> void:
	puntos_movimiento = puntos_movimiento_maximo
	es_mi_turno = true

func restar_puntos_movimiento(cantidad : int) -> void: #Resta la cantidad de movimientos dispomible
	puntos_movimiento -= cantidad
	
func _on_area_2d_mouse_entered() -> void: #Actualiza la informacion de administrador mundo para informarle de que esta unidad esta bajo el mouse
	nodo_mundo.obtener_unidad_bajo_mouse(self)


func _on_area_2d_mouse_exited() -> void:
	#Actualiza la informacion de administrador mundo para informarle de que esta unidad ya no esta bajo el mouse
	if nodo_mundo.mouse_sobre_unidad == self:
		#Si el actual foco lo tiene otra unidad, no aplica el exited
		nodo_mundo.limpiar_unidad_bajo_mouse()
	else:
		#print("Que atrevimiento aplicar exited cuando no soy yo el foco che")
		pass

func get_coordenada_local_tilemap() -> Vector2:
	return coordenada_local_tilemap
