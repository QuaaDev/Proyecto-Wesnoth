extends Node
signal todas_las_unidades_procesadas #Cuando se agota la lista de unidades a aplicarle IA, activa esta señal
var nodo_mundo
var ubicaciones_ocupadas_enemigos

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
		AlgoritmoDijkstra.moviendo_unidad(i, nodo_mundo.ubicaciones_ocupadas,false,true)
		if AlgoritmoDijkstra.movimientos_disponibles in ubicaciones_ocupadas_enemigos:
			print("Detecto la ubicacion de los enemigos")
		else:
			print("No detecto ubicacion de enemigos")
		print(AlgoritmoDijkstra.movimientos_disponibles)
		print(i.coordenada_local_tilemap)
func obtener_nodo_mundo (nodo : Node):
	nodo_mundo = nodo
