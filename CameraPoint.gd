extends Marker3D

func _physics_process(delta):
	var dir = Input.get_axis("camera_move_forward", "camera_move_backwards")
	translate(Vector3(0, 0, dir).rotated(Vector3.UP, deg_to_rad(45)) * delta)
	
	var a_dir = Input.get_axis("camera_turn_left", "camera_turn_right")
	rotate_object_local(Vector3.UP, a_dir * delta)
	
	
