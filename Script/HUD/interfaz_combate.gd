extends Control
@onready var v_box_combate: VBoxContainer = $FondoUiCombate/PanelCombate/ScrollContainer/VBoxContainer
const OPCION_COMBATE = preload("uid://dv866k7yhc510")
@onready var fondo_ui_combate: TextureRect = $FondoUiCombate
@onready var atacar_button: Button = $FondoUiCombate/AtacarButton
@onready var cancelar_button: Button = $FondoUiCombate/CancelarButton

@onready var v_box_enemigo_perfil: VBoxContainer = $FondoUiCombate/PanelPerfil/HBoxContainer2/HBoxContainer/VBoxEnemigoPerfil
@onready var v_box_aliado_perfil: VBoxContainer = $FondoUiCombate/PanelPerfil/HBoxContainer2/HBoxContainer/VBoxAliadoPerfil

var opcion_elegida #Almacena la opcion elegida para ejecutar el combate

func _ready() -> void:
	pass
	
func prueba():
	var nuevo_rect = OPCION_COMBATE.instantiate()
	nuevo_rect.custom_minimum_size = Vector2(500,120) #<--- tamaño minimo
	v_box_combate.add_child(nuevo_rect)



func iniciar_combate(unidad_aliada : Node2D, unidad_enemiga : Node2D):
	editar_labels(unidad_aliada,v_box_aliado_perfil)
	editar_labels(unidad_enemiga, v_box_enemigo_perfil)
	var ejemplo_ataque_enemigo = unidad_enemiga.get_node("EstadisticasAtaque").get_child(0)
	var defensa_aliada = unidad_aliada.get_node("estadisticas_defensa")
	var defensa_enemiga = unidad_enemiga.get_node("estadisticas_defensa")
	#Variable temporal hasta tener una IA que eliga el ataque mas eficiente
	for i in unidad_aliada.get_node("EstadisticasAtaque").get_children(): 
		#Obtiene todos los hijos de estadisticasataque
		var nuevo_panel_combate = OPCION_COMBATE.instantiate() 
		v_box_combate.add_child(nuevo_panel_combate)
		nuevo_panel_combate.custom_minimum_size = Vector2(500,120)
		nuevo_panel_combate.constructor_estadisticas(i, ejemplo_ataque_enemigo, defensa_aliada, defensa_enemiga)
		#constructor_estadisticas
		nuevo_panel_combate.presionado_con_origen.connect(panel_presionado) 
		#Conecta la señal para detectar el pressed + origen de la señal
		
func editar_labels(unidad : Node2D, box_objetivo : VBoxContainer):
	box_objetivo.set_nombre(unidad.name)
	box_objetivo.set_identificador("No tienen identificador")
	box_objetivo.set_nivel("No tienen nivel")
	box_objetivo.set_vida(str(unidad.vida_actual) + "/" + str(unidad.vida_maxima))
	box_objetivo.set_moral("No tienen moral")
	box_objetivo.set_experiencia("No tienen experiencia")
	box_objetivo.set_equipo("Equipo: " + str(unidad.equipo))

func limpiar_labels(box_objetivo : VBoxContainer): #Resetea los labels
	box_objetivo.set_nombre("null")
	box_objetivo.set_identificador("null")
	box_objetivo.set_nivel("null")
	box_objetivo.set_vida("null")
	box_objetivo.set_moral("null")
	box_objetivo.set_experiencia("null")
	box_objetivo.set_equipo("null")
	
func limpiar_panel_combate():#Limpia todas las opciones de combate del panel combate
	for i in v_box_combate.get_children():
		i.queue_free()
		
		

#-----------Señales------------

func boton_atacar_presionado() -> void:
	if opcion_elegida == null:
		print("Elige una opcion de combate")
	else:
		self.visible = false
		opcion_elegida = null
		limpiar_labels(v_box_aliado_perfil)
		limpiar_labels(v_box_enemigo_perfil)
		limpiar_panel_combate()
		print("Ejecutando ataque")

func boton_cancelar_presionado() -> void:
	print("UI CANCELAR PELEA!")
	opcion_elegida = null
	self.visible = false
	limpiar_labels(v_box_aliado_perfil)
	limpiar_labels(v_box_enemigo_perfil)
	limpiar_panel_combate()

func panel_presionado(origen : Button):
	opcion_elegida = origen
	print(origen.name)
