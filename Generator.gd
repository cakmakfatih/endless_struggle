extends Node2D

onready var player

var Car
var Enemy
var NonCollidable
var Market

var tile_size = Vector2(32,32)
var width
var height
var loaded = []
var at_home = false
var i = 3
const TOP = Vector2(0, -1)
const BOTTOM = Vector2(0, 1)
const LEFT = Vector2(-1, 0)
const RIGHT = Vector2(0, 1)
const TOP_RIGHT = Vector2(1, -1)
const TOP_LEFT = Vector2(-1, -1)
const BOTTOM_LEFT = Vector2(-1, 1)
const BOTTOM_RIGHT = Vector2(1, 1)

var directions = []

onready var Ground = $Map/Ground

func spawn_car(pos):
	var c = Car.instance()
	c.global_position = pos
	c.global_rotation = randi()%180
	$Objects.add_child(c)

func spawn_enemy(pos):
	var e = Enemy.instance()
	e.global_position = pos
	$Enemies.add_child(e)

func spawn_non_collidable(pos):
	var e = NonCollidable.instance()
	e.global_position = pos
	$Enemies.add_child(e)

func spawn_market(pos):
	var e = Market.instance()
	e.global_position = pos
	$Buildings.add_child(e)

func _ready():
	randomize()
	Car = load("res://Tiles/Car.tscn")
	Enemy = load("res://Scenes/Enemy.tscn")
	NonCollidable = load("res://Tiles/NonCollidable.tscn")
	Market = load("res://Tiles/Market.tscn")
	width = tile_size.x
	height = tile_size.y
	directions = [TOP, LEFT, BOTTOM, RIGHT, TOP_LEFT, BOTTOM_LEFT, TOP_RIGHT, BOTTOM_RIGHT]
	_update_map(Vector2(0,0))

func _process(delta):
	if player:
		var player_pos = Vector2(round(player.global_position.x/(128*32)), round(player.global_position.y/(128*32)))
		if player_pos == Vector2(0,0):
			at_home = true
		else:
			at_home = false
		for pos in directions:
			if loaded.find(pos + player_pos) == -1:
				_update_map(pos + player_pos)
			if loaded.find(pos*2 + player_pos) == -1:
				_update_map(pos*2 + player_pos)

func spawn_random(vec, vec2):
	randomize()
	var spawn_car_pos = randi()%128*128+1
	var non_col_pos = randi()%128*128+1
	var spawn_mob_pos = randi()%128*128+1
	
	if player:
		if spawn_mob_pos > 126*128 and !at_home:
			randomize()
			var neg = randi()%2 + 1
			var negy = randi()%2 + 1
			
			if neg != 1:
				neg = -1
			if negy != 1:
				negy = -1
			
			var x = randf(vec2.x*128) * 128 * width * neg
			var y = randf(vec2.y*128) * 128 * height * negy
			
			if x > 300 or x < -300 and y > 300 or y < -300:
				spawn_enemy(Vector2(x, y))
		if spawn_car_pos > 126*128:
			randomize()
			var neg = randi()%2 + 1
			var negy = randi()%2 + 1
			
			if neg != 1:
				neg = -1
			if negy != 1:
				negy = -1
			
			var x = randf(vec2.x*128) * 128 * width * neg
			var y = randf(vec2.y*128) * 128 * height * negy
			
			if x > 300 or x < -300 and y > 300 or y < -300:
				spawn_car(Vector2(x, y))
		if non_col_pos > 111*128:
			randomize()
			var neg = randi()%2 + 1
			var negy = randi()%2 + 1
			
			if neg != 1:
				neg = -1
			if negy != 1:
				negy = -1
				
			var x = randf(vec.x*128) * 128 * width * neg
			var y = randf(vec2.y*128) * 128 * height * negy
			
			spawn_non_collidable(Vector2(x, y))

func _update_map(vec):
	loaded.append(vec)
	for x in range(width):
		for y in range(height):
			spawn_random(vec, Vector2(x, y))
			Ground.set_cellv(Vector2(vec.x * tile_size.x + x, vec.y * tile_size.y + y), 0)

func enemy_spawn_timer():
	randomize()
	spawn_enemy(Vector2(randf()*player.global_position.x, randf()*player.global_position.y))
	spawn_enemy(Vector2(randf()*player.global_position.x, randf()*player.global_position.y))
	spawn_enemy(Vector2(randf()*player.global_position.x, randf()*player.global_position.y))
