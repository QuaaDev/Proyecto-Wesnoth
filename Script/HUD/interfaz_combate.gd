extends Control
@onready var v_box_combate: VBoxContainer = $FondoUiCombate/PanelCombate/ScrollContainer/VBoxContainer
const OPCION_COMBATE = preload("uid://dv866k7yhc510")
@onready var fondo_ui_combate: TextureRect = $FondoUiCombate
@onready var atacar_button: Button = $FondoUiCombate/AtacarButton
@onready var cancelar_button: Button = $FondoUiCombate/CancelarButton



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
	

func recalcular_tamaño():
	var tamaño_base_fondo_altura = 480
	fondo_ui_combate.custom_minimum_size.y = tamaño_base_fondo_altura + (v_box_combate.get_child_count() * 120)

func iniciar_combate(unidad_aliada : Node2D, unidad_enemiga : Node2D):
	pass
