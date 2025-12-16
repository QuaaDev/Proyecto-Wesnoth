extends Button

signal presionado_con_origen(origen : Button) 
#Envia una señal cuando se presiona el boton incluyendo el origen de la señal como argumento
#---------Seccion Aliado---------------
@onready var png_aliado: TextureRect = $PanelContainer/HBoxContainer/PanelAliado/HBoxContainer/PNG
@onready var label_nombre_ataque_aliado: Label = $PanelContainer/HBoxContainer/PanelAliado/HBoxContainer/Stats/NombreAtaque
@onready var label_tipo_daño_aliado: Label = $PanelContainer/HBoxContainer/PanelAliado/HBoxContainer/Stats/TipoDaño
@onready var label_cantidad_daño_aliado: Label = $PanelContainer/HBoxContainer/PanelAliado/HBoxContainer/Stats/CantidadDaño
@onready var label_cantidad_ataques_aliado: Label = $PanelContainer/HBoxContainer/PanelAliado/HBoxContainer/Stats/CantidadAtaques
#---------Seccion Aliado---------------
#--------------Seccion Enemigo--------------
@onready var png_enemigo: TextureRect = $PanelContainer/HBoxContainer/PanelEnemigo/HBoxContainer/PNG
@onready var label_nombre_ataque_enemigo: Label = $PanelContainer/HBoxContainer/PanelEnemigo/HBoxContainer/Stats/NombreAtaque
@onready var label_tipo_daño_enemigo: Label = $PanelContainer/HBoxContainer/PanelEnemigo/HBoxContainer/Stats/TipoDaño
@onready var label_cantidad_daño_enemigo: Label = $PanelContainer/HBoxContainer/PanelEnemigo/HBoxContainer/Stats/CantidadDaño
@onready var label_cantidad_ataques_enemigo: Label = $PanelContainer/HBoxContainer/PanelEnemigo/HBoxContainer/Stats/CantidadAtaques
#--------------Seccion Enemigo--------------
#-------------Seccion mitad-----------------
@onready var modo_combate: Label = $PanelContainer/HBoxContainer/PanelMitad/modo_combate

func constructor_estadisticas(nombre_ataque : String, tipo_daño : int, cantidad_daño : int,cantidad_ataques : int, ruta_png : String, equipo : bool):
	#png_path usa el UID del recurso, luego se le asigna con load()
	if equipo: #If es aliado:
		label_nombre_ataque_aliado.text = nombre_ataque
		label_tipo_daño_aliado.text = str(tipo_daño)
		label_cantidad_daño_aliado.text = "daño " + str(cantidad_daño)
		label_cantidad_ataques_aliado.text = "cantidad " + str(cantidad_ataques)
		png_aliado.texture = load(ruta_png)
	else:
		label_nombre_ataque_enemigo.text = nombre_ataque
		label_tipo_daño_enemigo.text = str(tipo_daño)
		label_cantidad_daño_enemigo.text = "daño "+str(cantidad_daño)
		label_cantidad_ataques_enemigo.text = "cantidad "+str(cantidad_ataques)
		png_enemigo.texture = load(ruta_png)
		
func constructor_panel_medio(texto : String):
	modo_combate.text = texto

func _ready() -> void:
	#constructor_estadisticas("uid://bksfnvk2kclfb","x","x",0,0,true)
	#constructor_estadisticas("uid://c26runelcofr0","x","x",0,0,false)
	pass

#------------señales---------------


func _on_pressed() -> void:
	presionado_con_origen.emit(self)
