extends Camera3D

@export var target: NodePath
@export var fposition: NodePath
@export var drift = 0.1 # (float, 0.001, 1.0)
var target_position

func _ready():
	position = get_node(fposition).to_global(get_node(fposition).position)
	target_position = get_node(target).to_global(get_node(target).position)
func _physics_process(delta):
	## make the camera drift into place behind the ship
	var goal_translation = get_node(fposition).to_global(get_node(fposition).position)
	var diff = goal_translation-position
	position = position.lerp(goal_translation, drift*diff.length())
	
	## after camera is in place make it rotate into place
	var new_position = get_node(target).to_global(get_node(target).position)
	var bas = get_node(target).global_transform.basis
	transform.basis.x = transform.basis.x.lerp(bas.x, drift)
	transform.basis.y = transform.basis.y.lerp(bas.y, drift)
	transform.basis.z = transform.basis.z.lerp(bas.z, drift)
	#diff = new_position-target_position
	#target_position = target_position.lerp(new_position, 0.1*drift*diff.length())
	#look_at(target_position, bas.y)
	
	
