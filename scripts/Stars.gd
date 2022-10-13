extends MeshInstance3D

@export var OBA1: Color = Color("78a0ff")
@export var OBA2: Color = Color("c7f9ff")
@export var FG1: Color = Color("fffee8")
@export var FG2: Color = Color("fffac9")
@export var KM1: Color = Color("ffc37e")
@export var KM2: Color = Color("ff725f")

func _ready():
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_POINTS)

	for i in range(10000):
		#Color and size information is based checked Hertzsprung-Russell diagrams
		#First we pick a random spectral classification (Color)
		#From there we determine the size
		var sclass = randf()
		var x
		var color = Color(1.0, 1.0, 1.0)
		var size = randf()
		var fade = randf()
		if sclass <0.45: #O|B|A #Small but bright
			x = remap(sclass, 0.0, 0.45, 0.0, 1.0)
			color = OBA1.lerp(OBA2, x)
			size = size*size*size*size*0.7+0.1
		elif sclass<0.7: #F|G #Typically small
			x = remap(sclass, 0.45, 0.7, 0.0, 1.0)
			color = FG1.lerp(FG2, x)
			size = pow(size, 10)*0.3
		else: #K|M #When you see them they are very large
			x = remap(sclass, 0.7, 1.0, 0.0, 1.0)
			color = KM1.lerp(KM2, x)
			size = sqrt(size)
		st.set_color(color)
		
		#0.56 is the smallest we can go without star flickering
		st.set_uv(Vector2(lerp(0.56, 1.0, size), fade))
		var point = Vector3(randf()-0.5, randf()-0.5, randf()-0.5)
		while point.length_squared()>0.25:
			point = Vector3(randf()-0.5, randf()-0.5, randf()-0.5)
		point = point.normalized()*9990
		st.add_vertex(point)
		
	mesh = st.commit()
func _process(delta):
	position = $"../Ship".position
