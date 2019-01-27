extends Sprite

var foods = []

func _ready():
	foods = ["can.png", "donut.png", "drug.png", "hamburger.png", "medkit.png", "pizza.png", "snickers.png"]
	var mat = "res://Sprites/food/" + foods[randi()%foods.size()]
	var texture = load(mat)
	set_texture(texture)

func render(texture):
	$Sprite.set_texture(texture)

func _on_Sprite_body_entered(body):
	if body.name == "Player":
		var amount = randi()%10+4
		body.feed(amount)
		queue_free()
