extends Marker3D

var tps_toggle := false

func _unhandled_key_input(event):
	if Input.get_action_strength("tps_toggle"):
		tps_toggle = !tps_toggle

func _physics_process(delta):
	if GLOBALS.PLAYER:
		global_position = GLOBALS.PLAYER.global_position
	var dir = Input.get_axis("camera_move_forward", "camera_move_backwards")
	if dir > 0:
		$Camera3D.fov += 1
	elif dir < 0:
		$Camera3D.fov -= 1
		
#	translate(Vector3(0, 0, dir).rotated(Vector3.UP, deg_to_rad(45)) * delta)
	
	if !tps_toggle:
		var a_dir = Input.get_axis("camera_turn_left", "camera_turn_right")
		rotate_object_local(Vector3.UP, a_dir * delta)
	elif GLOBALS.PLAYER:
		rotation = GLOBALS.PLAYER.rotation
	
