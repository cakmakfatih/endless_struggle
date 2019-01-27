extends Sprite

func _ready():
	randomize()
	var car_textures = ["car2_196.png", "car3_196.png", "car4_196.png", "car_196.png"]
	var mat = "res://Sprites/Cars/" + car_textures[randi()%car_textures.size()]
	var texture = load(mat)
	set_texture(texture)
