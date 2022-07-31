class_name MenuItem
extends Spatial


const TRANSITION_DURATION = 0.2
const ROTATION_DURATION = TRANSITION_DURATION * 5


export(String, MULTILINE) var button_label: String
export var scene_to_load: PackedScene

export var button_rotate_unhover := false
export var button_rotate_hover := true
export var button_modulate_normal := Color(2.0, 2.0, 2.0, 1)
export var button_modulate_hover := Color(2.2, 2.2, 2.2, 1)
export var button_scale_normal := Vector3(1.0, 1.0, 1.0)
export var button_scale_hover := Vector3(1.1, 1.1, 1.0)
export var label_modulate_normal := Color(1.8, 1.8, 1.8, 1)
export var label_modulate_hover := Color(2.0, 2.0, 2.0, 1)
export var label_scale_normal := Vector3(1.0, 1.0, 1.0)
export var label_scale_hover := Vector3(1.3, 1.3, 1.0)

onready var button := $Button
onready var label := $Label
onready var tween := $Tween

var last_clicked: Sprite3D


func _ready() -> void:
	button.modulate = button_modulate_normal
	button.scale = button_scale_normal
	label.modulate = label_modulate_normal
	label.scale = label_scale_normal
	label.get_child(0).get_child(0).text = button_label


func hover() -> void:
	transition_to(
		button_rotate_hover,
		button_modulate_hover,
		button_scale_hover,
		label_modulate_hover,
		label_scale_hover
	)


func unhover() -> void:
	transition_to(
		button_rotate_unhover,
		button_modulate_normal,
		button_scale_normal,
		label_modulate_normal,
		label_scale_normal
	)


func transition_to(button_rotate: bool, button_modulate: Color, button_scale: Vector3, label_modulate: Color, label_scale: Vector3) -> void:
	if button_rotate:
		var button_rotation := Vector3(0, 0, stepify(button.rotation_degrees.z - 180, 180))
		tween.interpolate_property(button, "rotation_degrees", button.rotation_degrees, button_rotation, ROTATION_DURATION, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	add_to_tween(button, button_modulate, button_scale)
	add_to_tween(label, label_modulate, label_scale)
	# warning-ignore:return_value_discarded
	tween.start()


func add_to_tween(sprite: Sprite3D, sprite_modulate: Color, sprite_scale: Vector3) -> void:
	# warning-ignore:return_value_discarded
	tween.interpolate_property(sprite, "scale", sprite.scale, sprite_scale, TRANSITION_DURATION, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	# warning-ignore:return_value_discarded
	tween.interpolate_property(sprite, "modulate", sprite.modulate, sprite_modulate, TRANSITION_DURATION, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)


#
# Does awesome stuff whenever this menu item is clicked.
#
func click() -> void:
	# this is where click sounds could be played
	# or some nice button animation is started
	# or whatever else you wanna make happen …

	# for example let's have an exported field
	# of type PackedScene (see above in line 10)
	# and use that one to start your game or to
	# load another submenu scene or whatever
	if scene_to_load:
		get_tree().change_scene_to(scene_to_load)

	# or let's simply print the menu item's name
	# just because we can and because real devs
	# don't use the built-in Debugger … Hell, no!
	# (I hope you get my sarcasm in that statement
	# 'cause debugging is awesome! Thus do it!)
	print("menu item for '%s' has been clicked" % name)
