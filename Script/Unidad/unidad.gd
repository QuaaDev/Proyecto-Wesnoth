extends Node2D
@onready var nodo_mundo = self.get_parent()
@onready var tile_map: Node2D = $"../TileMap"
var coordenada_local_tilemap : Vector2 #La coordenada local del tilemap
var es_mi_turno : bool = false
@export var puntos_movimiento_maximo = 2 #Cantidad maxima de movimientos por turno
var puntos_movimiento : int #Cantidad de movimientos en ejecucion
@export var equipo : int = 0

@export var turnos_de_ataque_maximo : int = 1 #Cantidad de acciones maximas de ataque en un turno
var turnos_de_ataque_actual : int

@export var vida_maxima : int = 10
var vida_actual : int

@export var daño : int = 5
#-----------Informacion combate---------------------
var opciones_de_combate = {}
#	(png_path : String, nombre_ataque : String, tipo_daño : String,
	#cantidad_daño : int, cantidad_ataques : int, equipo : bool):




func _ready() -> void:
	var stats_combate = ["uid://c47aehovk22mn","Espada de satan","Fogo",10,1]
	opciones_de_combate[0] = stats_combate
	stats_combate = ["uid://c47aehovk22mn","Espada deCRISTO","awa",11,1]
	opciones_de_combate[1] = stats_combate
	#nombre ataque,tipo daño, cantidad daño, cantidad ataques, ruta png
	self.add_to_group(str(equipo))
	#print(self.get_groups())
	actualizar_coordenada_local_tilemap()
	var coordenada_global = tile_map.map_to_local(coordenada_local_tilemap)
	self.position = coordenada_global #Centra a la unidad en la celda
	vida_actual = vida_maxima
	print(opciones_de_combate)

func morir():
	nodo_mundo.ubicaciones_ocupadas.erase(coordenada_local_tilemap) #Libera su posicion del mundo
	self.queue_free()

func infligir_daño() -> int:
	puntos_movimiento = 0 #Evita que la unidad se mueva luego de atacar
	turnos_de_ataque_actual -= 1#Gasta un turno de ataque
	return daño
	
func recibir_daño(cantidad : int) -> void:
	vida_actual -= cantidad
	if vida_actual <= 0:
		morir()

func actualizar_coordenada_local_tilemap() -> void: #Actualiza la variable coordenada_local_tilemap
	coordenada_local_tilemap = tile_map.local_to_map(position)#Posicion local del tilemap
	
func siendo_movido() -> void:
	self.modulate = Color(18.892, 0.0, 0.0, 0.448)
	
func ya_no_me_mueven() -> void:
	self.modulate = Color(1.0, 1.0, 1.0, 1.0)
	
func termino_mi_turno() -> void:
	es_mi_turno = false

func empezo_mi_turno() -> void:
	#Reseteas estadisticas y activa el turno
	puntos_movimiento = puntos_movimiento_maximo
	turnos_de_ataque_actual = turnos_de_ataque_maximo
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
