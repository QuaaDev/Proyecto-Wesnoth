extends Control
@onready var nueva: Button = $CenterContainer/VBoxContainer/Nueva
@onready var cargar: Button = $CenterContainer/VBoxContainer/Cargar
@onready var opciones: Button = $CenterContainer/VBoxContainer/Opciones
@onready var salir: Button = $CenterContainer/VBoxContainer/Salir



func salir_presionado() -> void:
	print("Salir")


func opciones_presionado() -> void:
	print("Opciones")


func cargar_presionado() -> void:
	print("Cargar")


func nueva_partida_presionado() -> void:
	print("Nueva partida")
