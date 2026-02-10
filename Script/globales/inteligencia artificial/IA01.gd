extends Node
signal todas_las_unidades_procesadas #Cuando se agota la lista de unidades a aplicarle IA, activa esta señal
var nodo_mundo
#Obtener las unidades a las que hay que aplicarle la IA
func cargar_unidades(equipo:int) -> Array:#Devuelve las unidades dentro del grupo especificado
	return get_tree().get_nodes_in_group(str(equipo))
	
func ejecutar_ia(equipo : int):
	var unidades = cargar_unidades(equipo) #Almacena las unidades a aplicarle IA
	obtener_datos(unidades)

func obtener_datos(unidades : Array):
	#print(unidad.name)
	#AlgoritmoDijkstra.moviendo_unidad(unidad, nodo_mundo.ubicaciones_ocupadas,false) 
	#Carga los movimientos legales en el algoritmo dirksdad, se accede con AlgoritmoDijkstra.movimientos_disponibles
	var ubicaciones_ocupadas = nodo_mundo.ubicaciones_ocupadas.duplicate()
	for i in unidades:
		if i.coordenada_local_tilemap in ubicaciones_ocupadas:
			pass
		print(i.name)
		print(i.coordenada_local_tilemap)
func obtener_nodo_mundo (nodo : Node):
	nodo_mundo = nodo
