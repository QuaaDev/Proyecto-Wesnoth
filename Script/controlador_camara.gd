extends Camera2D

@export var speed := 300.0  # velocidad en píxeles por segundo

func _process(delta):
	var direction = Vector2.ZERO
	
	if Input.is_action_pressed("w"):
		direction.y -= 1
	if Input.is_action_pressed("s"):
		direction.y += 1
	if Input.is_action_pressed("a"):
		direction.x -= 1
	if Input.is_action_pressed("d"):
		direction.x += 1

	if direction != Vector2.ZERO:
		#direction = direction.normalized()
		position += direction * speed * delta

@export var zoom_step := 0.1
@export var min_zoom := 0.5
@export var max_zoom := 3.0

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_set_zoom(zoom.x - zoom_step)
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			_set_zoom(zoom.x + zoom_step)

func _set_zoom(value: float) -> void:
	value = clamp(value, min_zoom, max_zoom)
	zoom = Vector2(value, value)
