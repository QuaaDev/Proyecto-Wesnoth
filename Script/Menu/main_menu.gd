extends Control
@onready var nueva: Button = $CenterContainer/VBoxContainer/Nueva
@onready var cargar: Button = $CenterContainer/VBoxContainer/Cargar
@onready var opciones: Button = $CenterContainer/VBoxContainer/Opciones
@onready var salir: Button = $CenterContainer/VBoxContainer/Salir



func salir_presionado() -> void:
	print("Salir")
	get_tree().quit()


func opciones_presionado() -> void:
	print("Opciones")


func cargar_presionado() -> void:
	print("Cargar")


func nueva_partida_presionado() -> void:
	print("Nueva partida")
	var mundo = load("uid://bpkd4wjvywj2s") #Agrega mundo a la escena
	var mundo_instanciado : Mundo = mundo.instantiate()
	var nivel = load("uid://djjjanofavthr")#Agrega el nivel a la escena
	var nivel_instanciado : Nivel = nivel.instantiate()
	mundo_instanciado.add_child(nivel_instanciado)#Agrega el nivel a mundo
	mundo_instanciado.tile_map = nivel_instanciado#Le agrega una referencia del nivel
	
	get_parent().add_child(mundo_instanciado)
	self.visible = false #Desactiva el menu para evitar errores
	
	
