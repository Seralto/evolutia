extends Area2D

export var speed = 20
export var energy = 100
export var energy_decrease_rate = 5

var display_width = ProjectSettings.get_setting("display/window/size/width")
var display_height = ProjectSettings.get_setting("display/window/size/height")

const ROTATION = {
	Vector2.UP: 0,
	Vector2.RIGHT: 90,
	Vector2.DOWN: 180,
	Vector2.LEFT: 270,
	Vector2(1, -1): 45,
	Vector2(1, 1): 135,
	Vector2(-1, 1): 225,
	Vector2(-1, -1): 315,
}

var direction
var plant = null
var state = SEARCHING_FOOD

enum {
	SEARCHING_FOOD,
	FOOD_FOUND,
	EATING
}

func _ready():
	direction = new_direction()
	
func _process(delta):
	match state:
		SEARCHING_FOOD:
			move_randomly(delta)
		FOOD_FOUND:
			go_to_food(delta)
			
	decrease_energy(delta)

func move_randomly(delta):
	rotate_sprite()
	position += direction.normalized() * speed * delta
	keep_sprite_on_screen()
#	position += Vector2(0, 1) * speed * delta

func keep_sprite_on_screen():
	if position.x <= 0 || position.x >= display_width:
		direction.x *= -1
	if position.y <= 0 || position.y >= display_height:
		direction.y *= -1

func go_to_food(delta):
	if is_instance_valid(plant):
		$Sprite.rotation_degrees = rad2deg(plant.position.angle_to_point(position)) + 90
		position += position.direction_to(plant.position) * speed * delta
	else:
		state = SEARCHING_FOOD

func decrease_energy(delta):
	if moving():
		energy -= energy_decrease_rate * delta

func new_direction():
	var h_move = choose([Vector2.RIGHT, Vector2.LEFT, Vector2.ZERO])
	var v_move = choose([Vector2.UP, Vector2.DOWN, Vector2.ZERO])
	return h_move + v_move
	
func rotate_sprite():
	if direction == Vector2.ZERO:
		return
		
	$Sprite.rotation_degrees = ROTATION[direction]

func choose(options):
	options.shuffle()
	return options.front()
	
func moving():
	return direction != Vector2.ZERO

func _on_direction_timer_timeout():
	var time = choose([0.5, 1.0, 1.5])
	$direction_timer.set_wait_time(time)
	direction = new_direction()

func _on_vision_area_entered(area):
	if is_instance_valid(plant):
		return
	
	state = FOOD_FOUND
	plant = area

func _on_creature_area_entered(area):
	state = EATING
	$eating_timer.start()
	
func _on_creature_input_event(viewport, event, shape_idx):
	if event.is_pressed():
		print(self)

func _on_eating_timer_timeout():
	if is_instance_valid(plant):
		plant.eaten = true
		
	$eating_timer.stop()
	state = SEARCHING_FOOD
