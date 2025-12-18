extends Node
class_name estadisticas_defensa

@export var informacion_defensa : EstadisticaDefensaRes

func _ready() -> void:
	pass

func obtener_estadisticas_defensa() -> Dictionary:
	var index_y_valor = {} #prepara el diccionario
	var contador : int = 0 #contador para hacer el indice del diccionario
	for i in informacion_defensa.get_property_list():
		if i.usage & PROPERTY_USAGE_SCRIPT_VARIABLE: #explora las variables personalizadas
			index_y_valor[contador] = informacion_defensa.get(i.name)#las agrega al diccionario con su indice
			contador += 1
	return index_y_valor

func debug_estadisticas_defensa(): #Funcionalidad de debug, para detectar facilmente indices
	var contador = 0
	for i in informacion_defensa.get_property_list(): #Obtiene todas las propiedades de X
		if i.usage & PROPERTY_USAGE_SCRIPT_VARIABLE:
			#PROPERTY_USAGE_SCRIPT_VARIABLE elimina las variables integradas del motor
			#y solo deja las personalizadas(las que hice yo)
			#i.usage no se que hace, es algo que filtra diferentes variables pero idk
			print("indice "+str(contador)+i.name+ str(informacion_defensa.get(i.name)))
			contador += 1
