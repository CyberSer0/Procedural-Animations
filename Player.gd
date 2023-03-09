extends CharacterBody3D

@export var speed : float = 300
@export var gravity : float = 9.81

var lookingDirection : Vector3 = Vector3.ZERO
var target_velocity : Vector3 = Vector3.ZERO

func _physics_process(delta):
	lookingDirection = Vector3(	Input.get_action_strength("move_backwards") - Input.get_action_strength("move_forward"), 
								0.0, 
								Input.get_action_strength("move_left") - Input.get_action_strength("move_right"))
	
	if lookingDirection != Vector3.ZERO:
		lookingDirection = lookingDirection.normalized()
		$Model.look_at(position + $Model.position + lookingDirection, Vector3.UP)
		$AimPoint.position = $Model.position + lookingDirection
	
	target_velocity.x = lookingDirection.x * speed
	target_velocity.z = lookingDirection.z * speed
	
	if not is_on_floor():
		target_velocity.y = target_velocity.y - (gravity * delta)
	
	velocity = target_velocity
	move_and_slide()
