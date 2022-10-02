extends Area2D

func fall():
    var dog = get_node("/root/Main/Dog")
    dog.fall()