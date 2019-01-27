extends Sprite

func _ready():
	randomize()
	var car_textures = ["bush.png", "mushrooms.png"]
	var mat = "res://Sprites/Non-Collidable/" + car_textures[randi()%car_textures.size()]
	var texture = load(mat)
	set_texture(texture)
