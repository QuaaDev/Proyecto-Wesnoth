extends Control
@onready var v_box_combate: VBoxContainer = $FondoUiCombate/PanelCombate/ScrollContainer/VBoxContainer
const OPCION_COMBATE = preload("uid://dv866k7yhc510")
@onready var fondo_ui_combate: TextureRect = $FondoUiCombate
@onready var atacar_button: Button = $FondoUiCombate/AtacarButton
@onready var cancelar_button: Button = $FondoUiCombate/CancelarButton

@onready var v_box_enemigo_perfil: VBoxContainer = $FondoUiCombate/PanelPerfil/HBoxContainer2/HBoxContainer/VBoxEnemigoPerfil
@onready var v_box_aliado_perfil: VBoxContainer = $FondoUiCombate/PanelPerfil/HBoxContainer2/HBoxContainer/VBoxAliadoPerfil


func _ready() -> void:
	prueba()
	prueba()
	prueba()
	prueba()
	prueba()
	
func prueba():
	var nuevo_rect = OPCION_COMBATE.instantiate()
	nuevo_rect.custom_minimum_size = Vector2(500,120)
	v_box_combate.add_child(nuevo_rect)
	

func iniciar_combate(unidad_aliada : Node2D, unidad_enemiga : Node2D):
	editar_labels(unidad_aliada,v_box_aliado_perfil)
	editar_labels(unidad_enemiga, v_box_enemigo_perfil)

func editar_labels(unidad : Node2D, box_objetivo : VBoxContainer):
	
	box_objetivo.set_nombre(unidad.name)
	box_objetivo.set_identificador("No tienen identificador")
	box_objetivo.set_nivel("No tienen nivel")
	box_objetivo.set_vida(str(unidad.vida_actual) + "/" + str(unidad.vida_maxima))
	box_objetivo.set_moral("No tienen moral")
	box_objetivo.set_experiencia("No tienen experiencia")
	box_objetivo.set_equipo("Equipo: " + str(unidad.equipo))
	
