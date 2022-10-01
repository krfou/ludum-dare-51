extends Area2D

export (int) var speed = 200
export (int) var collision_offset
var velocity := Vector2()
var screensize := Vector2()
var texture_size := Vector2()

signal spook

func get_input():
	velocity = Vector2.ZERO
	if not velocity:
		$AnimatedSprite.animation = "sit"
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if velocity.length() > 0:
		_move_collision_in_direction(velocity)
		velocity = velocity.normalized() * speed
		$AnimatedSprite.animation = "default"
	if velocity.x < 0:
		$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.flip_h = false

func _process(delta: float) -> void:
	get_input()
	position += velocity * delta
	position.x = clamp(position.x, texture_size.x / 2, screensize.x - texture_size.x / 2)
	position.y = clamp(position.y, texture_size.y / 2, screensize.y - texture_size.y / 2)

func start(pos):
	set_process(true)
	position = pos


func _ready():
	var texture = $AnimatedSprite.frames.get_frame("default", 0)
	texture_size = texture.get_size()

func _on_Dog_area_entered(area:Area2D):
	if area.is_in_group("sheeps"):
		area.is_scared(position, speed)
		emit_signal("spook")

func _move_collision_in_direction(direction: Vector2):
	$CollisionShape2D.position = direction * collision_offset
