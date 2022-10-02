extends Area2D

signal dog_death


func fall():
    var dog = get_node("/root/Main/Dog")
    dog.fall()
    emit_signal("dog_death")