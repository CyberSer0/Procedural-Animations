extends RigidBody3D

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
	$PIDController._on_start_timer()


func _physics_process(delta):
	var inputZDir = Input.get_axis("move_backwards", "move_forward")
	var inputXDir = Input.get_axis("move_right", "move_left")
#	translate(Vector3(inputXDir, 0, inputZDi) * speed * delta)
	
	# redo this but with rotations (? not anymore ?)

	if (inputZDir > 0): 
		rightIK.active_target = rightIK.step_target
		leftIK.active_target = leftIK.step_target
	elif (inputZDir < 0): 
		rightIK.active_target = rightIK.backstep_target
		leftIK.active_target = leftIK.backstep_target
	elif (inputXDir > 0):
		rightIK.active_target = rightIK.sidestep_target
		leftIK.active_target = leftIK.sidestep_target
	elif (inputXDir < 0):
		rightIK.active_target = rightIK.backsidestep_target
		leftIK.active_target = leftIK.backsidestep_target

	

func _exit_tree():
	GLOBALS.PLAYER = null


func _integrate_forces(state):
	apply_torque_impulse(Vector3(   0.0,
									Input.get_axis("rotate_right", "rotate_left") * 0.01,
									0.0))
	
	apply_central_impulse((transform.basis.x * Input.get_axis("move_right", "move_left") + transform.basis.z * Input.get_axis("move_backwards", "move_forward")).normalized() / 100)
	
	if $FloorDetector.is_colliding():
		apply_central_force(Vector3(	0.0,
										$PIDController.calculate($FloorDetector.get_collision_point().y, global_position.y) * gravity * mass,
										0.0))
									
	
	
	
#	apply_central_force((Input.get_axis("move_backwards", "move_forward") * transform.basis.z + Input.get_axis("move_right", "move_left") * transform.basis.x) * speed)

