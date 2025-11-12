extends Button
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
