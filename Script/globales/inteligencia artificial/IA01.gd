extends Node
signal todas_las_unidades_procesadas #Cuando se agota la lista de unidades a aplicarle IA, activa esta señal
var nodo_mundo
var ubicaciones_ocupadas_enemigos
var movimientos_disponibles_incluyendo_ocupados
func ejecutar_ia(equipo : int):
	var unidades = cargar_unidades(equipo) #Almacena las unidades a aplicarle IA
	obtener_datos(unidades)

#Obtener las unidades a las que hay que aplicarle la IA
func cargar_unidades(equipo:int) -> Array:#Devuelve las unidades dentro del grupo especificado
	return get_tree().get_nodes_in_group(str(equipo))
	
func obtener_datos(unidades : Array):
	ubicaciones_ocupadas_enemigos = nodo_mundo.ubicaciones_ocupadas.duplicate()
	#Almacena las ubicaciones enemigas 
	descartar_unidades_aliadas(unidades)
	obtener_posibles_objetivos(unidades)
	ejecutar_ataque(unidades)
#---------------Recursos Obtener Datos---------------
func descartar_unidades_aliadas(unidades : Array):
	#Quita de la lista a las unidades aliadas para facilitar el encontrar enemigos
	for i in unidades:
		if i.coordenada_local_tilemap in ubicaciones_ocupadas_enemigos:
			ubicaciones_ocupadas_enemigos.erase(i.coordenada_local_tilemap)
			
func obtener_posibles_objetivos(unidades : Array):
	for i in unidades:#explora todas las unidades
		print("Ubicaciones Ocupadas Por Enemigos ", i.name)
		AlgoritmoDijkstra.moviendo_unidad(i, nodo_mundo.ubicaciones_ocupadas,false)#Carga la lista de movimientos para esta unidad
		movimientos_disponibles_incluyendo_ocupados = AlgoritmoDijkstra.movimientos_disponibles_incluyendo_ocupados.duplicate()
		#Duplica la lista de movimientos disponibles blabla
		if movimientos_disponibles_incluyendo_ocupados.is_empty():
			#Si la lista esta vacia, se ahorra el procesar las cosas
			print("No se detecto ubicaciones de enemigos")
		else:
			for x in movimientos_disponibles_incluyendo_ocupados: #Por cada posible ataque
				if x in ubicaciones_ocupadas_enemigos:#Verifica que no sean aliados prq obviamente no atacas aliados
					print("La unidad ",x," esta a rango de ataque")
					i.objetivos_a_atacar[x] = movimientos_disponibles_incluyendo_ocupados[x] #Guarda la informacion en la unidad
		#print(movimientos_disponibles_incluyendo_ocupados)
		print("objetivos a atacar",i.objetivos_a_atacar)
		print(i.coordenada_local_tilemap)
		print("-------------------------")

func ejecutar_ataque(unidades:Array):
	for i in unidades:
		if !i.objetivos_a_atacar.is_empty():
			analizar_ataque(i)
		else:
			print("No hay posibles ataques :c")

func analizar_ataque(unidad : unidad_base):
	print(unidad.name)
	var clave_random = unidad.objetivos_a_atacar.keys().pick_random()
	var objetivo : Dictionary
	objetivo[clave_random] = unidad.objetivos_a_atacar[clave_random]
	#Elige un objetivo aleatorio de entre los que tiene
	print("Ataco a: " + str(objetivo))
func obtener_nodo_mundo (nodo : Node):
	nodo_mundo = nodo
