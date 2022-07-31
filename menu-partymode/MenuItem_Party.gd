class_name MenuItem_Party
extends Spatial


const TRANSITION_DURATION = 0.2
const ROTATION_DURATION = TRANSITION_DURATION * 5


export(String, MULTILINE) var button_label: String
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
	$Label/Viewport/Label.text = button_label
	button.modulate = button_modulate_normal
	button.scale = button_scale_normal
	label.modulate = label_modulate_normal
	label.scale = label_scale_normal


func hover() -> void:
#	if button_rotate_hover:
#		$AudioStreamPlayer.stream = load("res://menu-partymode/hover.wav")
#		$AudioStreamPlayer.play()
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


func click() -> void:
	# randomly choose a click label
	var clicks := $ClickLabels.get_children()
	randomize()
	clicks.shuffle()
	var clicked: Sprite3D = clicks.pop_front()
	if clicked == last_clicked:
		clicked = clicks.pop_front()

	# show and fade out again
	clicked.opacity = 1
	clicked.show()
	var t: Tween = clicked.get_child(0)
	t.interpolate_property(clicked, "opacity", clicked.opacity, 0.0, .2, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	t.start()

	last_clicked = clicked

#	if button_rotate_hover:
#		$AudioStreamPlayer.stream = load("res://menu-partymode/click.wav")
#	else:
#		$AudioStreamPlayer.stream = load("res://menu-partymode/clicknormal.wav")
#	$AudioStreamPlayer.play()
