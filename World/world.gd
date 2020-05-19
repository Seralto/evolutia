extends Area2D

var Creature = preload("res://Creature/Creature.tscn")
var Plant = preload("res://Plant/Plant.tscn")

var screen_size = Vector2(320, 180)

func _ready():
	randomize()
	add_creature()
	add_plant()

func _process(delta):
	pass

func add_creature():
	for i in range(10):
		var creature = build_creature()
		add_child(creature)
		
func build_creature():
	var creature = Creature.instance()
#	creature.position = Vector2(160, 90)
	creature.position = Vector2(rand_range(0, screen_size.x), rand_range(0, screen_size.y))
	creature.speed = floor(rand_range(15, 30))
	creature.energy = floor(rand_range(80, 120))
	creature.energy_decrease_rate = floor(rand_range(4, 6))
#	print(str("creature -> speed: ", creature.speed), str(" energy: ", creature.energy), str(" energy_decrease_rate: ", creature.energy_decrease_rate))
	return creature

func add_plant():
	for i in range(30):
		var plant = Plant.instance()
		plant.position = Vector2(rand_range(0, screen_size.x), rand_range(0, screen_size.y))
		add_child(plant)
	
