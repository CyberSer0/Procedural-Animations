extends CharacterBody3D


const SPEED : float = 2.5
const JUMP_VELOCITY : float = 4.5
var floor_detector : RayCast3D

# flag for standing, crouching, proning etc.
var movement_state : int = 0

var gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready():
	GLOBALS.PLAYER = self
	floor_detector = $FloorDetector

func _physics_process(delta):
	### === MOVEMENT === ###
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var movement_direction = (transform.basis * Vector3(Input.get_axis("move_right", "move_left"), 0, Input.get_axis("move_backwards", "move_forward"))).normalized()
	if movement_direction:
		velocity.x = movement_direction.x * SPEED
		velocity.z = movement_direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	

	if floor_detector.is_colliding() and floor_detector.get_collision_point().distance_to(floor_detector.global_position) < 0.7:
			velocity.y = 0

	move_and_slide()
	### === ======== === ###


func _exit_tree():
	GLOBALS.PLAYER = null
