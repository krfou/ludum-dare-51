extends Area2D
export (int) var wanted_speed = 100

var speed: int
onready var max_speed :int = wanted_speed * 3
var velocity := Vector2()
var screensize := Vector2()
var texture_size := Vector2()

var is_alive := true
var is_running_away := false

signal sheep_death

# position du mouton moins position du chien dans vecteur

onready var move_timer := $MoveTimer as Timer
onready var sprite := get_node("AnimatedSprite")


func is_scared(dog_position: Vector2) -> void:
	var run_away_vector = Vector2(position.x - dog_position.x, position.y - dog_position.y)
	is_running_away = true
	velocity = velocity + run_away_vector
	speed = clamp(speed * 3, wanted_speed, max_speed)


func _process(delta: float) -> void:

	if not is_alive:
		pass
	elif is_running_away:
		_run_away(delta)
	else:
		_move(delta)


func _generate_move() -> void:
	randomize()
	move_timer.wait_time = int(rand_range(1, 2))
	# faire en sorte que les moutons mange 50% du temps
	if rand_range(0, 1) > 0.5:
		velocity.x = int(randi()%3 - 1)
		velocity.y = int(randi()%3 - 1)
	else:
		velocity = Vector2.ZERO
	move_timer.start()

func _on_timer_timeout():
	_generate_move()

func _move(delta):
	position += velocity * delta
	speed = clamp(speed * 0.99, wanted_speed, max_speed)
	if velocity.length() > 0:
		$AnimatedSprite.animation = "leap"
		#le mouton fait demi-tour au lieu de rester collé au mur
		if position.x > screensize.x - texture_size.x / 2 or position.x < 0 + texture_size.x / 2:
			velocity.x = -velocity.x
		if position.y > screensize.y - texture_size.y / 2 or position.y < 0 + texture_size.y / 2:
			velocity.y = -velocity.y
		velocity = velocity.normalized() * speed
	else:
		$AnimatedSprite.animation = "eat"
	if velocity.x < 0:
		$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.flip_h = false

func _run_away(delta: float):
	position += velocity * delta
	if position.x > screensize.x or position.x < 0:
		die()
	if position.y > screensize.y or position.y < 0:
		die()
	velocity = velocity.normalized() * speed
	if velocity.x < 0:
		$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.flip_h = false
	is_running_away = false


func die():
	$AnimatedSprite.animation = "dead"
	$CollisionShape2D.set_deferred("disabled", true)
	self.is_alive = false
	emit_signal("sheep_death")

func fall():
	$AnimatedSprite.animation = "fall"
	var current_scale = self.scale.x
	$Tween.start()
	$CollisionShape2D.set_deferred("disabled", true)
	self.is_alive = false
	emit_signal("sheep_death")


func _ready():
	position = Vector2(200, 200)
	move_timer.wait_time = int(rand_range(1, 4))
	move_timer.start()
	move_timer.connect("timeout", self, "_on_timer_timeout")
	var texture = $AnimatedSprite.frames.get_frame("leap", 0)
	texture_size = texture.get_size()
	$AnimatedSprite.animation = "eat"
	var tween = get_node("Tween")
	tween.interpolate_property(sprite, "scale", scale, Vector2.ZERO, 2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_property(sprite, "position", Vector2.ZERO, position, 2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
