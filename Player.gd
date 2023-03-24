extends CharacterBody3D

signal move_aimpoint(location)

@export var speed : float = 2.0
@export var gravity : float = 9.81
@export var turn_speed : float = 1.0

###############################################################################
#								  FUNCTIONS									  #
###############################################################################

func _ready():
	
	GLOBALS.PLAYER = self
	
	
	
func _physics_process(delta):
	var dir = Input.get_axis("move_forward", "move_backwards")
	translate(Vector3(0, 0, -dir) * speed * delta)
	
	var a_dir = Input.get_axis("move_right", "move_left")
	rotate_object_local(Vector3.UP, a_dir * turn_speed * delta)
	


