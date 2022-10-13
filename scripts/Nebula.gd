extends SubViewport

@export var gen_seed = 0.0
@export var density = 0.5 # (float, 0.0, 1.0)
@export var attenuation = Vector3(1.0, 2.0, 8.0)
@export var make_random = true
@export var light_position = Vector3(0.0, 1.0, 4.0)
@export var cloud_color = Vector3(1.5, 1.0, 1.0)

func _ready():
	if make_random:
		randomize()
		gen_seed = randf()
		density = randf()*0.6
		light_position = Vector3(randf()*2.0-1.0, randf()*2.0-1.0, randf()*2.0-1.0).normalized()*3.0
		attenuation = Vector3(1.0, 1.0, 1.0)+Vector3(pow(randf(), 4), pow(randf(), 4), pow(randf(), 4))*5.0
		cloud_color = Vector3(0.5, 0.5, 0.5)+Vector3(randf(), randf(), randf()).normalized()*1.5
		attenuation = attenuation/cloud_color
	$ColorRect.material.set_shader_parameter("seed", gen_seed)
	$ColorRect.material.set_shader_parameter("density", density)
	$ColorRect.material.set_shader_parameter("light", light_position)
	$ColorRect.material.set_shader_parameter("attenuation", attenuation)
	$ColorRect.material.set_shader_parameter("cloud_color", cloud_color)
