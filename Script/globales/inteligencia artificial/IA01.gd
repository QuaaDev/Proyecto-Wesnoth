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
	#print(unidad.name)
	#AlgoritmoDijkstra.moviendo_unidad(unidad, nodo_mundo.ubicaciones_ocupadas,false) 
	#Carga los movimientos legales en el algoritmo dirksdad, se accede con AlgoritmoDijkstra.movimientos_disponibles
	ubicaciones_ocupadas_enemigos = nodo_mundo.ubicaciones_ocupadas.duplicate()
	#Almacena las ubicaciones enemigas 
	for i in unidades:
		if i.coordenada_local_tilemap in ubicaciones_ocupadas_enemigos:
		#Quita de la lista a las unidades aliadas para facilitar el encontrar enemigos
			ubicaciones_ocupadas_enemigos.erase(i.coordenada_local_tilemap)
		print(i.name)
		#-----debug---------
		print("Ubicaciones Ocupadas Por Enemigos")
		print(ubicaciones_ocupadas_enemigos)
		AlgoritmoDijkstra.moviendo_unidad(i, nodo_mundo.ubicaciones_ocupadas,false)
		movimientos_disponibles_incluyendo_ocupados = AlgoritmoDijkstra.movimientos_disponibles_incluyendo_ocupados.duplicate()
		if movimientos_disponibles_incluyendo_ocupados.is_empty():
			print("No se detecto ubicaciones de enemigos")
		else:
			for x in movimientos_disponibles_incluyendo_ocupados:
				if x in ubicaciones_ocupadas_enemigos:
					print("La unidad ",x," esta a rango de ataque")
		print(movimientos_disponibles_incluyendo_ocupados)
		print(i.coordenada_local_tilemap)
func obtener_nodo_mundo (nodo : Node):
	nodo_mundo = nodo
