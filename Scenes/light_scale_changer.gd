extends PointLight2D

@export var flicker_interval := 0.15  # seconds between size changes

var sizes := [1.0, 1.1, 1.2, 1.1, 1.0]
var index := 0
var timer := 0.0

func _process(delta):
    timer += delta
    if timer >= flicker_interval:
        timer = 0.0
        index = (index + 1) % sizes.size()
        scale = Vector2.ONE * sizes[index]