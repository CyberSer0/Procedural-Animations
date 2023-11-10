extends Node3D

@export var OFFSET : float = 20.0

@onready var parent = get_parent_node_3d()
@onready var previous_position = parent.global_position

func _physics_process(delta):
	var velocity = parent.global_position - previous_position
	global_position = parent.global_position + velocity * OFFSET
	
	previous_position = parent.global_position
