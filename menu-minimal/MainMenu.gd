extends Spatial


const CAM_MOVEMENT = 0.015
const CAM_MOVEMENT_SMOOTHNESS = 0.05
const RAY_LEN = 10
const MENU_ITEMS_MASK_BIT = 4096 # layer 13, bit 12


onready var cam_pivot := $CamPivot
onready var cam := $CamPivot/Camera
var active_item : MenuItem_Party


func _unhandled_input(event: InputEvent) -> void:
	# on clicking a menu item
	if active_item and event.is_action_released("mouse_left_click"):
		# do something with it
		active_item.click()
		# don't forget to reset the mouse cursor
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
		# you might implement changing the scene here which is
		# currently implemented in the item itself, but …
		# you COULD do it here instead if you only wanted to ;-)
		# --> see also method documentation of MenuItem.click()


# warning-ignore:unused_argument
func _process(delta: float) -> void:
	# determine viewport size and mouse position for usage below
	var vp_size := get_viewport().get_visible_rect().size
	var mouse_pos = get_viewport().get_mouse_position()
	# avoid having mouse cursor coordinates outside the viewport
	mouse_pos.x = clamp(mouse_pos.x, 0, vp_size.x)
	mouse_pos.y = clamp(mouse_pos.y, 0, vp_size.y)

	# use mouse cursor position to do our actual menu stuff
	rotate_cam(mouse_pos, vp_size)
	control_menu_items(mouse_pos)


#
# Rotates the scene's camera around its pivot point
# depending on given mouse position and viewport size.
#
func rotate_cam(mouse_pos: Vector2, vp_size: Vector2) -> void:
	# get mouse position as seen from viewport center to use it for rotation calculation
	mouse_pos -= vp_size / 2

	# rotate camera around its pivot depending on mouse position
	cam_pivot.rotation_degrees.x = lerp(cam_pivot.rotation_degrees.x, mouse_pos.y * CAM_MOVEMENT, CAM_MOVEMENT_SMOOTHNESS)
	cam_pivot.rotation_degrees.y = lerp(cam_pivot.rotation_degrees.y, mouse_pos.x * CAM_MOVEMENT, CAM_MOVEMENT_SMOOTHNESS)


#
# Determines "mouse-over"/"mouse-out" for the menu items
# and activates their hovered respectively unhovered states.
#
func control_menu_items(mouse_pos: Vector2) -> void:
	# get menu item that the mouse cursor is over right now
	var item := get_hovered_menu_item(mouse_pos)

	# check if menu item isn't hovered any longer
	if active_item and active_item != item:
		active_item.unhover()
		active_item = null
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)

	# item is hovered and it's a new one that hasn't been hovered before
	if item and active_item != item:
		item.hover()
		active_item = item
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)


#
# Returns the menu item that's "under" the mouse cursor.
#
# Casts a ray from mouse cursor through camera to the 3D scene
# to determine the menu item being hovered by the mouse cursor.
#
func get_hovered_menu_item(mouse_pos: Vector2) -> MenuItem_Party:
	var ray_start : Vector3 = cam.project_ray_origin(mouse_pos)
	var ray_end : Vector3 = ray_start + cam.project_ray_normal(mouse_pos) * RAY_LEN
	var space_state : PhysicsDirectSpaceState = get_world().direct_space_state
	var result := space_state.intersect_ray(ray_start, ray_end, [], MENU_ITEMS_MASK_BIT)

	return result.collider.get_parent() if not result.empty() else null
