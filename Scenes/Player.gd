extends KinematicBody2D

var health = 100
var hunger = 100

export (int) var speed = 200
var attacking = false
var can_attack = true

var crosshair = load("res://Sprites/HUD/strike.png")
var crosshair_dagger = load("res://Sprites/HUD/dagger.png")

var activeTexture = load("res://Sprites/HUD/box1.png")
var deactiveTexture = load("res://Sprites/HUD/box2.png")
var current_active = 0

const UP = Vector2(0, -1)
const DOWN = Vector2(0, 1)
const LEFT = Vector2(-1, 0)
const RIGHT = Vector2(1, 0)

const HAND_GUN_RANGE = 600

enum WEAPON {
	KNIFE,
	HAND_GUN
}

var current_weapon = WEAPON.KNIFE

func pass_exception(rid):
	$RayCast2D.add_exception_rid(rid)

func remove_exception(rid):
	$RayCast2D.remove_exception_rid(rid)

func get_hit(damage):
	$AnimationPlayer.play("get_hit")
	health -= damage
	$GUI/TextureProgress.value = health
	if health <= 0:
		get_tree().change_scene("res://Views/World.tscn")
		queue_free()

func get_damage():
	match current_weapon:
		WEAPON.KNIFE:
			return 10
		WEAPON.HAND_GUN:
			return 15

func get_anim(anim):
	match current_weapon:
		WEAPON.KNIFE:
			return anim + "_knife"
		WEAPON.HAND_GUN:
			return anim + "_handgun"

func set_cursor():
	match current_weapon:
		WEAPON.KNIFE:
			Input.set_custom_mouse_cursor(crosshair_dagger)
		WEAPON.HAND_GUN:
			Input.set_custom_mouse_cursor(crosshair)

func attack():
	attacking = true
	if current_weapon == WEAPON.KNIFE:
		$MeleeAttack/CollisionShape2D.disabled = false
	if current_weapon == WEAPON.HAND_GUN:
		$Audio/Handgun_Shoot.play()
		$RayCast2D.cast_to = Vector2(0, HAND_GUN_RANGE)
		if $RayCast2D.is_colliding():
			var obj = $RayCast2D.get_collider()
			if obj.is_in_group("enemy"):
				if obj.name == "Area2D":
					obj.get_parent().get_hit(get_damage())
				else:
					obj.get_hit(get_damage())
	$AnimatedSprite.play(get_anim("attack"))

func wear_item(ind):
	$Inventory.get_child(current_active).set_texture(deactiveTexture)
	$Inventory.get_child(ind).set_texture(activeTexture)
	current_active = ind

func _ready():
	$RayCast2D.add_exception($MeleeAttack)
	Input.set_custom_mouse_cursor(crosshair_dagger)
	$AnimatedSprite.animation = get_anim("idle")
	$AnimatedSprite.play()
	
	$Feet.animation = "idle"
	$Feet.play()

func _process(delta):
	look_at(get_global_mouse_position())
	var direction = Vector2(0,0)
	
	if Input.is_key_pressed(KEY_1):
		current_weapon = WEAPON.KNIFE
		wear_item(0)
		set_cursor()
	if Input.is_key_pressed(KEY_2):
		current_weapon = WEAPON.HAND_GUN
		wear_item(1)
		set_cursor()
	
	if Input.is_key_pressed(KEY_W):
		direction += UP
	if Input.is_key_pressed(KEY_S):
		direction += DOWN
	if Input.is_key_pressed(KEY_A):
		direction += LEFT
	if Input.is_key_pressed(KEY_D):
		direction += RIGHT
	if Input.is_action_pressed("ui_page_up") and can_attack:
		can_attack = false
		attack()
	
	if !attacking:
		if direction.length() > 0:
			$Feet.animation = "run"
			$AnimatedSprite.animation = get_anim("move")
		else:
			$Feet.animation = "idle"
			$AnimatedSprite.animation = get_anim("idle")
	move_and_collide(direction.normalized() * speed * delta)

func _on_AnimatedSprite_animation_finished():
	if "attack" in $AnimatedSprite.animation:
		$AnimatedSprite.stop()
		can_attack = true
		attacking = false
		$MeleeAttack/CollisionShape2D.disabled = true

func feed(amount):
	hunger += amount
	$GUI/Hunger.value = hunger
func render_food(image):
	get_parent().add_child(image)
func _on_HungerTick_timeout():
	if hunger > 0:
		hunger -= 10
		$GUI/Hunger.value = hunger
	else:
		health -= 10
		$GUI/TextureProgress.value = health
		if health <= 0:
			get_tree().change_scene("res://Views/World.tscn")
