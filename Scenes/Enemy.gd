extends KinematicBody2D

var health
var player
var radius
export (int) var speed = 120
var base_damage

var enemy_near = false
var Food
var foods = []
var can_attack = true

func _ready():
	foods = ["can.png", "donut.png", "drug.png", "hamburger.png", "medkit.png", "pizza.png", "snickers.png"]
	Food = load("res://Tiles/Food.tscn")
	randomize()
	base_damage = randi()%6+5
	health = randi()%31+30
	radius = $Mover/CollisionShape2D.shape.get_radius()
	$HealthBar.max_value = health
	$HealthBar.value = health

func _physics_process(delta):
	if player and health > 0:
		var distance = global_position.distance_to(player.global_position)
		if distance <= radius:
			var target_dir = (player.global_position - global_position).normalized()
			move_and_collide(target_dir * speed * delta)
		else:
			pass
	else:
		# random movement
		pass
	if enemy_near and can_attack:
		can_attack = false
		$AnimationPlayer.play("attack")
		

func get_hit(damage):
	if !(health <= 0):
		$AnimationPlayer.play("got_hit")
		health -= damage
		$HealthBar.value = health
		
		if health <= 0:
			$AnimationPlayer.play("die")
			$DestroyTimer.start()

func attack(body):
	randomize()
	var damage = randi()%10+base_damage
	body.get_hit(damage)

func _on_Area2D_area_entered(area):
	if area.name == "MeleeAttack":
		get_hit(area.get_parent().get_damage())

func _on_DestroyTimer_timeout():
	randomize()
	var image = Food.instance()
	image.global_position = global_position
	player.render_food(image)
	queue_free()

func _on_player_entered(body):
	if body.name == "Player":
		player = body
		player.pass_exception($AttackArea.get_rid())

func _on_player_exited(body):
	if body.name == "Player":
		player.remove_exception($AttackArea.get_rid())
		player = null

func _on_AttackArea_body_entered(body):
	if body.name == "Player":
		enemy_near = true

func _on_AttackArea_body_exited(body):
	if body.name == "Player":
		enemy_near = false

func _on_AnimationPlayer_animation_finished(anim_name):
	if player != null:
		var distance = global_position.distance_to(player.global_position)
		if distance <= 64 and anim_name == "attack":
			attack(player)
	can_attack = true
