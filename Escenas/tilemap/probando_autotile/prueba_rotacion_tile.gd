extends TileMapLayer
@onready var button: Button = $Button
var coordenadas = Vector2i(0, 0)
var source_id = 2
var atlas_coordenadas = Vector2i(1,1)
var alternative_id = 0
var contador = 0
enum TileTransform {
	ROTATE_0 = 0,
	ROTATE_90 = TileSetAtlasSource.TRANSFORM_TRANSPOSE | TileSetAtlasSource.TRANSFORM_FLIP_H,
	ROTATE_180 = TileSetAtlasSource.TRANSFORM_FLIP_H | TileSetAtlasSource.TRANSFORM_FLIP_V,
	ROTATE_270 = TileSetAtlasSource.TRANSFORM_TRANSPOSE | TileSetAtlasSource.TRANSFORM_FLIP_V,
}
func rotar():
	contador += 1
	if contador == 0:
		set_cell(coordenadas, source_id, atlas_coordenadas, alternative_id | TileTransform.ROTATE_0)
	elif contador == 1:
		set_cell(coordenadas, source_id, atlas_coordenadas, alternative_id | TileTransform.ROTATE_90)
	elif contador == 2:
		set_cell(coordenadas, source_id, atlas_coordenadas, alternative_id | TileTransform.ROTATE_180)
	elif contador == 3:
		set_cell(coordenadas, source_id, atlas_coordenadas, alternative_id | TileTransform.ROTATE_270)
		contador = -1
#Las rotaciones de 90 y 270 no me sirven de nada prq rompe la forma del hexagono, tienen que ser siempre de 0 o 180
#Con esto haciendo la mitad de assets puedo cubrir todas las posibilidades, y luego rotar los existentes segun la necesidad 
