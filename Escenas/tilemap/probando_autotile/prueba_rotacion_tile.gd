extends TileMapLayer
@onready var button: Button = $Button
@onready var label: Label = $Label
#-------Referencias layers-------------
@onready var layer_0: TileMapLayer = $TerrainCarpet/Layer0
@onready var layer_1: TileMapLayer = $TerrainCarpet/Layer1
@onready var layer_2: TileMapLayer = $TerrainCarpet/Layer2
@onready var layer_3: TileMapLayer = $TerrainCarpet/Layer3
@onready var layer_4: TileMapLayer = $TerrainCarpet/Layer4
@onready var layer_5: TileMapLayer = $TerrainCarpet/Layer5
#--------------------------------------
@export var limite_del_mapa : Vector2i #Define los limites del mapa para limitar los algoritmos
var coordenadas = Vector2i(0, 0)
#var source_id = 5
#var atlas_coordenadas = [Vector2i(0,0),Vector2i(1,0),Vector2i(2,0),Vector2i(3,0),Vector2i(4,0),Vector2i(5,0),
#Vector2i(6,0),Vector2i(7,0),Vector2i(0,1),Vector2i(1,1),Vector2i(2,1),Vector2i(3,1),Vector2i(4,1),Vector2i(5,1)]
#var alternative_id = 0
var contador = -1
enum TileTransform {
	ROTATE_0 = 0,
	ROTATE_90 = TileSetAtlasSource.TRANSFORM_TRANSPOSE | TileSetAtlasSource.TRANSFORM_FLIP_H,
	ROTATE_180 = TileSetAtlasSource.TRANSFORM_FLIP_H | TileSetAtlasSource.TRANSFORM_FLIP_V,
	ROTATE_270 = TileSetAtlasSource.TRANSFORM_TRANSPOSE | TileSetAtlasSource.TRANSFORM_FLIP_V,
}
enum FlipEnum{
	fliph = TileSetAtlasSource.TRANSFORM_FLIP_H,
	flipv = TileSetAtlasSource.TRANSFORM_FLIP_V,
	flipv_and_h = TileSetAtlasSource.TRANSFORM_FLIP_V | TileSetAtlasSource.TRANSFORM_FLIP_H,
}
func rotar():
	aplicar_terreno()
	#prueba_rotaciones()

func aplicar_terreno():
	#Explora todas las coordenadas dentro del area del limite (incluyendo el limite)
	#+1 para que incluya completamente el limite del mapa, si no queda 1 por debajo
	for x in range(0,limite_del_mapa.x+1):
		for y in range(0,limite_del_mapa.y+1):
			var coordenada = Vector2i(x,y)
			var source_id = get_cell_source_id(coordenada)
			if source_id == -1: #Si el tile actual es invalido, saltea su procesamiento
				continue
			var atlas_coordenada = get_cell_atlas_coords(coordenada)
			var alternative_id = 0
			var custom_data = get_cell_tile_data(coordenada)
			var tipo_terreno_id = custom_data.get_custom_data("tipo_terreno_id")#Almacena el id del terreno
			var contador_posicion_bit := 0#Almacena cual bit del terreno es el que se esta analizando
			var vecinos = get_neighbors(coordenada)#Almacena los vecinos en formato 0,1,2,3,4,5 del template
			for i in vecinos:#Va del 0 al 5
				if !(get_cell_source_id(i) == -1):
					#Si el tile vecino es invalido, lo saltea 
					print("Vecino sin tile definido, aplicando continue")
					continue
				
			#set_cell(coordenada, source_id, atlascoordenada, alternative_id | FlipEnum.fliph)#aplica fliph
			print("vecinos de :",coordenada," son: ")
			print("Mi Modelo: ", get_neighbors(coordenada))


func prueba_rotaciones():
	contador += 1
	#if contador == 0:
		#label.text = "horizontal flip"
		#for i in atlas_coordenadas:
			#set_cell(i, source_id, i, alternative_id | 0) #Devuelve la orientacion original
			#set_cell(i, source_id, i, alternative_id | FlipEnum.fliph)#aplica fliph
		##0,0,1,1,1,0 -> 1,1,0,0,0,1 horizontal flip 
	#elif contador == 1:
		#label.text = "vertical flip"
		#for i in atlas_coordenadas:
			#set_cell(i, source_id, i, alternative_id | 0)#Devuelve la orientacion original
			#set_cell(i, source_id, i, alternative_id | FlipEnum.flipv)#aplica flipv
			##,1,1,1,0,0,0 -> 0,0,0,1,1,1 vertical flip
	#elif contador == 2:
		#label.text = "diagonal flip"
		#for i in atlas_coordenadas:
			#set_cell(i, source_id, i, alternative_id | 0)#Devuelve la orientacion original
			#set_cell(i, source_id, i, alternative_id | FlipEnum.flipv_and_h)#aplica flipv
		##0,1,1,1,0,0 -> 1,0,0,0,1,1 diagonal flip
	#elif contador == 3:
		#label.text = "Original position"
		#for i in atlas_coordenadas:
			#set_cell(i, source_id, i, alternative_id | 0)
		#contador = -1
	
#https://docs.godotengine.org/en/stable/classes/class_tilesetatlassource.html#constants
#Las rotaciones de 90 y 270 no me sirven de nada prq rompe la forma del hexagono, tienen que ser siempre de 0 o 180
#Puedo usar fliph y flipv de forma individual para cubrir 3 casos con un solo sprite! Hora de hacer todo de cero el template...
func get_neighbors(origen : Vector2i) -> Array: #Devuelve la lista de vecinos de X tile hex
	#Modelo odd-q
	var vecinos = []
	#even = par , odd = impar
	if int(origen.x) % 2 == 0: #Si la columna es par
		#print("Columna par")
		vecinos.append(Vector2i(origen.x - 1, origen.y - 1))#NO
		vecinos.append(Vector2i(origen.x , origen.y - 1))#N
		vecinos.append(Vector2i(origen.x + 1 , origen.y - 1))#NE
		vecinos.append(Vector2i(origen.x + 1 , origen.y)) #SE
		vecinos.append(Vector2i(origen.x , origen.y + 1))#S
		vecinos.append(Vector2i(origen.x - 1, origen.y))#SO
	else:
		#print("columna impar")
		vecinos.append(Vector2i(origen.x- 1 , origen.y))#NO
		vecinos.append(Vector2i(origen.x , origen.y - 1))#N
		vecinos.append(Vector2i(origen.x + 1, origen.y)) #NE
		vecinos.append(Vector2i(origen.x + 1 , origen.y + 1)) #SE
		vecinos.append(Vector2i(origen.x , origen.y + 1))#S
		vecinos.append(Vector2i(origen.x - 1, origen.y + 1))#SO
	#editado para que NO sea primero para el patron 0,1,2,3,4,5
	return vecinos
