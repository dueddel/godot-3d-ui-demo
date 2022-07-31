extends Spatial


const RAY_LEN = 10
const MENU_ITEMS_MASK_BIT = 4096 # layer 13, bit 12


onready var cam_pivot := $CamPivot
onready var cam := $CamPivot/Camera
var active_item : MenuItem_Party


func _ready() -> void:
	OS.set_window_title("Why bothering with UI nodes if you could build a game's menu in 3D?")
#	$Party/AudioStreamPlayer3.stream = load("res://menu-partymode/bgm.wav")
#	$Party/AudioStreamPlayer3.play()


func _unhandled_input(event: InputEvent) -> void:
	if active_item and event.is_action_released("mouse_left_click"):
		active_item.click()
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
		return

	if event.is_action_pressed("party_mode"):
		$Party.visible = not $Party.visible
		$Partycles.emitting = $Party.visible
		for item in $MenuItems.get_children():
			if $Party.visible:
				party(item)
			else:
				unparty(item)
		if $Party.visible:
#			$Party/AudioStreamPlayer.stream = load("res://menu-partymode/party.wav")
#			$Party/AudioStreamPlayer.play()
#			$Party/AudioStreamPlayer2.stream = load("res://menu-partymode/party2.wav")
#			$Party/AudioStreamPlayer2.play()
#			$Party/AudioStreamPlayer3.stream = load("res://menu-partymode/party3.wav")
#			$Party/AudioStreamPlayer3.play()
			$Unparty.hide()
			OS.set_window_title("WHOOP! WHOOOOP!!")
		else:
#			$Party/AudioStreamPlayer.stream = load("res://menu-partymode/unparty.wav")
#			$Party/AudioStreamPlayer.play()
#			$Party/AudioStreamPlayer2.stream = load("res://menu-partymode/unparty2.wav")
#			$Party/AudioStreamPlayer2.play()
#			$Party/AudioStreamPlayer3.stream = load("res://menu-partymode/unparty3.wav")
#			$Party/AudioStreamPlayer3.play()
			$Unparty.show()
			var t: Tween = $Unparty/Tween
			# warning-ignore:return_value_discarded
			t.interpolate_property($Unparty, "opacity", $Unparty.opacity, 0.0, 4, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 2)
			# warning-ignore:return_value_discarded
			t.start()
			OS.set_window_title("Kinda boring out of a sudden, heh?")


func party(item: MenuItem_Party) -> void:
	item.button_rotate_hover = true
	item.button_modulate_normal = Color(2.0, 2.0, 1.0, 1)
	item.button_modulate_hover = Color(3, 3, 0.5, 1)
	item.button_scale_normal = Vector3(1.0, 1.0, 1.0)
	item.button_scale_hover = Vector3(1.1, 1.1, 1.0)
	item.label_modulate_normal = Color(1.8, 1.8, 1.8, 1)
	item.label_modulate_hover = Color(4, 4, 4, 1)
	item.label_scale_normal = Vector3(1.0, 1.0, 1.0)
	item.label_scale_hover = Vector3(1.3, 1.3, 1.0)
	item.button.modulate = item.button_modulate_normal

func unparty(item: MenuItem_Party) -> void:
	item.button_rotate_hover = false
	item.button_modulate_normal = Color(2.0, 2.0, 2.0, 1)
	item.button_modulate_hover = Color(2.2, 2.2, 2.2, 1)
	item.button_scale_normal = Vector3(1.0, 1.0, 1.0)
	item.button_scale_hover = Vector3(1.1, 1.1, 1.0)
	item.label_modulate_normal = Color(1.8, 1.8, 1.8, 1)
	item.label_modulate_hover = Color(2.0, 2.0, 2.0, 1)
	item.label_scale_normal = Vector3(1.0, 1.0, 1.0)
	item.label_scale_hover = Vector3(1.3, 1.3, 1.0)
	item.button.modulate = item.button_modulate_normal


# warning-ignore:unused_argument
func _process(delta: float) -> void:
	# determine viewport size and mouse position
	var vp_size := get_viewport().get_visible_rect().size
	var mouse_pos = get_viewport().get_mouse_position()
	mouse_pos.x = clamp(mouse_pos.x, 0, vp_size.x)
	mouse_pos.y = clamp(mouse_pos.y, 0, vp_size.y)

	rotate_cam(mouse_pos, vp_size)
	control_menu_items(mouse_pos)


func rotate_cam(mouse_pos: Vector2, vp_size: Vector2) -> void:
	# get mouse position as seen from viewport center
	mouse_pos -= vp_size / 2

	# rotate camera around its pivot depending on mouse position
	cam_pivot.rotation_degrees.x = lerp(cam_pivot.rotation_degrees.x, mouse_pos.y * 0.015, 0.05)
	cam_pivot.rotation_degrees.y = lerp(cam_pivot.rotation_degrees.y, mouse_pos.x * 0.015, 0.05)


func control_menu_items(mouse_pos: Vector2) -> void:
	var item := get_hovered_menu_item(mouse_pos)

	if active_item and active_item != item:
		active_item.unhover()
		active_item = null
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)

	if item:
		if active_item != item:
			item.hover()
			active_item = item
			Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)


func get_hovered_menu_item(mouse_pos: Vector2) -> MenuItem_Party:
	var ray_start : Vector3 = cam.project_ray_origin(mouse_pos)
	var ray_end : Vector3 = ray_start + cam.project_ray_normal(mouse_pos) * RAY_LEN
	var space_state : PhysicsDirectSpaceState = get_world().direct_space_state
	var result := space_state.intersect_ray(ray_start, ray_end, [], MENU_ITEMS_MASK_BIT)

	return result.collider.get_parent() if not result.empty() else null
