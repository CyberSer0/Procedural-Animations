extends Camera3D

@export var ATTACHED_TO : Node3D:
	set(value):
		ATTACHED_TO = value
		if ATTACHED_TO:
			reparent(ATTACHED_TO)	
		print(ATTACHED_TO)

func _ready():
	if ATTACHED_TO:
		reparent(ATTACHED_TO.CAMERA_ARM)
		transform = ATTACHED_TO.PREFERRED_TRANSFORM
