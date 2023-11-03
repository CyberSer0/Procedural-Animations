extends CharacterBody3D

@export var SPEED : float = 10.0
@export var ROTATION_SPEED : float = 2.0
@export var STEP_DISTANCE : float = 1.5
@export var MAIN_BODY : Node3D
@export var CAM_H_PIVOT : Node3D
@export var CAM_V_PIVOT : Node3D

var can_walk : bool = false

@onready var head_tweener : Tween = get_tree().create_tween()
@onready var velocity_tweener : Tween = get_tree().create_tween()

var velocity_intent : Vector3 = Vector3.ZERO

var forward_rays : Array
var backwards_rays : Array

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	forward_rays.append_array($LegForwardDetectors.get_children())
	backwards_rays.append_array($LegBackwardsDetectors.get_children())


func _input(event):
	if Input.get_axis("move_forward", "move_backwards") or Input.get_axis("move_right", "move_left") or Input.is_action_just_released("move_forward") or Input.is_action_just_released("move_backwards") or Input.is_action_just_released("move_left") or Input.is_action_just_released("move_right"):
		control_legs()
#		velocity_intent = MAIN_BODY.global_transform.basis.z * Input.get_axis("move_forward", "move_backwards") * SPEED
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
		
	if event is InputEventMouseMotion:
		if Input.is_action_pressed("rotate_with_camera"):
			rotate(transform.basis.y, deg_to_rad(-event.relative.x * GLOBALS.MOUSE_SENS))
		else:
			CAM_H_PIVOT.rotate(transform.basis.y, deg_to_rad(-event.relative.x * GLOBALS.MOUSE_SENS))			
		CAM_V_PIVOT.rotate(CAM_V_PIVOT.transform.basis.x, deg_to_rad(-event.relative.y * GLOBALS.MOUSE_SENS))
		CAM_V_PIVOT.rotation.x = clamp(CAM_V_PIVOT.rotation.x, deg_to_rad(-75), deg_to_rad(30))


func _physics_process(delta):
	if $GroundDetectorArea.get_overlapping_areas():
#		print($GroundDetectorArea.get_overlapping_areas())
		position += MAIN_BODY.global_transform.basis.y * delta
	else:
		pass
		position.y = Vector3.ZERO.distance_to(MAIN_BODY.global_transform.basis.y)
	velocity = MAIN_BODY.global_transform.basis.z * Input.get_axis("move_forward", "move_backwards") * SPEED
	rotation_degrees += MAIN_BODY.global_transform.basis.y * Input.get_axis("move_right", "move_left") * ROTATION_SPEED
#	print($Leg1Control.global_position.distance_to($Leg1Basepos.global_position))
	move_and_slide()
	

func control_legs():	
	if ($Leg1Control.global_position.distance_to(global_position + $Leg1Basepos.position) > STEP_DISTANCE or $Leg3Control.global_position.distance_to(global_position + $Leg3Basepos.position) > STEP_DISTANCE) and can_walk:
		can_walk = false
		step($Leg1Control, get_target_position($Leg1Basepos.global_position, forward_rays[0], backwards_rays[0]))
		step($Leg3Control, get_target_position($Leg3Basepos.global_position, forward_rays[2], backwards_rays[2]))
		step($Leg2Control, get_target_position($Leg2Basepos.global_position, forward_rays[1], backwards_rays[1]))
		step($Leg4Control, get_target_position($Leg4Basepos.global_position, forward_rays[3], backwards_rays[3]))
	elif $Leg2Control.global_position.distance_to(global_position + $Leg2Basepos.position) > STEP_DISTANCE or $Leg4Control.global_position.distance_to(global_position + $Leg4Basepos.position) > STEP_DISTANCE and can_walk: 
		can_walk = false
		step($Leg2Control, get_target_position($Leg2Basepos.global_position, forward_rays[1], backwards_rays[1]))
		step($Leg4Control, get_target_position($Leg4Basepos.global_position, forward_rays[3], backwards_rays[3]))
		step($Leg1Control, get_target_position($Leg1Basepos.global_position, forward_rays[0], backwards_rays[0]))
		step($Leg3Control, get_target_position($Leg3Basepos.global_position, forward_rays[2], backwards_rays[2]))
		
	if Input.get_axis("move_forward", "move_backwards") > 0:
		for ray in forward_rays:
			ray.enabled = true
		for ray in backwards_rays:
			ray.enabled = false
	elif Input.get_axis("move_forward", "move_backwards") < 0:
		for ray in forward_rays:
			ray.enabled = false
		for ray in backwards_rays:
			ray.enabled = true
		

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
		print("Base target: ", base_target)
		return base_target
	
