extends Node
signal todas_las_unidades_procesadas #Cuando se agota la lista de unidades a aplicarle IA, activa esta señal
var nodo_mundo
#Obtener las unidades a las que hay que aplicarle la IA
func cargar_unidades(equipo:int) -> Array:#Devuelve las unidades dentro del grupo especificado
	return get_tree().get_nodes_in_group(str(equipo))
	
func ejecutar_ia(equipo : int):
	var unidades = cargar_unidades(equipo) #Almacena las unidades a aplicarle IA
	for i in unidades:
		obtener_datos(i)

func obtener_datos(unidad : Node2D):
	print(unidad.name)
	AlgoritmoDijkstra.moviendo_unidad(unidad, nodo_mundo.ubicaciones_ocupadas,false)
	print(AlgoritmoDijkstra.movimientos_disponibles)

func obtener_nodo_mundo (nodo : Node):
	nodo_mundo = nodo
