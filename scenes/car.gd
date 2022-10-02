extends Area2D

var screensize := Vector2()

onready var sprite := get_node("AnimatedSprite")
onready var tween := get_node("Tween")

onready var start_go_position := get_node("RedCarStartGo")
onready var arrived_go_position := get_node("RedCarArrivedGo")

onready var start_return_position := get_node("RedCarStartReturn")
onready var arrived_return_position := get_node("RedCarArrivedReturn")

var is_arrived_to_bottom_left := false
var is_arrived_to_top_right := true

func lets_go():
	self.show()
	#if not is_arrived_to_bottom_left and is_arrived_to_top_right:
	# Go from top_right to bottom_left
	tween.interpolate_property(self, "position", start_go_position.position, arrived_go_position.position, 3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	is_arrived_to_bottom_left = true
	is_arrived_to_top_right = false
	$Tween.start()
	#else:
		#tween.interpolate_property(self, "position", start_return_position.position, arrived_return_position.position, 4, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		#is_arrived_to_bottom_left = false
		#is_arrived_to_top_right = true
		#$Tween.start()

func to_bottom_left():
	pass

func to_top_right():
	pass

func _ready():
	pass


func _on_Car_area_entered(area: Area2D):
	if area.is_in_group("sheeps"):
		area.die()
	if area.is_in_group("dogs"):
		area.fall()
