extends Area2D

export (int) var speed
var velocity = Vector2()
var screensize = Vector2()

func run_away():
    velocity.x += 1


func _process(delta: float) -> void:
    position += velocity * delta
    position.x = clamp(position.x, 0, screensize.x)
    position.y = clamp(position.y, 0, screensize.y)
