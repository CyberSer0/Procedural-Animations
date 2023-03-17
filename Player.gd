extends CharacterBody3D

signal move_aimpoint(location)

@export var speed : float = 1
@export var gravity : float = 9.81


var HumanoidControlNode : Node3D

var lookingDirection : Vector3 = Vector3.ZERO
var target_velocity : Vector3 = Vector3.ZERO

var leftLegTarget : Node3D
var rightLegTarget : Node3D
var skeleton : Skeleton3D

###############################################################################
#								  FUNCTIONS									  #
###############################################################################

func _ready():
	
	GLOBALS.PLAYER = self
	
	$Model/root/Skeleton3D/LeftLegIK.start()
	$Model/root/Skeleton3D/RightLegIK.start()
	
	
func _physics_process(delta):
	lookingDirection = Vector3(	Input.get_action_strength("move_backwards") - Input.get_action_strength("move_forward"), 
								0.0, 
								Input.get_action_strength("move_left") - Input.get_action_strength("move_right"))

	if lookingDirection != Vector3.ZERO:
		lookingDirection = lookingDirection.normalized()
		look_at(position - lookingDirection, Vector3.UP)
	
	target_velocity.x = lookingDirection.x * speed
	target_velocity.z = lookingDirection.z * speed

	if not is_on_floor():
		target_velocity.y = target_velocity.y - (gravity * delta)
	
	velocity = target_velocity
	move_and_slide()


