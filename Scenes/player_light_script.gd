extends PointLight2D

@export var anim: AnimatedTexture
@export var fps: float = 4

var _time := 0.0
var _frame := 0


func _process(delta):
	if anim == null or anim.frames == 0:
		return

	_time += delta
	if _time >= 1.0 / fps:
		_time = 0.0
		_frame = (_frame + 1) % anim.frames

	var frame_tex := anim.get_frame_texture(_frame)
	if frame_tex == null:
		return 

	var img := frame_tex.get_image()
	# flag to avoid errors
	if !img:
		return  

	var tex := ImageTexture.create_from_image(img)
	# flag to avoid errors
	if !tex:
		return 

	# flag to avoid errors
	if !texture:
		return

	texture = tex