extends VBoxContainer

@onready var nombre: Label = $Nombre
@onready var identificador: Label = $Identificador
@onready var nivel: Label = $Nivel
@onready var vida: Label = $Vida
@onready var moral: Label = $Moral
@onready var experiencia: Label = $Experiencia
@onready var equipo: Label = $Equipo

var texto_test = "identificador_unidad" #Texto que se aplicara al label
func _ready() -> void:
	pass
func salto_de_linea_texto(texto : String) -> String:
	var text_to_print = "" #Variable temporal que almacena el texto del label
	var x = 1#Contador de ejecuciones
	var quantity_of_letters = 22#Cada cuantas letras se agrega salto de linea
	for i in range(1,ceil(float((float(texto.length()))/quantity_of_letters)+1)):
		#Cada 22 caracteres, hace un bucle (empezando siempre por 1)
		text_to_print = text_to_print + (texto.substr((x-1)*quantity_of_letters,quantity_of_letters) + "\n")
		#Substrae X cantidad de letras apartir del caracter numero (ejecuciones-1)* cada cuantas letras hace salto de linea
		x += 1
	text_to_print = text_to_print.rstrip("\n") #Elimina el salto de linea sobrante
	#identificador.text = text_to_print#Remplaza el texto del label
	return text_to_print
	
#-----------set texto--------------
func set_nombre(texto : String):
	nombre.text = salto_de_linea_texto(texto)
	
func set_identificador(texto : String):
	identificador.text = salto_de_linea_texto(texto)
	
func set_nivel(texto : String):
	nivel.text = salto_de_linea_texto(texto)
	
func set_vida(texto : String):
	vida.text = salto_de_linea_texto(texto)
	
func set_moral(texto : String):
	moral.text = salto_de_linea_texto(texto)
	
func set_experiencia(texto : String):
	experiencia.text = salto_de_linea_texto(texto)
	
func set_equipo(texto : String):
	equipo.text = salto_de_linea_texto(texto)
