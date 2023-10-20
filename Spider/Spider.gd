extends CharacterBody3D

signal front_collision_detected

@export var SPEED : float = 10.0
@export var ROTATION_SPEED : float = 2.0

@export var STEP_DISTANCE : float = 1.5

@export var MAIN_BODY : Node3D

var can_walk : bool = false

@onready var head_tweener : Tween = get_tree().create_tween()

#func _ready():
#	front_collision_detected.connect(on_head_collision_detected(Vector3.ZERO))

func _input(event):
	if Input.get_axis("move_forward", "move_backwards") or Input.get_axis("move_right", "move_left") or Input.is_action_just_released("move_forward") or Input.is_action_just_released("move_backwards") or Input.is_action_just_released("move_left") or Input.is_action_just_released("move_right"):
		control_legs()
	
#	if $Detectors/F_RayHead.is_colliding and Input.get_axis("move_forward", "move_backwards") > 0:
#		emit_sgnal("front_collision_detected", -$Detectors/F_RayHead.get_collision_normal)


func _physics_process(delta):
	velocity = MAIN_BODY.global_transform.basis.z * Input.get_axis("move_forward", "move_backwards") * SPEED
	rotation_degrees += MAIN_BODY.global_transform.basis.y * Input.get_axis("move_right", "move_left") * ROTATION_SPEED
	move_and_slide()
	

func control_legs():	
	if ($Leg1Control.global_position.distance_to(global_position + $Leg1Basepos.position) > STEP_DISTANCE or $Leg3Control.global_position.distance_to(global_position + $Leg3Basepos.position) > STEP_DISTANCE) and can_walk:
		can_walk = false
		step($Leg1Control, $Leg1Basepos.global_position)
		step($Leg3Control, $Leg3Basepos.global_position)
		step($Leg2Control, $Leg2Basepos.global_position)
		step($Leg4Control, $Leg4Basepos.global_position)
	elif $Leg2Control.global_position.distance_to(global_position + $Leg2Basepos.position) > STEP_DISTANCE or $Leg4Control.global_position.distance_to(global_position + $Leg4Basepos.position) > STEP_DISTANCE: 
		can_walk = false
		step($Leg2Control, $Leg2Basepos.global_position)
		step($Leg4Control, $Leg4Basepos.global_position)
		step($Leg1Control, $Leg1Basepos.global_position)
		step($Leg3Control, $Leg3Basepos.global_position)

func step(control : Node, target_value : Vector3):
	var half_way = (control.global_position + target_value) / 2
	var t = get_tree().create_tween()
	t.tween_property(control, "global_position", half_way + owner.basis.y / 2, 0.1)
	t.tween_property(control, "global_position", target_value, 0.1)
	t.tween_callback(set_can_walk)
	

func set_can_walk():
	can_walk = true
	

#func on_head_collision_detected(new_facing_direction : Vector3):
#	head_tweener.tween_property(MAIN_BODY, "rotation", rotation, new_facing_direction.rotated(MAIN_BODY.global_transform.basis.x, 90))
