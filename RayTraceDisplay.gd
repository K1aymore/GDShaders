extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	var pos = material.get_shader_parameter("startingRayPos")
	if Input.is_action_pressed("forward"):
		material.set_shader_parameter("startingRayPos", pos + (Vector3(0, 0, 1) * delta) )
	if Input.is_action_pressed("back"):
		material.set_shader_parameter("startingRayPos", pos + (Vector3(0, 0, -1) * delta) )
	
	pos = material.get_shader_parameter("startingRayPos")
	if Input.is_action_pressed("left"):
		material.set_shader_parameter("startingRayPos", pos + (Vector3(-1, 0, 0) * delta) )
	if Input.is_action_pressed("right"):
		material.set_shader_parameter("startingRayPos", pos + (Vector3(1, 0, 0) * delta) )
	
	pos = material.get_shader_parameter("startingRayPos")
	if Input.is_action_pressed("up"):
		material.set_shader_parameter("startingRayPos", pos + (Vector3(0, -1, 0) * delta) )
	if Input.is_action_pressed("down"):
		material.set_shader_parameter("startingRayPos", pos + (Vector3(0, 1, 0) * delta) )
	
	var rot = material.get_shader_parameter("startingRayRot")
	if Input.is_action_pressed("rotUp"):
		material.set_shader_parameter("startingRayRot", rot + (Vector3(-1, 0, 0) * delta) )
	if Input.is_action_pressed("rotDown"):
		material.set_shader_parameter("startingRayRot", rot + (Vector3(1, 0, 0) * delta) )
	
	rot = material.get_shader_parameter("startingRayRot")
	if Input.is_action_pressed("rotLeft"):
		material.set_shader_parameter("startingRayRot", rot + (Vector3(0, 1, 0) * delta) )
	if Input.is_action_pressed("rotRight"):
		material.set_shader_parameter("startingRayRot", rot + (Vector3(0, -1, 0) * delta) )
