extends Node

export (PackedScene) var Sheep
export (int) var sheep_number
export (int) var playtime

var score
var time_left
var screensize
var playing = false

func _ready():
	randomize()
	screensize = get_viewport().get_visible_rect().size
	$Dog.screensize = screensize
	new_game()

func new_game():
	playing = true
	score = 0
	time_left = playtime
	$Dog.start($DogStart.position)
	$Dog.show()
	$GameTimer.start()
	spawn_sheeps()


func spawn_sheeps():
	for _i in range(0, sheep_number):
		var s = Sheep.instance()
		$Sheeps.add_child(s)
		s.screensize = screensize
		s.position = Vector2(
			rand_range(100, screensize.x - 100),
			rand_range(100, screensize.y - 100)
		)
