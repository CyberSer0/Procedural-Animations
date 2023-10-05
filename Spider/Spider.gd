extends CharacterBody3D

@export var SPEED : float = 10.0
@export var ROTATION_SPEED : float = 2.0

@export var STEP_DISTANCE : float = 1.5

var is_leg1_moving : bool = false
var is_leg2_moving : bool = false
var is_leg3_moving : bool = false
var is_leg4_moving : bool = false



func _physics_process(delta):
#	print($Leg1Control.global_position.distance_to(global_position + $Leg1Basepos.position))
	velocity = global_transform.basis.z * Input.get_axis("move_forward", "move_backwards") * SPEED
	rotation_degrees += global_transform.basis.y * Input.get_axis("move_right", "move_left") * ROTATION_SPEED
	move_and_slide()
	relocate_basepositions()
	control_legs()
	

func relocate_basepositions():
	if $Detectors/F_RayLeg1.is_colliding():
		$Leg1Basepos.global_position = $Detectors/F_RayLeg1.get_collision_point()
	if $Detectors/F_RayLeg2.is_colliding():
		$Leg2Basepos.global_position = $Detectors/F_RayLeg2.get_collision_point()
	if $Detectors/F_RayLeg3.is_colliding():
		$Leg3Basepos.global_position = $Detectors/F_RayLeg3.get_collision_point()
	if $Detectors/F_RayLeg4.is_colliding():
		$Leg4Basepos.global_position = $Detectors/F_RayLeg4.get_collision_point()
		
#	if $Detectors/B_RayLeg1.is_colliding():
#		$Leg1Basepos.global_position = $Detectors/B_RayLeg1.get_collision_point()
#	if $Detectors/B_RayLeg2.is_colliding():
#		$Leg2Basepos.global_position = $Detectors/B_RayLeg2.get_collision_point()
#	if $Detectors/B_RayLeg3.is_colliding():
#		$Leg3Basepos.global_position = $Detectors/B_RayLeg3.get_collision_point()
#	if $Detectors/B_RayLeg4.is_colliding():
#		$Leg4Basepos.global_position = $Detectors/B_RayLeg4.get_collision_point()


func control_legs():	
	if $Leg1Control.global_position.distance_to(global_position + $Leg1Basepos.position) > STEP_DISTANCE or $Leg3Control.global_position.distance_to(global_position + $Leg3Basepos.position) > STEP_DISTANCE:
		step($Leg1Control, $Leg1Basepos.global_position, is_leg1_moving)
		step($Leg3Control, $Leg3Basepos.global_position, is_leg3_moving)
	elif $Leg2Control.global_position.distance_to(global_position + $Leg2Basepos.position) > STEP_DISTANCE or $Leg4Control.global_position.distance_to(global_position + $Leg4Basepos.position) > STEP_DISTANCE: 
		step($Leg2Control, $Leg2Basepos.global_position, is_leg2_moving)
		step($Leg4Control, $Leg4Basepos.global_position, is_leg4_moving)

func step(control : Node, target_value : Vector3, is_leg_moving : bool):
	var half_way = (control.global_position + target_value) / 2
	var t = get_tree().create_tween()
#	print("Leg1: ", is_leg1_moving, "\t| Leg2: ", is_leg2_moving, "\t| Leg3: ", is_leg3_moving, "\t| Leg4: ", is_leg4_moving)
	t.tween_property(control, "global_position", half_way + owner.basis.y / 2, 0.1)
	t.tween_property(control, "global_position", target_value, 0.1)

	
