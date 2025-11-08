extends Control
@onready var v_box_combate: VBoxContainer = $VBoxCombate
const COLOR_RECT_EJEMPLO = preload("uid://c06dt336pm34x")
@onready var fondo_ui_combate: TextureRect = $FondoUiCombate
@onready var atacar_button: Button = $AtacarButton
@onready var cancelar_button: Button = $CancelarButton


func _ready() -> void:
	prueba()
	prueba()
	prueba()
	recalcular_tamaño()
	
func prueba():
	var nuevo_rect = COLOR_RECT_EJEMPLO.instantiate()
	nuevo_rect.custom_minimum_size = Vector2(500,120)
	v_box_combate.add_child(nuevo_rect)
	

func recalcular_tamaño():
	var tamaño_base_fondo_altura = 480
	fondo_ui_combate.custom_minimum_size.y = tamaño_base_fondo_altura + (v_box_combate.get_child_count() * 120)
