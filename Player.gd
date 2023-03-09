extends CharacterBody3D

@export var speed : float = 300
@export var gravity : float = 9.81

var lookingDirection : Vector3 = Vector3.ZERO
var target_velocity : Vector3 = Vector3.ZERO

var i : float = 0

var leftLegTarget : Node3D
var rightLegTarget : Node3D

func _ready():
	$Model/root/Skeleton3D/LeftLegIK.start()
	$Model/root/Skeleton3D/RightLegIK.start()
	$Model/root/Skeleton3D/LeftLegIK.set_interpolation(0.2)
	$Model/root/Skeleton3D/RightLegIK.set_interpolation(0.2)
	
	leftLegTarget = get_node("LeftLegAimPoint")
	rightLegTarget = get_node("RightLegAimPoint")
	
	remove_child(leftLegTarget)
	get_parent().add_child(leftLegTarget)
	remove_child(rightLegTarget)
	get_parent().add_child(rightLegTarget)

func _process(delta):
	pass
#	i += 0.1 * delta
#	if i > 1:
#		i = 0


func _physics_process(delta):
	lookingDirection = Vector3(	Input.get_action_strength("move_backwards") - Input.get_action_strength("move_forward"), 
								0.0, 
								Input.get_action_strength("move_left") - Input.get_action_strength("move_right"))
	
	if lookingDirection != Vector3.ZERO:
		lookingDirection = lookingDirection.normalized()
		$Model.look_at(position + $Model.position - lookingDirection, Vector3.UP)
	
	if global_position.distance_to($LeftLegAimPoint.global_position) > 1:
		$LeftLegAimPoint.position = $Model.position + lookingDirection
	if global_position.distance_to($RightLegAimPoint.global_position) > 1:
		$RightLegAimPoint.position = $Model.position + lookingDirection
	
	print(global_position.distance_to($LeftLegAimPoint.global_position))
	
	target_velocity.x = lookingDirection.x * speed
	target_velocity.z = lookingDirection.z * speed
	
	if not is_on_floor():
		target_velocity.y = target_velocity.y - (gravity * delta)
	
	velocity = target_velocity
	move_and_slide()
