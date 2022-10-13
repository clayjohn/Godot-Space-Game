extends CharacterBody3D

var pvelocity = Vector3(0.0, 0.0, 0.0)
var mouse = Vector2(0.0, 0.0)
var dir = Vector3(0.0, 0.0, 0.0)
var damping = 1.0
var proximity = 1.0

@export var acceleration_rate = 0.1
@export var thrust_rate = 5.0
#turn speed should decrease as the ship reaches max speed
@export var turn_speed = 0.00005 # (float, 0.000001, 0.0001)
@export var max_speed = 20.0
@export var movement_type = "freelancer" # (String, "freelancer", "physics")


func _ready():
	pass

func _physics_process(delta):
	if movement_type == "physics":
		do_physical_movement(delta)
	elif movement_type == "freelancer":
		do_simple_movement(delta)
		
func do_simple_movement(delta):
	var bas = transform.basis
	dir = Vector3(0.0, 0.0, 0.0)
	var thrust = 0.0
	if Input.is_action_pressed("increase_thrust"):
		thrust -= acceleration_rate * thrust_rate
	if Input.is_action_pressed("reverse_thrust"):
		thrust += acceleration_rate * thrust_rate
	if Input.is_action_pressed("right_thrust"):
		dir += bas.x
	if Input.is_action_pressed("left_thrust"):
		dir += -bas.x
	if Input.is_action_pressed("up_thrust"):
		dir += bas.y
	if Input.is_action_pressed("down_thrust"):
		dir += -bas.y
	if Input.is_action_pressed("decrease_thrust"):
		damping -= 0.001
		damping = max(0.0, damping)
	if Input.is_action_just_released("decrease_thrust"):
		damping = 1.0
	
	dir *= thrust_rate
	pvelocity.z += thrust
	pvelocity.z *= damping
#	pvelocity.z *= proximity
	
	if pvelocity.z > max_speed:
		pvelocity.z = max_speed
	#$'../Camera3D'.speed = max(1.0, pvelocity.z+(position-$'../Camera3D'.position).length())
	var roll = 0.0
	if Input.is_action_pressed("roll_right"):
		roll -= 0.01
	if Input.is_action_pressed("roll_left"):
		roll += 0.01
	rotate_object_local(Vector3(0.0, 0.0, 1.0), roll)
	
	if not mouse.x==0.0 and not mouse.y==0.0:
		rotate_object_local(Vector3(-mouse.y, -mouse.x, 0.0).normalized(), mouse.length())
	
	set_velocity(dir)
	move_and_slide()
	dir = pvelocity
	set_velocity(pvelocity.z*transform.basis.z)
	move_and_slide()
		
func do_physical_movement(delta):
	var bas = transform.basis
	dir = Vector3(0.0, 0.0, 0.0)
	if Input.is_action_pressed("increase_thrust"):
		dir += -bas.z
	if Input.is_action_pressed("reverse_thrust"):
		dir += bas.z
	if Input.is_action_pressed("right_thrust"):
		dir += bas.x
	if Input.is_action_pressed("left_thrust"):
		dir += -bas.x
	if Input.is_action_pressed("up_thrust"):
		dir += bas.y
	if Input.is_action_pressed("down_thrust"):
		dir += -bas.y
	if Input.is_action_pressed("decrease_thrust"):
		damping -= 0.001
		damping = max(0.0, damping)
	if Input.is_action_just_released("decrease_thrust"):
		damping = 1.0
	dir *= acceleration_rate
	pvelocity += dir
	pvelocity *= damping
	if pvelocity.length_squared()>max_speed*max_speed:
		pvelocity = pvelocity.normalized()*max_speed
	
	var roll = 0.0
	if Input.is_action_pressed("roll_right"):
		roll -= 0.01
	if Input.is_action_pressed("roll_left"):
		roll += 0.01
	rotate_object_local(Vector3(0.0, 0.0, 1.0), roll)
	
	if not mouse.x==0.0 and not mouse.y==0.0:
		rotate_object_local(Vector3(-mouse.y, -mouse.x, 0.0).normalized(), mouse.length())
	set_velocity(pvelocity)
	move_and_slide()
	pvelocity = pvelocity

func _input(event):
	if event is InputEventMouseMotion:
		mouse = (event.position-DisplayServer.screen_get_size()*0.5)
		## add in a term so the speed caps out when the line stops
		var l = max(0.0, mouse.length()-110)*turn_speed
		mouse = mouse.normalized()*l
