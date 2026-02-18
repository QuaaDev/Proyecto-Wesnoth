extends Node2D
class_name unidad_base
signal animacion_terminada_combate #Conectada a algoritmo_combate

#region parametros esenciales
@onready var nodo_mundo = self.get_parent()
@onready var tile_map: Node2D = $"../TileMap"
@onready var sprite: Sprite2D = $sprite
var ejecutar_animacion_muerte = false
var coordenada_local_tilemap : Vector2 #La coordenada local del tilemap
var es_mi_turno : bool = false
var objetivos_a_atacar : Dictionary #Almacena los posibles objetivos que puede atacar
var objetivo_final : Array#Almacena el objetivo al que le ejecutara el ataque >:D
var tween : Tween
#endregion

@export var puntos_movimiento_maximo : int #Cantidad maxima de movimientos por turno
var puntos_movimiento : int #Cantidad de movimientos en ejecucion
@export var equipo : int

@export var turnos_de_ataque_maximo : int #Cantidad de acciones maximas de ataque en un turno
var turnos_de_ataque_actual : int

@export var vida_maxima : int
var vida_actual : int

@export var sprite_unidad_UID : String

@export var area2d : Area2D
#------Barra de vida--------
@export var barra_de_vida : ProgressBar
var cambio_a_barra_de_vida : float #Almacena la cantidad de valor a restarle a la barra
var vida_perdida_por_frame : float = 0.05 #Velocidad a la que la barra de vida baja su valor
var vida_perdida_por_frame_muerte : float#Lo mismo que la anterior variable pero en casos de muerte
var vida_alta : Color = Color(0.0, 0.714, 0.0, 1.0)
var vida_media : Color = Color(0.616, 0.569, 0.0, 1.0)
var vida_baja : Color = Color(0.774, 0.0, 0.0, 1.0)
var franjas_de_vida : Array #Almacena los limites de franjas para cambiar los colores| 50% media 25% baja
var actual_franja_de_vida : int = 3#Cada vez que se baja una franja, cambia el color
#------Barra de vida--------
#-----------Informacion combate---------------------
var opciones_de_combate = {}
#	(png_path : String, nombre_ataque : String, tipo_daño : String,
	#cantidad_daño : int, cantidad_ataques : int, equipo : bool):


func instanciar_cosas_esenciales():
	area2d.mouse_entered.connect(_on_area_2d_mouse_entered)
	area2d.mouse_exited.connect(_on_area_2d_mouse_exited)
	if barra_de_vida == null: #Verifica si hay una barra de vida asignada
		push_error("Error unidad no tiene barra de vida " + self.name)
	else:
		barra_de_vida.max_value = vida_maxima
		barra_de_vida.value = vida_actual
		vida_perdida_por_frame_muerte = vida_maxima*0.02 #Pierde el 2% de la vida por frame
		barra_de_vida.get("theme_override_styles/fill").bg_color = vida_alta 
		franjas_de_vida.append(barra_de_vida.max_value * 0.5)
		franjas_de_vida.append(barra_de_vida.max_value * 0.25)
func _process(_delta: float) -> void:
	if ejecutar_animacion_muerte:
		animacion_morir()
	if cambio_a_barra_de_vida > 0: #Si hay que actualizar la barra de vida
		if !ejecutar_animacion_muerte:#Verifica si la unidad va a morir para cambiar la velocidad de la animacion
			barra_de_vida.value -= vida_perdida_por_frame #Actualiza con el valor por frame
			cambio_a_barra_de_vida -= vida_perdida_por_frame#Actualiza el valor de daño que falta aplicar
		else:
			barra_de_vida.value -= vida_perdida_por_frame_muerte
			cambio_a_barra_de_vida -= vida_perdida_por_frame_muerte
		if !franjas_de_vida.is_empty():#Si no existe mas franjas evita entrar por errores
			if barra_de_vida.value < franjas_de_vida[0]:#Si se puede cambiar la franja de vida
				actual_franja_de_vida -= 1#Cambia la franja de vida
				franjas_de_vida.remove_at(0)#Borra la franja obsoleta
				match  actual_franja_de_vida:#Y cambia el color segun el caso correspondiente
					3:
						barra_de_vida.get("theme_override_styles/fill").bg_color = vida_alta 
					2:
						barra_de_vida.get("theme_override_styles/fill").bg_color = vida_media
					1:
						barra_de_vida.get("theme_override_styles/fill").bg_color = vida_baja
					_:
						push_error("Ninguna franja de linea coincide con el valor actual")
				
	
		
func _ready() -> void:
	vida_actual = vida_maxima
	instanciar_cosas_esenciales() #<<<------ inicia los nodos hijos de sprite, area2d y etc.
	self.add_to_group(str(equipo))
	nodo_mundo.verificar_cantidad_grupos(equipo) 
	#Le envia su grupo a mundo para verificar si su grupo esta registrado en mundo
	#print(self.get_groups())
	actualizar_coordenada_local_tilemap()
	var coordenada_global = tile_map.map_to_local(coordenada_local_tilemap)
	self.position = coordenada_global #Centra a la unidad en la celda
	sprite.texture = load(sprite_unidad_UID)
	sprite.cambiar_color(equipo) #recolorización por máscara de color
	#print(opciones_de_combate)

func morir():
	nodo_mundo.ubicaciones_ocupadas.erase(coordenada_local_tilemap) #Libera su posicion del mundo
	activar_animacion_morir()
	await get_tree().create_timer(2.0).timeout
	self.queue_free()
	
func animacion_morir():
	self.modulate += Color(0, 0, 0, -0.008)
	#Va restando opacidad a la unidad en cada FPS
	pass
func activar_animacion_morir():
	ejecutar_animacion_muerte = true
func consulta_si_estoy_muerto() -> bool: #Recurso para algoritmo combate
	if ejecutar_animacion_muerte == true:
		return true
	else: 
		return false
func infligir_daño():
	puntos_movimiento = 0 #Evita que la unidad se mueva luego de atacar
	turnos_de_ataque_actual -= 1#Gasta un turno de ataque
	
func recibir_daño(cantidad : int) -> void:
	vida_actual -= cantidad
	cambio_a_barra_de_vida = float(cantidad)
	if vida_actual <= 0:
		morir()

func aplicando_animacion_movimiento(camino_a_seguir : Array) -> void:
	if tween and tween.is_running():#Si ya hay una animacion corriendo, espera a que termine
		await tween.finished
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	for i in camino_a_seguir:
		var new_position = tile_map.map_to_local(i)
		tween.tween_property(self,"position",new_position, .5)

func aplicar_animacion_combate(coordenadas : Vector2) -> void:
	if tween and tween.is_running(): #Si ya hay una animacion corriendo, espera a que termine
		await tween.finished
	tween = create_tween() #Crea un nuevo tween desde cero
	var cantidad_pixeles = 36 #Cantidad de pixeles a moverse
	var posicion_original = self.position #Posicion para volver al terminar la animacion
	var posicion_objetivo : Vector2 #Posicion a la que ira
	var posicion_es_par : bool
	var coordenadas_arregladas : Vector2
#region Correccion de coordenadas
#Se tratan casos aislados, aca se arreglan para que la animacion sea correcta
	if int(coordenada_local_tilemap.x) % 2 == 0:
		posicion_es_par = true
	else:
		posicion_es_par = false
	if posicion_es_par: #Si es par
		if coordenadas == Vector2(-1,0):
			coordenadas_arregladas = Vector2(-1,1)
		elif coordenadas == Vector2(1,0):
			coordenadas_arregladas = Vector2(1,1)
		else:
			coordenadas_arregladas = coordenadas
	else:#Si es impar
		if coordenadas == Vector2(1,0):
			coordenadas_arregladas = Vector2(1,-1)
		elif coordenadas == Vector2(-1,0):
			coordenadas_arregladas = Vector2(-1,-1)
		else:
			coordenadas_arregladas = coordenadas
#endregion
	var coordenadas_globales = Vector2(cantidad_pixeles * coordenadas_arregladas.x, cantidad_pixeles * coordenadas_arregladas.y)
	#Convierte las coordenadas del tilemap a coordenadas en pixeles
	#Contiene la cantidad de pixeles a moverse, no las coordenadas objetivo
	posicion_objetivo = posicion_original + coordenadas_globales 
	#Suma la posicion actual con la cantidad de pixeles que necesita para moverse
	tween.tween_property(self,"position",posicion_objetivo, .4)
	#Primero va a la posicion del enemigo
	tween.tween_property(self,"position",posicion_original, .4)
	#Al terminar, vuelve a su posicion original
	await tween.finished
	animacion_terminada_combate.emit()
	#Cuando toda la animacion termina, emite la señal para que algoritmo_combate se siga ejecutando

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
	
func limpiar_objetivos_ataque() -> void:
	objetivos_a_atacar.clear()
	objetivo_final.clear()
	
	
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
