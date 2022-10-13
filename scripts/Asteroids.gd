extends Node3D

@export
var max_size = 1550.0

@export
var min_size = 500.0

@export
var max_density = 100.0

@export
var lod_distance = 4000.0

var radius = 100
var density = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	radius = min_size + (max_size - min_size) * randf()
	$Area3d/CollisionShape3d.shape.radius = radius
	$Label3d.position.y = radius
	$Label3d.text = get_asteroid_field_name()
	$LOD/CollisionShape3d.shape.radius = lod_distance
	
	for i in range(max_density):
		var asteroid = SphereMesh.new()
		var rad = randf()
		asteroid.radius = rad * rad * 9.0 + 1.0
		asteroid.height = 2.0 * asteroid.radius
		var am = MeshInstance3D.new()
		am.mesh = asteroid
		var pos = Vector3(radius, radius, radius)
		while pos.length() > radius:
			pos = Vector3((randf() * 2.0 - 1.0) * radius, (randf() * 2.0 - 1.0) * radius, (randf() * 2.0 - 1.0) * radius)
		am.position = pos
		add_child(am)
		am.add_to_group("asteroids")
		


func get_asteroid_field_name():
	return "ass field"

func _on_area_3d_body_entered(body):
	print(body, " has entered the asteroid field")


func _on_lod_body_entered(body):
	$MeshInstance3d.visible = false
	for node in get_tree().get_nodes_in_group("asteroids"):
		node.visible = true


func _on_lod_body_exited(body):
	$MeshInstance3d.visible = true
	for node in get_tree().get_nodes_in_group("asteroids"):
		node.visible = false
