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

#	if rightIK.is_stepping or leftIK.is_stepping:
#		var position_tween = get_tree().create_tween()
#		var flat_between := Vector2(rightIK.global_position.x, rightIK.global_position.z).lerp(Vector2(leftIK.global_position.x, leftIK.global_position.z), 0.5)
#		position_tween.tween_property(self, "global_position", Vector3(flat_between.x, self.global_position.y, flat_between.y), 1)


#	var a_dir = Input.get_axis("rotate_right", "rotate_left")
#	var finalAngle = a_dir * turn_speed;
#	rotate_object_local(Vector3.UP, finalAngle * delta)
#	forward facing rotation needs to be added
	

func _exit_tree():
	GLOBALS.PLAYER = null


func _integrate_forces(state):
	var target_position = global_position + Vector3(Input.get_axis("rotate_right", "rotate_left"), 0, 0) * transform.basis.y
#	look_follow(state, global_transform, target_position)
	apply_torque(Vector3(0.0, Input.get_axis("rotate_right", "rotate_left") * 0.1, 0.0))
	
	apply_torque(Vector3(   $PIDController.calculate(0, rotation_degrees.x),
							0.0,
							$PIDController.calculate(0, rotation_degrees.z)))
	
	apply_force(Vector3(	0.0,
							$PIDController.calculate(9.81, position.y),
							0.0))
	
	
#	apply_central_force((Input.get_axis("move_backwards", "move_forward") * transform.basis.z + Input.get_axis("move_right", "move_left") * transform.basis.x) * speed)

func look_follow(state : PhysicsDirectBodyState3D, current_transform : Transform3D, target_position):
	var up_direction = Vector3(0, 1, 0)
	var current_direction = current_transform.basis * Vector3(0, 0, 1)
	var target_dir = (target_position - current_transform.origin).normalized()
	var rotation_angle = acos(current_direction.y) - acos(target_dir.y)
	
	state.angular_velocity = up_direction * (rotation_angle / state.step)

