extends Node3D

## Things to think about for future
#Short term
	# Sun: Corona, spectral class
	# Planets: vary brightness of water, color, play with noise
	# Atmosphere: O neill scale function
	# Post effects: auto exposure
	# Nebula: more variation, other noise algorithms, multiple lights?
#long term
	# thrust trails
	# lasers
	# Asteroids
	# stations
	# interation??
	# show planets checked hud


var planet_scene = preload("res://scenes/Planet.tscn")
var asteroids_scene = preload("res://scenes/Asteroids.tscn")
var planets = []
var asteroid_fields = []
@export
var num_planets = 5

@export
var num_asteroid_fields = 9

func _ready():
	randomize()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Input.warp_mouse(DisplayServer.screen_get_size()*0.5)

	$Nebula.render_target_update_mode = SubViewport.UPDATE_ONCE
	await RenderingServer.frame_post_draw
	
	$WorldEnvironment.environment.sky = Sky.new()
	$WorldEnvironment.environment.sky.sky_material = PanoramaSkyMaterial.new()
	$WorldEnvironment.environment.sky.sky_material.panorama = $Nebula.get_texture()
	$Stars.material_override.set_shader_parameter("nebula", $Nebula.get_texture())
	
	for i in num_planets:
		var p = planet_scene.instantiate()
		var t = Vector3(randf()*8000-4000, randf()*200-100, randf()*8000-4000)
		p.translate(t+$Star.position)
		planets.append(p)
		add_child(p)
	for i in num_asteroid_fields:
		var af = asteroids_scene.instantiate()
		var t = Vector3(randf()*8000-4000, randf()*200-100, randf()*8000-4000)
		af.translate(t+$Star.position)
		asteroid_fields.append(af)
#		if $Ship.position.distance_to(af.position) < af.lod_distance:
#			af.get_child("MeshInstance3D").visible = false
		add_child(af)

func _process(delta):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
	for planet in planets:
		var cam = planet.position - $FollowCamera.position
		var light = planet.position - $Star.position
		planet.set_atmosphere_properties(cam, light)
	var max_dist_sq = 360000 #800*800
	var ship_to_sun = $Ship.position.distance_squared_to($Star.position)
	$Ship.proximity = 1.0
	if ship_to_sun<max_dist_sq:
		$Ship.proximity = ship_to_sun/max_dist_sq
		#plus send signal to the UI! should be in red and should be text
	var ship_to_planet = 10000.0
	var max_planet_dist_sq = 225.0
	for planet in planets:
		ship_to_planet = min($Ship.position.distance_squared_to(planet.position)-planet.planet_radius*planet.planet_radius, ship_to_planet)
	if ship_to_planet<max_planet_dist_sq:
		$Ship.proximity = ship_to_planet/max_planet_dist_sq
		#remember to send signal to UI
			
	
