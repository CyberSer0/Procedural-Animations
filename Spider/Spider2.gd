extends CharacterBody3D

@export_category("Handles")
@export var MAIN_BODY : Node3D
@export var CAM_H_PIVOT : Node3D
@export var CAM_V_PIVOT : Node3D

@export_category("Variables")
@export var MOVEMENT_SPEED : float = 5
@export var TURN_SPEED : float = 2.0
@export var GROUND_OFFSET : float = 2.25

@export_category("Leg targets")
@export var LEG1 : Marker3D
@export var LEG2 : Marker3D
@export var LEG3 : Marker3D
@export var LEG4 : Marker3D


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta):
	var plane1 = Plane(LEG1.global_position, LEG2.global_position, LEG3.global_position)
	var plane2 = Plane(LEG3.global_position, LEG4.global_position, LEG1.global_position)
	var avg_normal = ((plane1.normal + plane2.normal) / 2).normalized()
	
	var target_basis = _basis_from_normal(avg_normal)
	transform.basis = lerp(transform.basis, target_basis, MOVEMENT_SPEED * delta).orthonormalized()
	print(transform.basis)
	
	var avg = (LEG1.position + LEG2.position + LEG3.position + LEG4.position) / 4
	var target_position = avg + transform.basis.y * GROUND_OFFSET
	var distance = transform.basis.y.dot(target_position - position)
#	print(distance, "\t", transform.basis.y, "\t", target_position, "\t", position, "\t", target_position - position)
	position = lerp(position, position + transform.basis.y * distance, MOVEMENT_SPEED * delta)
	
	_handle_movement(delta)

	
func _input(event):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
		
	if event is InputEventMouseMotion:
		if Input.is_action_pressed("rotate_with_camera"):
			rotate(transform.basis.y, deg_to_rad(-event.relative.x * GLOBALS.MOUSE_SENS))
		else:
			CAM_H_PIVOT.rotate_object_local(transform.basis.y, deg_to_rad(-event.relative.x * GLOBALS.MOUSE_SENS))			
		CAM_V_PIVOT.rotate_object_local(CAM_V_PIVOT.transform.basis.x, deg_to_rad(-event.relative.y * GLOBALS.MOUSE_SENS))
#		CAM_V_PIVOT.rotation.x = clamp(CAM_V_PIVOT.rotation.x, deg_to_rad(-75), deg_to_rad(30))


func _handle_movement(delta):
	var dir = Input.get_axis("move_backwards", "move_forward")
	translate(Vector3(0, 0, -dir) * MOVEMENT_SPEED * delta)
	
	var a_dir = Input.get_axis("move_right", "move_left")
	rotate_object_local(Vector3.UP, a_dir * TURN_SPEED * delta)

func _basis_from_normal(normal: Vector3) -> Basis:
	var result = Basis()
	result.x = normal.cross(transform.basis.z)
	result.y = normal
	result.z = transform.basis.x.cross(normal)

	result = result.orthonormalized()
	result.x *= scale.x 
	result.y *= scale.y 
	result.z *= scale.z 
	
	return result


