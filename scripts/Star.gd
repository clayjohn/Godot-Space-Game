extends Node3D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	$Surface.material_override.set_shader_parameter("texture_albedo", $SubViewport.get_texture())
	

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
