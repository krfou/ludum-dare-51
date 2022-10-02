extends Area2D

export (int) var speed = 200
export (int) var collision_offset
var velocity := Vector2()
var screensize := Vector2()
var texture_size := Vector2()

onready var tween := get_node("Tween")

func get_input():
	velocity = Vector2.ZERO
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
		$AnimatedSprite.animation = "run"
	else:
		$AnimatedSprite.animation = "sit"
	if velocity.x < 0:
		$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.flip_h = false

func _process(delta: float) -> void:
	get_input()
	position += velocity * delta
	position.x = clamp(position.x,  texture_size.x / 4, screensize.x - texture_size.x / 4)
	position.y = clamp(position.y,  texture_size.y / 4, screensize.y - texture_size.y / 4)

func start(pos):
	set_process(true)
	position = pos


func _ready():
	var texture = $AnimatedSprite.frames.get_frame("run", 0)
	texture_size = texture.get_size()
	var sprite = get_node("AnimatedSprite")

	tween.interpolate_property(sprite, "scale", scale, Vector2.ZERO, 2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)

func _on_Dog_area_entered(area:Area2D):
	if area.is_in_group("sheeps"):
		area.is_scared(position)

func _move_collision_in_direction(direction: Vector2):
	$CollisionShape2D.position = direction * collision_offset

func fall():
	$AnimatedSprite.animation = "sit"
	tween.start()
	set_process(false)


func _on_DogLife_dog_death():
	var main = get_node("/root/Main")
	main.dog_is_alive = false
