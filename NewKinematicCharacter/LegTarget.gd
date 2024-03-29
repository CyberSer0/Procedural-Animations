extends Node3D

@export var step_target : Node3D
@export var step_distance : float

@onready var temp_rot : Vector3 = rotation
@onready var active_target : Node3D = step_target

var is_stepping : bool = false

func step():
	var target_pos = active_target.global_position
	var half_way = (global_position + active_target.global_position) / 2
	is_stepping = true
	rotation = temp_rot + GLOBALS.PLAYER.rotation
	var t = get_tree().create_tween()
	t.tween_property(self, "global_position", half_way + owner.basis.y - Vector3(0, 0.4, 0), 0.25)
	t.tween_property(self, "global_position", target_pos, 0.1)
	t.tween_callback(func(): is_stepping = false)
