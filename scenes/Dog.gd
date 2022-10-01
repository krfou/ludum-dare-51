extends Area2D

export (int) var speed
var velocity := Vector2()
var screensize := Vector2(640, 360)
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
    print(texture_size.x, texture_size.y)
