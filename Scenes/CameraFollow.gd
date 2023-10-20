extends Camera3D

@export var node_to_follow : Node

var start_offset : Vector3

func _ready():
	start_offset = global_position

func _physics_process(delta):
	if node_to_follow != null:
		global_position = node_to_follow.global_position + start_offset
		
