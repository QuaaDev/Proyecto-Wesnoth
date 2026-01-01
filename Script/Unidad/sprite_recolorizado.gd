extends Sprite2D
@onready var sprite: Sprite2D = $"."
#recolorización por máscara de color
#Codigo hecho por chatgpt, completamente temporal y descartable a futuro.
const paletas_colores := [Color("5770faff"), Color("fb0038ff"), Color("cd6c01ff"), Color("009d3cff")]
func cambiar_color(equipo : int):
	# Color del equipo (ejemplo: azul)
	var team_color := Color(0.0, 0.0, 0.0, 1.0)
	if equipo == 1:
		team_color = paletas_colores[0]
	elif equipo == 2:
		team_color = paletas_colores[1]
	elif equipo == 3:
		team_color = paletas_colores[2]
	elif equipo == 4:
		team_color = paletas_colores[3]

	sprite.texture = recolor_texture(sprite.texture, team_color)


func recolor_texture(original: Texture2D, team_color: Color) -> ImageTexture:
	var image: Image = original.get_image()

	for y in range(image.get_height()):
		for x in range(image.get_width()):
			var c: Color = image.get_pixel(x, y)

			if is_team_red(c):
				image.set_pixel(x, y, recolor_red(c, team_color))

	return ImageTexture.create_from_image(image)


func is_team_red(c: Color) -> bool:
	# Detecta rojo dominante (robusto para sombreado)
	return c.r > 0.5 and c.r > c.g * 1.2 and c.r > c.b * 1.2


func recolor_red(c: Color, team_color: Color) -> Color:
	# Usa el canal rojo como intensidad (preserva volumen)
	var intensity := c.r
	return Color(
		team_color.r * intensity,
		team_color.g * intensity,
		team_color.b * intensity,
		c.a
	)
