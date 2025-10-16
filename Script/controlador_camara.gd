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
		direction = direction.normalized()
		position += direction * speed * delta
