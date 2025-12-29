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
#-----------Indices del origen del ataque---------------
var ataque_index_aliado 
var ataque_index_enemigo

func constructor_estadisticas(aliado : OpcionAtaque, enemigo : OpcionAtaque, defensa_aliada : estadisticas_defensa, defensa_enemiga : estadisticas_defensa):
	var recurso_aliado = aliado.opcion_ataque_res
	var recurso_enemigo = enemigo.opcion_ataque_res
	#png_path usa el UID del recurso, luego se le asigna con load()
	#-------Seccion Aliado---------------
	label_nombre_ataque_aliado.text = recurso_aliado.nombre_ataque
	label_tipo_daño_aliado.text = str(recurso_aliado.tipo_daño)
	label_cantidad_daño_aliado.text = "daño " + str(AlgoritmoCombate.calcular_daño_total(recurso_aliado.cantidad_daño, recurso_aliado.tipo_daño, defensa_enemiga))
	#calcular_daño_total(cantidad_daño : int, tipo_daño : int, armadura_objetivo : estadisticas_defensa)
	#label_cantidad_daño_aliado.text = "daño" + str(recurso_aliado.cantidad_daño)
	label_cantidad_ataques_aliado.text = "cantidad " + str(recurso_aliado.cantidad_ataques)
	png_aliado.texture = load(recurso_aliado.ruta_png)
	ataque_index_aliado = aliado.get_index()
	#print(ataque_index_aliado)
	
	#----------------Seccion Enemigo-----------------
	label_nombre_ataque_enemigo.text = recurso_enemigo.nombre_ataque
	label_tipo_daño_enemigo.text = str(recurso_enemigo.tipo_daño)
	label_cantidad_daño_enemigo.text = "daño "+str(recurso_enemigo.cantidad_daño)
	label_cantidad_ataques_enemigo.text = "cantidad "+str(recurso_enemigo.cantidad_ataques)
	png_enemigo.texture = load(recurso_enemigo.ruta_png)
	ataque_index_enemigo = enemigo.get_index()
	#print(str(ataque_index_enemigo)+"index enemigo")
#nuevo_panel_combate.constructor_estadisticas(opcion_ataque.nombre_ataque,opcion_ataque.tipo_daño,opcion_ataque.cantidad_daño,
#opcion_ataque.cantidad_ataques,opcion_ataque.ruta_png,true)
func constructor_panel_medio(texto : String):
	modo_combate.text = texto

func _ready() -> void:
	#constructor_estadisticas("uid://bksfnvk2kclfb","x","x",0,0,true)
	#constructor_estadisticas("uid://c26runelcofr0","x","x",0,0,false)
	pass

#------------señales---------------


func _on_pressed() -> void:
	presionado_con_origen.emit(self)
