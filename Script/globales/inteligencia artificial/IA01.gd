extends Node
signal todas_las_unidades_procesadas #Cuando se agota la lista de unidades a aplicarle IA, activa esta señal
#Primera version de la IA :D. 2 semanas de trabajo dieron sus frutos.
var nodo_mundo
var ubicaciones_ocupadas_enemigos : Dictionary#Almacena las ubicaciones de los enemigos
var movimientos_disponibles_incluyendo_ocupados
var unidades_almacenadas
enum decision_IA {no_definido = 0,atacando = 1, moviendose = 2}
var decision_final : decision_IA
func ejecutar_ia(equipo : int):
	unidades_almacenadas = cargar_unidades(equipo) #Almacena las unidades a aplicarle IA
	for unidad in unidades_almacenadas: #Se ejecuta cada unidad de forma independiente.
		ubicaciones_ocupadas_enemigos = nodo_mundo.ubicaciones_ocupadas.duplicate() #Actualiza la informacion
		descartar_unidades_aliadas(unidades_almacenadas)
		decision_final= decision_IA.no_definido#Resetea el valor del estado
		print("-------------------")
		print(unidad.name)
		unidad.limpiar_objetivos_ataque() #Limpia la lista de objetivos
		unidad.puntos_movimiento += 1 #Para poder detectar a las unidades al limite del rango le suma +1 al movimiento
		obtener_datos(unidad)#Obtiene informacion del entorno
		await ejecutar_ataque(unidad)#Ejecuta el ataque Y espera a que todo el ataque termine
		if decision_final == decision_IA.no_definido and !ubicaciones_ocupadas_enemigos.is_empty(): 
			#Si no esta definido su estado, significa que no pudo atacar AND si hay enemigos aun vivos
			avanzar_hacia_un_enemigo(unidad)#Avanza hacia algun enemigo
			await unidad.animacion_movimiento_terminada
			decision_final = decision_IA.moviendose
		print("Decision final de la IA: ",decision_final)
		print("-------------------")
	todas_las_unidades_procesadas.emit()

#Obtener las unidades a las que hay que aplicarle la IA
func cargar_unidades(equipo:int) -> Array:#Devuelve las unidades dentro del grupo especificado
	return get_tree().get_nodes_in_group(str(equipo))
	
func obtener_datos(unidad : unidad_base):
	#Almacena las ubicaciones enemigas 
	obtener_posibles_objetivos(unidad)
#---------------Recursos Obtener Datos---------------
func descartar_unidades_aliadas(unidades : Array):
	#Quita de la lista a las unidades aliadas para facilitar el encontrar enemigos
	for i in unidades:
		if i.coordenada_local_tilemap in ubicaciones_ocupadas_enemigos:
			ubicaciones_ocupadas_enemigos.erase(i.coordenada_local_tilemap)
			
func obtener_posibles_objetivos(unidad : unidad_base):
	#print("Ubicaciones Ocupadas Por Enemigos ")
	AlgoritmoDijkstra.moviendo_unidad(unidad, nodo_mundo.ubicaciones_ocupadas,false)#Carga la lista de movimientos para esta unidad
	movimientos_disponibles_incluyendo_ocupados = AlgoritmoDijkstra.movimientos_disponibles_incluyendo_ocupados.duplicate()
	#Duplica la lista de movimientos disponibles blabla
	if movimientos_disponibles_incluyendo_ocupados.is_empty():
		#Si la lista esta vacia, se ahorra el procesar las cosas
		print("No se detecto ubicaciones de enemigos")
	else:
		for x in movimientos_disponibles_incluyendo_ocupados: #Por cada posible ataque
			if x in ubicaciones_ocupadas_enemigos:#Verifica que no sean aliados prq obviamente no atacas aliados
				#print("La unidad ",x," esta a rango de ataque")
				unidad.objetivos_a_atacar[x] = movimientos_disponibles_incluyendo_ocupados[x] #Guarda la informacion en la unidad
	#print(movimientos_disponibles_incluyendo_ocupados)
	print("objetivos a atacar",unidad.objetivos_a_atacar)
	#print(unidad.coordenada_local_tilemap)

func ejecutar_ataque(unidad: unidad_base):
	if !unidad.objetivos_a_atacar.is_empty(): #Si la unidad tiene objetivos para atacar
		analizar_ataque(unidad) #Decide a cual atacar
		realizar_movimiento_adyacente(unidad)#Luego realiza el movimiento
		realizar_ataque(unidad)#Luego ejecuta el ataque
		decision_final = decision_IA.atacando#Actualiza la decision de la IA
		await AlgoritmoCombate.combate_finalizado #Espera a que finalice el combate
	else:
		print("No hay posibles ataques :c")

func analizar_ataque(unidad : unidad_base):
	var clave_random = unidad.objetivos_a_atacar.keys().pick_random()
	var objetivo : Dictionary
	objetivo[clave_random] = unidad.objetivos_a_atacar[clave_random]
	unidad.objetivo_final.append(clave_random)
	unidad.objetivo_final.append(objetivo[clave_random])
	#Elige un objetivo aleatorio de entre los que tiene
	print("Ataco a: " , unidad.objetivo_final)

func realizar_movimiento_adyacente(unidad : unidad_base):
	var resultado = AlgoritmoDijkstra.obtener_vecino_mas_barato(unidad.objetivo_final[0], unidad.objetivo_final[1])
	#Convierte el diccionario en un array, se accede a sus valores con [0] y [1]
	#print("me muevo a",resultado)
	nodo_mundo.mover_unidad(unidad,resultado[0])

func realizar_ataque(unidad : unidad_base):
	var unidad_atacante = unidad
	var unidad_defensora = nodo_mundo.ubicaciones_ocupadas[unidad.objetivo_final[0]] #Referencia a la unidad que se defendera
	AlgoritmoCombate.obtener_unidades_en_combate(unidad_atacante, unidad_defensora) #Actualiza la informacion de las unidades en combate
	var daño_unidad_atacante = AlgoritmoCombate.obtener_mejor_ataque(unidad_atacante, unidad_defensora, false)
	#Obtiene el mejor ataque posible
	var daño_unidad_defensora = AlgoritmoCombate.obtener_mejor_ataque(unidad_defensora, unidad_atacante, false)
	#Obtiene el mejor ataque posible
	print("daño unidad atacante: ", str(daño_unidad_atacante))
	print("daño unidad defensora: ", str(daño_unidad_defensora))
	AlgoritmoCombate.ejecutar_ataque(daño_unidad_atacante, daño_unidad_defensora)#Envia la informacion a algoritmo combate para que vuelva real el combate
func obtener_nodo_mundo (nodo : Node):
	nodo_mundo = nodo
func avanzar_hacia_un_enemigo(unidad : unidad_base):
	var origen = unidad.coordenada_local_tilemap#Ubicacion de la unidad
	var heuristica_distancia_enemiga : Array
	for i in ubicaciones_ocupadas_enemigos:
		heuristica_distancia_enemiga.append(AlgoritmoDijkstra.heuristica(origen, i))#Mide la distancia entre dos puntos y almacena el resultado
	var ubicaciones_ocupadas_enemigos_keys = ubicaciones_ocupadas_enemigos.keys()#Lo transforma de dictionary a un array
	var destino = ubicaciones_ocupadas_enemigos_keys[heuristica_distancia_enemiga.find(heuristica_distancia_enemiga.min())]
	#Obtiene el destino segun la heuristica con mejor valor y luego buscando el indice segun ese valor
	AlgoritmoDijkstra.a_estrella_multi_hilo(origen,destino,nodo_mundo.ubicaciones_ocupadas.duplicate(),unidad.puntos_movimiento_maximo)#Envia la informacion al algoritmo
	await AlgoritmoDijkstra.resultado_estrella_obtenido#Espera a que el multihilo termine
	var resultado = AlgoritmoDijkstra.resultado_a_estrella#Almacena el resultado
	print("Seguire el siguiente camino:",resultado)
	nodo_mundo.mover_unidad_con_a_estrella(unidad,resultado) #mueve la unidad con la funcion de A*
