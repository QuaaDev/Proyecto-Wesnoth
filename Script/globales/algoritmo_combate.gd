extends Node
var mostrar_resultados : bool = false

func calcular_daño_total(cantidad_daño : int, tipo_daño : int, armadura_objetivo : estadisticas_defensa) -> int:
	var indice_y_armadura = armadura_objetivo.obtener_estadisticas_defensa().duplicate() #Diccionario
	if !indice_y_armadura.has(tipo_daño):
		print("❌Error fatal, estadisticas_defensa no tiene la key "+ str(tipo_daño)+ " devolviendo 0")
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
