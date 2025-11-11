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
	salto_de_linea_texto(texto_test)
func salto_de_linea_texto(texto : String):
	var text_to_print = "" #Variable temporal que almacena el texto del label
	var x = 1#Contador de ejecuciones
	var quantity_of_letters = 22#Cada cuantas letras se agrega salto de linea
	for i in range(1,ceil(float((float(texto.length()))/quantity_of_letters)+1)):
		#Cada 22 caracteres, hace un bucle (empezando siempre por 1)
		text_to_print = text_to_print + (texto.substr((x-1)*quantity_of_letters,quantity_of_letters) + "\n")
		#Substrae X cantidad de letras apartir del caracter numero (ejecuciones-1)* cada cuantas letras hace salto de linea
		x += 1
	text_to_print = text_to_print.rstrip("\n") #Elimina el salto de linea sobrante
	identificador.text = text_to_print#Remplaza el texto del label
func set_nombre(texto : String):
	pass
