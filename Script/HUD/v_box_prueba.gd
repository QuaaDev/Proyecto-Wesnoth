extends VBoxContainer

@onready var nombre: Label = $Nombre
@onready var identificador: Label = $Identificador

var word = "identificador_unidad" #Texto que se aplicara al label
func _ready() -> void:
	var text_to_print = "" #Variable temporal que almacena el texto del label
	var x = 1#Contador de ejecuciones
	var quantity_of_letters = 22#Cada cuantas letras se agrega salto de linea
	for i in range(1,ceil(float(word.length())/quantity_of_letters)+1):
		#Cada 22 caracteres, hace un bucle (empezando siempre por 1)
		text_to_print = text_to_print + word.substr((x-1)*quantity_of_letters,quantity_of_letters) + "\n"
		#Substrae X cantidad de letras apartir del caracter numero (ejecuciones-1)* cada cuantas letras hace salto de linea
		x += 1
	text_to_print = text_to_print.rstrip("\n") #Elimina el salto de linea sobrante
	identificador.text = text_to_print#Remplaza el texto del label
