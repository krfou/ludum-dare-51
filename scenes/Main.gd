extends Node

export (PackedScene) var Sheep
export (int) var sheep_number

export (PackedScene) var RigidSheep
export (int) var rigid_sheep_number

export (PackedScene) var Car
export (int) var car_number

export (int) var playtime

var dog_is_alive = true

var score
var screensize
var playing = false
var dead_sheeps = 0

func _ready():
	randomize()
	$GameOver.hide()
	screensize = get_viewport().get_visible_rect().size
	$Dog.screensize = screensize
	$RedCar.screensize = screensize
	new_game()

func new_game():
	playing = true
	score = 0
	$Dog.start($DogStart.position)
	$Dog.show()
	$GameTimer.wait_time = 10 # à remetre a 10
	$GameTimer.connect("timeout", self, "_on_GameTimer_timeout")
	$GameTimer.start()
	spawn_sheeps()
	spawn_rigid_sheeps()


func spawn_sheeps():
	for _i in range(0, sheep_number):
		var s = Sheep.instance()
		$Sheeps.add_child(s)
		s.connect("sheep_death", self, "_on_Sheep_sheep_death")
		s.screensize = screensize
		s.position = Vector2(
			rand_range(100, screensize.x - 100),
			rand_range(100, screensize.y - 100)
		)

func spawn_rigid_sheeps():
	for _i in range(0, rigid_sheep_number):
		var rs = RigidSheep.instance()
		$RigidSheeps.add_child(rs)
		rs.screensize = screensize
		rs.position = Vector2(
			rand_range(100, screensize.x - 100),
			rand_range(100, screensize.y - 100)
		)

func _on_GameTimer_timeout():
	$RedCar.lets_go()


func _on_Sheep_sheep_death():
	var dead_counter_display = get_node("/root/Main/RichTextLabel")
	dead_sheeps += 1
	dead_counter_display.text = str(sheep_number - dead_sheeps) + " remaining sheeps"


func _on_DogLife_dog_death():
	$GameOver.show()

func _process(delta):
	if sheep_number - dead_sheeps == 0:
		$GameOver.show()

	if not dog_is_alive:
		$GameOver.show()
