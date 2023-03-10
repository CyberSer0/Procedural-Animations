extends CharacterBody3D

signal move_aimpoint(location)

@export var leftLegTargetPrefab = preload("res://left_leg_aim_point.tscn")
@export var rightLegTargetPrefab = preload("res://right_leg_aim_point.tscn")

@export var speed : float = 1
@export var gravity : float = 9.81

var HumanoidControlNode : Node3D

var lookingDirection : Vector3 = Vector3.ZERO
var target_velocity : Vector3 = Vector3.ZERO

var leftLegTarget : Node3D
var rightLegTarget : Node3D
var skeleton : Skeleton3D

##################################
#	0 - left leg
#	1 - right leg
##################################
var skeletonDictionary = {
	0 : "LeftLeg",
	1 : "RightLeg"
}
var skeletonDictionaryIterator : float = 0


###############################################################################
#								  FUNCTIONS									  #
###############################################################################


func _enter_tree():
	HumanoidControlNode = get_tree().get_root().get_node("HumanoidControl")


func _ready():
	
	GLOBALS.PLAYER = self
	
	$Model/root/Skeleton3D/LeftLegIK.start()
	$Model/root/Skeleton3D/RightLegIK.start()

	leftLegTarget = leftLegTargetPrefab.instantiate()
	rightLegTarget = rightLegTargetPrefab.instantiate()

	leftLegTarget.name = "LeftLegTarget"
	rightLegTarget.name = "RightLegTarget"
	
	HumanoidControlNode.add_child.call_deferred(leftLegTarget)
	HumanoidControlNode.add_child.call_deferred(rightLegTarget)
	
#	leftLegTarget = HumanoidControlNode.get_node("LeftLegTarget")
#	rightLegTarget = HumanoidControlNode.get_node("RightLegTarget")
#
#	get_node("Model/root/Skeleton3D/LeftLegIK").set_target_node(leftLegTarget.get_path())
#	get_node("Model/root/Skeleton3D/RightLegIK").set_target_node(rightLegTarget.get_path())
#	print("LL: ", leftLegTarget.global_position, " ", leftLegTarget.get_path(), "/")
#	print("RL: ", rightLegTarget.global_position, " ", rightLegTarget.get_path(), "/")
	
	


func _physics_process(delta):
	lookingDirection = Vector3(	Input.get_action_strength("move_backwards") - Input.get_action_strength("move_forward"), 
								0.0, 
								Input.get_action_strength("move_left") - Input.get_action_strength("move_right"))

	if lookingDirection != Vector3.ZERO:
		lookingDirection = lookingDirection.normalized()
		$Model.look_at(position + $Model.position - lookingDirection, Vector3.UP)

#	if leftLegTarget.ready:
#		if global_position.distance_to(leftLegTarget.global_position) < 1:
#			leftLegTarget.global_position = $Model.global_position + lookingDirection
#	if rightLegTarget.ready:
#		if global_position.distance_to(rightLegTarget.global_position) < 1:
#			rightLegTarget.global_position = $Model.global_position + lookingDirection

	
	target_velocity.x = lookingDirection.x * speed
	target_velocity.z = lookingDirection.z * speed

	if not is_on_floor():
		target_velocity.y = target_velocity.y - (gravity * delta)
	
	velocity = target_velocity
	move_and_slide()

# Weird get_node error relative to /root/HumanoidControl/LeftLegTarget/APModel
func _on_aimpoint_spawned(path : NodePath):
	match skeletonDictionaryIterator:
		0:
			leftLegTarget = HumanoidControlNode.get_node("LeftLegTarget")
			print("Hallo: ", leftLegTarget)
			get_node("Model/root/Skeleton3D/LeftLegIK").set_target_node(path)
		1:
			rightLegTarget = HumanoidControlNode.get_node("RightLegTarget")
			get_node("Model/root/Skeleton3D/RightLegIK").set_target_node(path)
		_:
			pass
	skeletonDictionaryIterator += 1
	pass
