extends TileMapLayer
@onready var button: Button = $Button
var coordenadas = Vector2i(0, 0)
var source_id = 2
var atlas_coordenadas = Vector2i(0,0)
var alternative_id = 0
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
	fliph_and_v = TileSetAtlasSource.TRANSFORM_FLIP_H | TileSetAtlasSource.TRANSFORM_FLIP_V
}
func rotar():
	contador += 1
	if contador == 0:
		print("fliph")
		set_cell(coordenadas, source_id, atlas_coordenadas, alternative_id | 0) #Devuelve la orientacion original
		set_cell(coordenadas, source_id, atlas_coordenadas, alternative_id | FlipEnum.fliph)#aplica fliph
	elif contador == 1:
		print("flipv")
		set_cell(coordenadas, source_id, atlas_coordenadas, alternative_id | 0)#Devuelve la orientacion original
		set_cell(coordenadas, source_id, atlas_coordenadas, alternative_id | FlipEnum.flipv)#aplica flipv
	elif contador == 2:
		print("flipv and fliph")
		set_cell(coordenadas, source_id, atlas_coordenadas, alternative_id | 0)#Devuelve la orientacion original
		set_cell(coordenadas, source_id, atlas_coordenadas, alternative_id | FlipEnum.flipv_and_h)#aplica flipv
		contador = -1
	elif contador == 3:
		print("fliph and flipv")
		set_cell(coordenadas, source_id, atlas_coordenadas, alternative_id | 0)#Devuelve la orientacion original
		set_cell(coordenadas, source_id, atlas_coordenadas, alternative_id | FlipEnum.fliph_and_v)#aplica flipv
		contador = -1
	
#https://docs.godotengine.org/en/stable/classes/class_tilesetatlassource.html#constants
#Las rotaciones de 90 y 270 no me sirven de nada prq rompe la forma del hexagono, tienen que ser siempre de 0 o 180
#Puedo usar fliph y flipv de forma individual para cubrir 3 casos con un solo sprite! Hora de hacer todo de cero el template...
