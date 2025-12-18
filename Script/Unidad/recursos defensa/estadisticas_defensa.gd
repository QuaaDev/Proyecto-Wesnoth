extends Node
class_name estadisticas_defensa

@export var informacion_defensa : EstadisticaDefensaRes

func _ready() -> void:
	for i in informacion_defensa.get_property_list():
		if i.usage & PROPERTY_USAGE_SCRIPT_VARIABLE:
			print(i.name+ str(informacion_defensa.get(i.name)))
