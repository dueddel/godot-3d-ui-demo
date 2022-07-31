extends Button


var menu_scene: PackedScene = load("res://menu-minimal/MainMenu.tscn")


func _on_Button_pressed() -> void:
	# warning-ignore:return_value_discarded
	get_tree().change_scene_to(menu_scene)
