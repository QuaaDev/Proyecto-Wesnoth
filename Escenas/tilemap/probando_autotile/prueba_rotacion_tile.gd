extends TileMapLayer
@onready var button: Button = $Button
@onready var label: Label = $Label

var coordenadas = Vector2i(0, 0)
var source_id = 2
var atlas_coordenadas = [Vector2i(0,0),Vector2i(1,0),Vector2i(2,0),Vector2i(3,0),Vector2i(4,0),Vector2i(5,0),
Vector2i(6,0),Vector2i(7,0)]
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
}
func rotar():
	contador += 1
	if contador == 0:
		label.text = "horizontal flip"
		for i in atlas_coordenadas:
			set_cell(i, source_id, i, alternative_id | 0) #Devuelve la orientacion original
			set_cell(i, source_id, i, alternative_id | FlipEnum.fliph)#aplica fliph
		#0,0,1,1,1,0 -> 1,1,0,0,0,1 horizontal flip 
	elif contador == 1:
		label.text = "vertical flip"
		for i in atlas_coordenadas:
			set_cell(i, source_id, i, alternative_id | 0)#Devuelve la orientacion original
			set_cell(i, source_id, i, alternative_id | FlipEnum.flipv)#aplica flipv
			#,1,1,1,0,0,0 -> 0,0,0,1,1,1 vertical flip
	elif contador == 2:
		label.text = "diagonal flip"
		for i in atlas_coordenadas:
			set_cell(i, source_id, i, alternative_id | 0)#Devuelve la orientacion original
			set_cell(i, source_id, i, alternative_id | FlipEnum.flipv_and_h)#aplica flipv
		#0,1,1,1,0,0 -> 1,0,0,0,1,1 diagonal flip
	elif contador == 3:
		label.text = "Original position"
		for i in atlas_coordenadas:
			set_cell(i, source_id, i, alternative_id | 0)
		contador = -1
#https://docs.godotengine.org/en/stable/classes/class_tilesetatlassource.html#constants
#Las rotaciones de 90 y 270 no me sirven de nada prq rompe la forma del hexagono, tienen que ser siempre de 0 o 180
#Puedo usar fliph y flipv de forma individual para cubrir 3 casos con un solo sprite! Hora de hacer todo de cero el template...
