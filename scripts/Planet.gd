extends Node3D

@export var planet_radius = 50.0
@export var atmosphere_radius = 51.25
@export var wavelength = Vector3(0.65, 0.57, 0.475)
@export var ground_color = Color(0.5, 0.3, 0.2)
@export var kr = 0.0025
@export var km = 0.001
@export var sun_strength = 20
var scale_depth = 0.25 #should be constant for now
@export var n_samples = 2
@export var g = -0.99
@export var make_random: bool = true
var gen_seed = 0

func _ready():
	if make_random:
		planet_radius = 10.0+randf()*90.0
		atmosphere_radius = planet_radius*1.025
		wavelength = Vector3(randf()*0.7+0.3, randf()*0.7+0.3, randf()*0.7+0.3)
		gen_seed = randf()
		var gc = Vector3(randf(), randf(), randf()).normalized()
		ground_color = Color(gc.x, gc.y, gc.z)
		$Ground/ColorRect.material.set_shader_parameter("seed", gen_seed)
	$Ground/ColorRect.material.set_shader_parameter("wavelength", wavelength)
	$Ground/ColorRect.material.set_shader_parameter("ground", ground_color)

	$Surface.mesh.radial_segments = 256
	$Surface.mesh.rings = 256
	$Atmosphere.mesh.radial_segments = 256
	$Atmosphere.mesh.rings = 256
	$Surface.mesh.radius = planet_radius
	$Surface.mesh.height = planet_radius*2.0
	$Atmosphere.mesh.radius = atmosphere_radius
	$Atmosphere.mesh.height = atmosphere_radius*2.0
	$Surface.material_override.set_shader_parameter("texture_albedo", $Ground.get_texture())

	set_init_params($Surface.material_override)
	set_init_params($Atmosphere.material_override)

func set_atmosphere_properties(cam, light):
	set_params($Surface.material_override, cam, light)
	set_params($Atmosphere.material_override, cam, light)
	
func set_params(mat, cam, light):
	mat.set_shader_parameter("v3CameraPos", -cam)
	mat.set_shader_parameter("fCameraHeight2", cam.length_squared())
	mat.set_shader_parameter("v3LightPos", -light.normalized())

func set_init_params(mat):
	mat.set_shader_parameter("fOuterRadius", atmosphere_radius)
	mat.set_shader_parameter("fOuterRadius2", atmosphere_radius*atmosphere_radius)
	mat.set_shader_parameter("fInnerRadius", planet_radius)
	mat.set_shader_parameter("fInnerRadius2", planet_radius*planet_radius)
	mat.set_shader_parameter("fScale", 1.0/(atmosphere_radius-planet_radius))
	mat.set_shader_parameter("fScaleOverScaleDepth", (1.0/(atmosphere_radius-planet_radius))/scale_depth)
	mat.set_shader_parameter("fScaleDepth", scale_depth)
	mat.set_shader_parameter("v3InvWavelength", Vector3(1.0/pow(wavelength.x, 4.0),1.0/pow(wavelength.y, 4.0),1.0/pow(wavelength.z, 4.0)))
	mat.set_shader_parameter("fKrESun", kr*sun_strength)
	mat.set_shader_parameter("fKmESun", km*sun_strength)
	mat.set_shader_parameter("fKr4PI", kr*4.0*PI)
	mat.set_shader_parameter("fKm4PI", km*4.0*PI)
	mat.set_shader_parameter("nSamples", n_samples)
	mat.set_shader_parameter("fSamples", float(n_samples))
	mat.set_shader_parameter("g", g)
	mat.set_shader_parameter("g2", g*g)

