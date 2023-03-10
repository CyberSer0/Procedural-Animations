extends Node3D

signal aimpoint_spawned(path : NodePath)

func _ready():
	if GLOBALS.PLAYER != null:
		connect("aimpoint_spawned", Callable(GLOBALS.PLAYER, "_on_aimpoint_spawned"))
	else:
		print("Could not connect signal at ", self, " - Player is null")
	emit_signal("aimpoint_spawned", get_path())
