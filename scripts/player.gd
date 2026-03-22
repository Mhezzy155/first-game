extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@export var speed = 50

var interact = false
var new_direction = Vector2(0,1)
var animation

# Movement & Animation
func _physics_process(delta: float) -> void:
	var direction : Vector2

	# get movement input
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")

	# normalize direction
	if abs(direction.x) == 1 and abs(direction.y) == 1:
		direction = direction.normalized()
	
	# sprint
	if Input.is_action_pressed("run"):
		speed = 100
	elif Input.is_action_just_released("run"):
		speed = 50

	# if player not interact
	var movement = speed * direction * delta

	if interact == false:
		move_and_collide(movement)
		player_animations(direction)

	# if no input (idle)
	if !Input.is_anything_pressed():
		if interact == false:
			animation = "idle" + returned_direction(new_direction)


# interact input
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		interact = true


# animation direction
func returned_direction(direction:Vector2) : 
	var normalized_direction = direction.normalized()
	var default_return = "side"

	if normalized_direction.y > 0:
		return "Down"
	elif normalized_direction.y < 0:
		return "Up"
	elif normalized_direction.x > 0:
		$AnimatedSprite2D.flip_h = false
		return "Side"
	elif normalized_direction.x < 0:
		$AnimatedSprite2D.flip_h = true
		return "Side"

	return default_return

# animations
func player_animations(direction : Vector2):
	if direction != Vector2.ZERO:
		# update new direction
		new_direction = direction
		# play walk cz it's movin
		animation = "walk" +returned_direction(new_direction)
		sprite.play(animation)

	else:
		#play idle animation, because we are still
		animation  = "idle" + returned_direction(new_direction)
		sprite.play(animation)

# reset animation states
func _on_animated_sprite_2d_animation_finished() -> void:
	interact = false
