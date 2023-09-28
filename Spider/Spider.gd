extends CharacterBody3D

@export var SPEED : float = 10.0


func _physics_process(delta):
	velocity = Vector3(Input.get_axis("move_left", "move_right"), 0, Input.get_axis("move_forward", "move_backwards")) * SPEED
	move_and_slide()
