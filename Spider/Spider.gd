extends CharacterBody3D

@export var SPEED : float = 10.0
@export var ROTATION_SPEED : float = 2.0

@export var STEP_DISTANCE : float = 1.5

@export var MAIN_BODY : Node3D

var can_walk : bool = false

@onready var head_tweener : Tween = get_tree().create_tween()
@onready var velocity_tweener : Tween = get_tree().create_tween()

var velocity_intent : Vector3 = Vector3.ZERO


func _input(event):
	if Input.get_axis("move_forward", "move_backwards") or Input.get_axis("move_right", "move_left") or Input.is_action_just_released("move_forward") or Input.is_action_just_released("move_backwards") or Input.is_action_just_released("move_left") or Input.is_action_just_released("move_right"):
		control_legs()
#		velocity_intent = MAIN_BODY.global_transform.basis.z * Input.get_axis("move_forward", "move_backwards") * SPEED


func _physics_process(delta):
	velocity = MAIN_BODY.global_transform.basis.z * Input.get_axis("move_forward", "move_backwards") * SPEED
	rotation_degrees += MAIN_BODY.global_transform.basis.y * Input.get_axis("move_right", "move_left") * ROTATION_SPEED
	move_and_slide()
	

func control_legs():	
	if ($Leg1Control.global_position.distance_to(global_position + $Leg1Basepos.position) > STEP_DISTANCE or $Leg3Control.global_position.distance_to(global_position + $Leg3Basepos.position) > STEP_DISTANCE) and can_walk:
		can_walk = false
		step($Leg1Control, get_target_position($Leg1Basepos.global_position, $Detectors/F_RayLeg1, $Detectors/B_RayLeg1))
		step($Leg3Control, get_target_position($Leg3Basepos.global_position, $Detectors/F_RayLeg3, $Detectors/B_RayLeg3))
		step($Leg2Control, get_target_position($Leg2Basepos.global_position, $Detectors/F_RayLeg2, $Detectors/B_RayLeg2))
		step($Leg4Control, get_target_position($Leg4Basepos.global_position, $Detectors/F_RayLeg4, $Detectors/B_RayLeg4))
	elif $Leg2Control.global_position.distance_to(global_position + $Leg2Basepos.position) > STEP_DISTANCE or $Leg4Control.global_position.distance_to(global_position + $Leg4Basepos.position) > STEP_DISTANCE: 
		can_walk = false
		step($Leg2Control, get_target_position($Leg2Basepos.global_position, $Detectors/F_RayLeg2, $Detectors/B_RayLeg2))
		step($Leg4Control, get_target_position($Leg4Basepos.global_position, $Detectors/F_RayLeg4, $Detectors/B_RayLeg4))
		step($Leg1Control, get_target_position($Leg1Basepos.global_position, $Detectors/F_RayLeg1, $Detectors/B_RayLeg1))
		step($Leg3Control, get_target_position($Leg3Basepos.global_position, $Detectors/F_RayLeg3, $Detectors/B_RayLeg3))
		
	if Input.get_axis("move_forward", "move_backwards") > 0:
		$Detectors/B_RayLeg1.enabled = false
		$Detectors/B_RayLeg2.enabled = false
		$Detectors/B_RayLeg3.enabled = false
		$Detectors/B_RayLeg4.enabled = false
		$Detectors/F_RayLeg1.enabled = true
		$Detectors/F_RayLeg2.enabled = true
		$Detectors/F_RayLeg3.enabled = true
		$Detectors/F_RayLeg4.enabled = true
	elif Input.get_axis("move_forward", "move_backwards") < 0:
		$Detectors/F_RayLeg1.enabled = false
		$Detectors/F_RayLeg2.enabled = false
		$Detectors/F_RayLeg3.enabled = false
		$Detectors/F_RayLeg4.enabled = false
		$Detectors/B_RayLeg1.enabled = true
		$Detectors/B_RayLeg2.enabled = true
		$Detectors/B_RayLeg3.enabled = true
		$Detectors/B_RayLeg4.enabled = true
#	else:
#		$Detectors/B_RayLeg1.enabled = false
#		$Detectors/B_RayLeg2.enabled = false
#		$Detectors/B_RayLeg3.enabled = false
#		$Detectors/B_RayLeg4.enabled = false
#		$Detectors/F_RayLeg1.enabled = false
#		$Detectors/F_RayLeg2.enabled = false
#		$Detectors/F_RayLeg3.enabled = false
#		$Detectors/F_RayLeg4.enabled = false
		

func step(control : Node, target_value : Vector3):
	var half_way = (control.global_position + target_value) / 2
	var t = get_tree().create_tween()
	t.tween_property(control, "global_position", half_way + owner.basis.y / 2, 0.1)
	t.tween_property(control, "global_position", target_value, 0.1)
	

func set_can_walk():
	can_walk = true
	
#func on_head_collision_detected(is_colliding : bool):
#	if is_colliding:
#		head_tweener.tween_property(MAIN_BODY, "rotation", rotation, )

func get_target_position(base_target : Vector3, forward_ray : RayCast3D, backwards_ray : RayCast3D):
	if forward_ray.is_colliding and !backwards_ray.is_colliding:
		print("Forward ray: ", forward_ray.get_collision_point())
		return forward_ray.get_collision_point()
	elif backwards_ray.is_colliding and !forward_ray.is_colliding:
		print("Backwards ray: ", backwards_ray.get_collision_point())
		return backwards_ray.get_collision_point()
	else: 
		print("Base target: ", backwards_ray.get_collision_point())
		return base_target
	
