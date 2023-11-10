extends Marker3D


@export_category("Step variables")
@export var STEP_TARGET : Node3D
@export var STEP_DISTANCE : float = 2.5

@export_category("Targets")
@export var ADJACENT_TARGET : Node3D
@export var OPPOSITE_TARGET : Node3D

var is_stepping : bool = false

func _process(delta):
	if !is_stepping && !ADJACENT_TARGET.is_stepping && abs(global_position.distance_to(STEP_TARGET.global_position)) > STEP_DISTANCE:
		step()
		OPPOSITE_TARGET.step()
		

func step():
	var target_position = STEP_TARGET.global_position
	var half_way = (global_position + STEP_TARGET.global_position) / 2
	is_stepping = true
	
	var tweener = get_tree().create_tween()
	tweener.tween_property(self, "global_position", half_way + owner.basis.y, 0.1)
	tweener.tween_property(self, "global_position", target_position, 0.1)
	tweener.tween_callback(func(): is_stepping = false)
