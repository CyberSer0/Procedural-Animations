extends Node3D

@export var node_to_follow : Node

var start_offset : Vector3
var camera_anglev = 0

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * GLOBALS.MOUSE_SENS))

func _ready():
	start_offset = $Camera3D.global_position

func _physics_process(delta):
	if node_to_follow != null:
		$Camera3D.global_position = node_to_follow.global_position + start_offset
		
