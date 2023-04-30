extends Spatial

var gameplay_scene = load("res://scenes/gameplay.tscn")

var world_instance

func _ready():
	Director.connect("game_restart", self, "game_restart")
	self.new_world()

func new_world():
	world_instance = gameplay_scene.instance()
	self.add_child(world_instance)

func game_restart():
	world_instance.queue_free()
	self.new_world()
