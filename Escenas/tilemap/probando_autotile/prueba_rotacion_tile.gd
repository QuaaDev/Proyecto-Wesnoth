extends TileMapLayer
@onready var button: Button = $Button
@onready var label: Label = $Label
#-------Referencias layers-------------
@onready var Layer0: TileMapLayer = $TerrainCarpet/Layer0
@onready var Layer1: TileMapLayer = $TerrainCarpet/Layer1
@onready var Layer2: TileMapLayer = $TerrainCarpet/Layer2
@onready var Layer3: TileMapLayer = $TerrainCarpet/Layer3
@onready var Layer4: TileMapLayer = $TerrainCarpet/Layer4
@onready var Layer5: TileMapLayer = $TerrainCarpet/Layer5
#--------------------------------------
@export var limite_del_mapa : Vector2i #Define los limites del mapa para limitar los algoritmos

#https://docs.godotengine.org/en/stable/classes/class_tileset.html#class-tileset-method-add-source
enum FlipEnum{
	fliph = TileSetAtlasSource.TRANSFORM_FLIP_H,
	flipv = TileSetAtlasSource.TRANSFORM_FLIP_V,
	flipv_and_h = TileSetAtlasSource.TRANSFORM_FLIP_V | TileSetAtlasSource.TRANSFORM_FLIP_H,
}
func rotar():
	aplicar_terreno()

func aplicar_terreno():
	#Explora todas las coordenadas dentro del area del limite (incluyendo el limite)
	#+1 para que incluya completamente el limite del mapa, si no queda 1 por debajo
	for x in range(-1,limite_del_mapa.x+1):
		for y in range(-1,limite_del_mapa.y+1):
			var coordenada = Vector2i(x,y)#Las coordenadas del hexagono actual
			var source_id = get_cell_source_id(coordenada)#Obtiene su source id
			if source_id == -1: #Si el tile actual es invalido, saltea su procesamiento
				continue
			#var atlas_coordenada = get_cell_atlas_coords(coordenada)
			#var alternative_id = 0
			var tipo_terreno_id = get_cell_tile_data(coordenada).get_custom_data("tipo_terreno_id")#Almacena el id del terreno actual
			#Los bit representan las fronteras que pueden tener los hexagonos -> (0,0,0,0,0,0)
			#Un bit positivo es una frontera activa, la posicion de ese bit representa que parte del hexagono es
			var contador_posicion_bit := 0#Almacena cual bit del terreno es el que se esta analizando
			var vecinos = get_neighbors(coordenada)#Almacena los vecinos en formato 0,1,2,3,4,5 del template
			#print("--------------------------")
			#print("Calculando, ",coordenada)
			for i in vecinos:#Va del 0 al 5
				if contador_posicion_bit == 6:#Reinicia el contador si supera las 6 ejecuciones
					contador_posicion_bit = 0
				if get_cell_source_id(i) == -1:
					#Si el tile vecino es invalido, lo saltea 
					#print("Vecino sin tile definido, aplicando continue")
					contador_posicion_bit += 1#Avanza en uno la posicion del bit
					continue
				var vecino_tipo_terreno_id = get_cell_tile_data(i).get_custom_data("tipo_terreno_id")
				if tipo_terreno_id != vecino_tipo_terreno_id:
					#Si el origen y el vecino tienen diferente terreno, aplica el efecto
					var nombre_variable = "Layer" + str(contador_posicion_bit)
					#print("Edito la variable: ",nombre_variable)
					var efecto_a_aplicar = aplicar_efecto(nombre_variable)#Almacena que efecto se va a aplicar
					#--------------Volver mas modular el terreno a elegir-------------------------------
					if tipo_terreno_id == 1:
						if nombre_variable == "Layer1" or nombre_variable == "Layer4":
							get(nombre_variable).set_cell(coordenada, 0, Vector2i(1,2), 0 | efecto_a_aplicar)
						else:
							get(nombre_variable).set_cell(coordenada, 0, Vector2i(2,2), 0 | efecto_a_aplicar)
					else:
						if nombre_variable == "Layer1" or nombre_variable == "Layer4":
							get(nombre_variable).set_cell(coordenada, 0, Vector2i(1,3), 0 | efecto_a_aplicar)
						else:
							get(nombre_variable).set_cell(coordenada, 0, Vector2i(2,3), 0 | efecto_a_aplicar)
					#------------------------------------------------------------------------------------
				contador_posicion_bit += 1#Avanza en uno la posicion del bit
				#print("mio ",tipo_terreno_id)
				#print("vecino ",vecino_tipo_terreno_id)
			#print("------------------------")
			#print("vecinos de :", coordenada," son ",get_neighbors(coordenada))

func aplicar_efecto(Layer : String) -> int:
	match Layer: 
		#Segun el layer a editar, es el efecto que se le asigna
		"Layer0":
			return 0
		"Layer1":
			return 0
		"Layer2":
			return FlipEnum.fliph
		"Layer3":
			return FlipEnum.flipv_and_h
		"Layer4":
			return FlipEnum.flipv
		"Layer5":
			return FlipEnum.flipv
		_:
			push_error("Layer no identificado, valor: ",Layer)
			return 0


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
