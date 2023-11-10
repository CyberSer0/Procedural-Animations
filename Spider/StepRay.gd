extends RayCast3D

@export var STEP_TARGET : Node3D

func _physics_process(delta):
	var hit_point = get_collision_point()
	if hit_point:
		STEP_TARGET.global_position = hit_point
