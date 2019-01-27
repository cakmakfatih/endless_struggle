extends Node2D
onready var foods = [] 
var Food

func spawn_food():
	randomize()
	var mat = "res://Sprites/food/" + foods[randi()%foods.size()]
	var texture = load(mat)
	var image = Food.instance()
	var rand_x = randi()%int(160*2.210377)
	var rand_y = randi()%int(224*2.457023)
	
	image.position = Vector2(rand_x, rand_y)
	image.render(texture)
	
	add_child(image)

func _ready():
	Food = load("res://Tiles/Food.tscn")
	foods = ["can.png", "donut.png", "drug.png", "hamburger.png", "medkit.png", "pizza.png", "snickers.png"]
	spawn_food()
	spawn_food()
	spawn_food()


func _on_Area2D_area_entered(area):
	if area.is_in_group("food"):
		remove_child(area.queue_free())
		Food = load("res://Tiles/Food.tscn")
		foods = ["can.png", "donut.png", "drug.png", "hamburger.png", "medkit.png", "pizza.png", "snickers.png"]
		spawn_food()
