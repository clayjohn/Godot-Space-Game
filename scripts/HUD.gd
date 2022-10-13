extends Node3D


func _ready():
	var tex = $SubViewport.get_texture()
	$Viewport2/blurX.material.set_shader_parameter("HUD", tex)
	$Viewport2/screen/blurY.material.set_shader_parameter("HUD", tex)
	var viewport = get_node("SubViewport")
	viewport.set_clear_mode(SubViewport.CLEAR_MODE_ONCE)

	# Let two frames pass to make sure the vieport's is captured
	await RenderingServer.frame_post_draw
	await RenderingServer.frame_post_draw

	# Retrieve the texture and set it to the viewport quad
	get_node("MeshInstance3D").material_override.albedo_texture = viewport.get_texture()
	#$Sprite3D.texture = viewport.get_texture()
	viewport.render_target_clear_mode = SubViewport.CLEAR_MODE_ALWAYS
	$SubViewport.render_target_clear_mode = SubViewport.CLEAR_MODE_ALWAYS
	
func _process(delta):
	var mouse = DisplayServer.mouse_get_position()
	$SubViewport/SDFs.material.set_shader_parameter("mouse", mouse)
