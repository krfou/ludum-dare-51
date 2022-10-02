extends Area2D



func _on_Cliffs_area_entered(area:Area2D):
    if area.is_in_group("sheeps"):
        area.fall()
    if area.is_in_group("dogs"):
        area.fall()
