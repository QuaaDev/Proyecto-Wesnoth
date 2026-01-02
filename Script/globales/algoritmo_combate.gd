extends Node
var mostrar_resultados : bool = false

func calcular_daño_total(cantidad_daño : int, tipo_daño : int, armadura_objetivo : estadisticas_defensa) -> int:
	var indice_y_armadura = armadura_objetivo.obtener_estadisticas_defensa().duplicate() #Diccionario
	if !indice_y_armadura.has(tipo_daño):
		push_error("❌Error fatal, estadisticas_defensa no tiene la key "+ str(tipo_daño)+ " devolviendo 0")
		return 0
	var armadura = (float(indice_y_armadura[tipo_daño])) / 100
	#obtiene el daño que coincide con su armadura indice_y_armadura[tipo_daño]
	#lo transforma a float y lo divide por 100
	var daño_total = cantidad_daño - int(cantidad_daño * armadura)
	#se calcula cuanto daño se va a reducir por la armadura cantidad_daño * armadura
	#Luego se resta esa cantidad de daño al daño total
	if mostrar_resultados: #Usar la variable de arriba para mostrar o esconder prints
		print(indice_y_armadura)
		print("tipo daño " + str(tipo_daño) + "pertenece a armadura = " + str(indice_y_armadura[tipo_daño]))
		print("armadura: " + str(armadura))
		print("Cantidad daño: " + str(cantidad_daño))
		print("Daño total es: " + str(daño_total))
	return daño_total

func obtener_mejor_ataque(unidad_atacanteX : Node2D, unidad_objetivo : Node2D) -> int:
	var opcion_y_resultado : Dictionary #Key almacena Indice de ataque y contenido el resultado del ataque
	var defensa_objetivo = unidad_objetivo.get_node("estadisticas_defensa") #Obtiene el recurso de defensa
	var contador : int = 0 #Inicia contador
	for i in unidad_atacanteX.get_node("EstadisticasAtaque").get_children():#Explora todas las opciones de combate
		var opcion_ataque_recurso = i.opcion_ataque_res
		opcion_y_resultado[contador] = calcular_daño_total(opcion_ataque_recurso.cantidad_daño, opcion_ataque_recurso.tipo_daño, defensa_objetivo)
		#Agrega el daño total de este ataque
		contador += 1
	
	return obtener_valor_mayor(opcion_y_resultado)
	
func obtener_valor_mayor(Diccionario : Dictionary) -> int:
	if Diccionario.is_empty():
		push_error("❌Error obtener_valor_mayor el diccionario esta vacio, devolviendo error")
		return -1
		
	var index_con_mas_valor = 0
	var valor_actual = -INF #Infinito negativo
	for i in Diccionario:#Explora las opciones del diccionario
		if Diccionario[i] > valor_actual: #Si la opcion actual tiene un valor mayor al almacenado
			valor_actual = Diccionario[i]#Actualiza el nuevo valor mayor
			index_con_mas_valor = i#Actualiza a que indice pertenece el valor mayor
	return index_con_mas_valor#Devuelve el indice del valor mayor

func _ready() -> void:
	pass
	#var ejemplo = { 0: -8, 1: -1231, 2: -888 }
	#var ejemplo2 = {0 : 10, 1 : 25, 2:0}
	#var ejemplo3 = {}
	#print(obtener_valor_mayor(ejemplo))
	#print(obtener_valor_mayor(ejemplo2))
	#print(obtener_valor_mayor(ejemplo3))
#---------Seccion combate activo-----------------
#Infligir daños, animaciones, en general ejecutar el combate en si.
var unidad_atacante : Node2D
var unidad_defensor : Node2D
func obtener_unidades_en_combate(atacante : Node2D, defensor : Node2D):
	#Almacena las unidades que entran en combate
	unidad_atacante = atacante
	unidad_defensor = defensor
func limpiar_unidades_en_combate():
	#Limpia las referencias de unidades en combate
	unidad_atacante = null
	unidad_defensor = null

func ejecutar_ataque(daño_atacante : int, daño_defensor : int):
	unidad_atacante.infligir_daño() #Activa el evento de infligir daño de la unidad
	unidad_defensor.recibir_daño(daño_atacante)#Aplica el daño sobre el enemigo
	print("Unidad atacante inflige: " + str(daño_atacante))
	if !unidad_defensor.consulta_si_estoy_muerto():#Si esta muerto no inflige daño
		unidad_defensor.infligir_daño()
		unidad_atacante.recibir_daño(daño_defensor)
		print("Unidad defensora inflige: " + str(daño_defensor))
	else:
		print("Unidad ya muerta, no puede atacar")
	limpiar_unidades_en_combate()
