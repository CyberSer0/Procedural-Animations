extends CharacterBody3D

signal move_aimpoint(location)

@export var speed : float = 2.0
@export var gravity : float = 9.81
@export var turn_speed : float = 1.0

@export var rightIK : Node3D
@export var leftIK : Node3D

###############################################################################
#								  FUNCTIONS									  #
###############################################################################

func _ready():
	
	GLOBALS.PLAYER = self
	
	
	
func _physics_process(delta):
	var dir = Input.get_axis("move_backwards", "move_forward")
	translate(Vector3(0, 0, dir) * speed * delta)
	
#	doesn't work, need to change this
#	translate(Vector3(0, (rightIK.position.y - leftIK.position.y) / 2, 0) * delta)
	
	if (dir >= 0): 
		rightIK.active_target = rightIK.step_target
		leftIK.active_target = leftIK.step_target
	else: 
		rightIK.active_target = rightIK.backstep_target
		leftIK.active_target = leftIK.backstep_target
	
	var a_dir = Input.get_axis("move_right", "move_left")
	rotate_object_local(Vector3.UP, a_dir * turn_speed * delta)
	


