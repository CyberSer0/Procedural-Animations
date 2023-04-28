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
	var inputZDir = Input.get_axis("move_backwards", "move_forward")
	var inputXDir = Input.get_axis("move_right", "move_left")
#	translate(Vector3(inputXDir, 0, inputZDi) * speed * delta)
	
	# redo this but with rotations

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


	var a_dir = Input.get_axis("rotate_right", "rotate_left")
	rotate(Vector3.UP, a_dir * turn_speed * delta)

#	forward facing rotation needs to be added
	
	velocity = Vector3(inputXDir, 0, inputZDir).normalized() * speed
	move_and_slide()


func _exit_tree():
	GLOBALS.PLAYER = null

