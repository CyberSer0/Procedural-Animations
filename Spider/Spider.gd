extends CharacterBody3D

@export var SPEED : float = 10.0

@export var STEP_DISTANCE : float = 2.0

var leg1_basepos : Vector3
var leg2_basepos : Vector3
var leg3_basepos : Vector3
var leg4_basepos : Vector3

func _ready():
	init_base_values()


func _physics_process(delta):
		velocity = Vector3(Input.get_axis("move_left", "move_right"), 0, Input.get_axis("move_forward", "move_backwards")) * SPEED
		move_and_slide()
		control_legs()
		print("Leg1: ", $Leg1Control.position, leg1_basepos, $Leg1Control.position.distance_to(leg1_basepos)) 

func control_legs():	
	if $Leg1Control.global_position.distance_to(global_position + leg1_basepos) > STEP_DISTANCE:
		step($Leg1Control, leg1_basepos)
#	elif abs(global_position.distance_to($Leg2Control.global_position) - global_position.distance_to($Leg2Control.global_position + leg2_basepos)) < 4:
#		step($Leg2Control, leg2_basepos)
#	if abs(global_position.distance_to($Leg3Control.global_position) - global_position.distance_to($Leg3Control.global_position + leg3_basepos)) < 4:
#		step($Leg3Control, leg3_basepos)
#	elif abs(global_position.distance_to($Leg4Control.global_position) - global_position.distance_to($Leg4Control.global_position + leg4_basepos)) < 4:
#		step($Leg4Control, leg4_basepos)

func step(control : Node, added_value : Vector3):
	var target = global_position + added_value
	var half_way = (control.global_position + target) / 2
	var t = get_tree().create_tween()
	
	t.tween_property(control, "global_position", half_way + owner.basis.y / 2, 0.1)
	t.tween_property(control, "global_position", target, 0.05)
	

func init_base_values():
	leg1_basepos = $Leg1Control.position
	leg2_basepos = $Leg2Control.position
	leg3_basepos = $Leg3Control.position
	leg4_basepos = $Leg4Control.position
