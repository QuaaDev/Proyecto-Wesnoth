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
@onready var tileset : TileSet = Layer0.tile_set#Referencia al tileset
var lista_terrenos_compuestos_cargados : Array[terrain_compuesto]
#Solo hace falta una prq alterar uno altera a todos los layers
#https://docs.godotengine.org/en/stable/classes/class_tileset.html#class-tileset-method-add-source
enum FlipEnum{
	fliph = TileSetAtlasSource.TRANSFORM_FLIP_H,
	flipv = TileSetAtlasSource.TRANSFORM_FLIP_V,
	flipv_and_h = TileSetAtlasSource.TRANSFORM_FLIP_V | TileSetAtlasSource.TRANSFORM_FLIP_H,
}

func _ready() -> void:
	#agregar_terreno_compuesto("Blanco", "Negro")
	#agregar_source("res://Assets/tilemap/PruebaAutoTile/primerresultado111.png")#Agrega un tilesetatlassource al tileset
	pass

func agregar_source(path_png : String, id : int):
	var source := TileSetAtlasSource.new() #Hace un nuevo tilesetatlas blabla
	source.texture = load(path_png)#Textura a cargar
	source.texture_region_size = Vector2i(72,72)#La configuracion de mi tileset
	#-----------Creacion de los tile-------------
	source.create_tile(Vector2i(1, 0))
	source.create_tile(Vector2i(2, 0))
	#-----------Creacion de los tile-------------
	tileset.add_source(source,id)#Agrega el nuevo source


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
			#------------------seccion elegir terreno-----------------------
			var tipo_terreno_id = get_cell_tile_data(coordenada).get_custom_data("tipo_terreno_id")#Almacena el id del terreno actual
			#Los bit representan las fronteras que pueden tener los hexagonos -> (0,0,0,0,0,0)
			#Un bit positivo es una frontera activa, la posicion de ese bit representa que parte del hexagono es
			var contador_posicion_bit := 0#Almacena cual bit del terreno es el que se esta analizando
			var vecinos = get_neighbors(coordenada)#Almacena los vecinos en formato 0,1,2,3,4,5 del template
			print("--------------------------")
			print("Calculando, ",coordenada)
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
					if verificar_si_existe_terreno_compuesto(tipo_terreno_id + "-" + vecino_tipo_terreno_id): #si existe no lo vuelve a cargar
						pass
					else:
						agregar_terreno_compuesto(tipo_terreno_id, vecino_tipo_terreno_id)#Si no existe lo carga
					var source_id_del_terrain = obtener_source_id_terrain(tipo_terreno_id + "-" + vecino_tipo_terreno_id) #Almacena el id 
					#print(verificar_si_existe_terreno_compuesto(tipo_terreno_id + "-" + vecino_tipo_terreno_id))
					var nombre_variable = "Layer" + str(contador_posicion_bit)
					#print("Edito la variable: ",nombre_variable)
					var efecto_a_aplicar = aplicar_efecto(nombre_variable)#Almacena que efecto se va a aplicar
					#Dependiendo del layer, es el tile que elige 
					if nombre_variable == "Layer1" or nombre_variable == "Layer4":
						get(nombre_variable).set_cell(coordenada, source_id_del_terrain, Vector2i(1, 0), 0 | efecto_a_aplicar)
					else:
						get(nombre_variable).set_cell(coordenada, source_id_del_terrain, Vector2i(2, 0), 0 | efecto_a_aplicar)
				contador_posicion_bit += 1#Avanza en uno la posicion del bit
	for i in lista_terrenos_compuestos_cargados:
		print(i.terreno_compuesto)
				#print("mio ",tipo_terreno_id)
				#print("vecino ",vecino_tipo_terreno_id)
			#print("------------------------")
			#print("vecinos de :", coordenada," son ",get_neighbors(coordenada))
			
func verificar_si_existe_terreno_compuesto(terreno_compuesto : String) -> bool:
	for i in lista_terrenos_compuestos_cargados: #Explora toda la lista
		if i.terreno_compuesto == terreno_compuesto:#Verifica si esta cargado actualmente en la lista
			return true
		else:
			continue
	return false
func agregar_terreno_compuesto(origen : String, vecino : String):
	var nuevo_terreno_compuesto = terrain_compuesto.new()#Crea un nuevo terrain compuesto
	nuevo_terreno_compuesto.cargar_terrenos(origen, vecino)#Le carga la informacion al objeto
	lista_terrenos_compuestos_cargados.append(nuevo_terreno_compuesto)#Guarda la referencia en la lista
	nuevo_terreno_compuesto.cargar_id(lista_terrenos_compuestos_cargados.find(nuevo_terreno_compuesto))
	agregar_source(CargaTerrainAssets.obtener_path(origen, vecino),nuevo_terreno_compuesto.id)#Obtiene el path del png y luego lo carga al source
	print(nuevo_terreno_compuesto.id)
	#El index del objeto DEBERIA de estar sincronizado con el index del source.

func obtener_source_id_terrain(terreno_compuesto : String) -> int:
	for i in lista_terrenos_compuestos_cargados: #Explora la lista
		if i.terreno_compuesto == terreno_compuesto: #Buscando un terreno compuesto que coincida
			return i.id #Si coincide, devuelve su id
	push_error("Terreno compuesto no encontrado, devolviendo error")
	return -1


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
