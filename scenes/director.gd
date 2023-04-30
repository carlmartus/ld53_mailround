extends Node

signal game_ready
signal game_crash
signal truck_start
signal truck_stop
signal truck_respawn
signal clock_set
signal game_restart
signal game_end

enum { DIR_1 }

var spawn: Transform
var clock_ticks: int = 0
export(Vector3) var next_checkpoint = Vector3()

func _ready():
	pass

func crash():
	emit_signal("game_crash")

func start_truck():
	emit_signal("truck_start")
	if not $Clock.is_playing():
		clock_ticks = 0
		$Clock.play("ticker")

func collected(index: int):
	var next = index + 1
	get_tree().call_group("collects", "activate", next)

func collected_all():
	$Clock.stop()
	emit_signal("game_end")
	emit_signal("truck_stop")

func clock_tick():
	self.clock_ticks += 1
	emit_signal("clock_set", clock_ticks)

func truck_crashed():
	$Anims.play("respawn")

func game_restart():
	emit_signal("game_restart")

func truck_respawn():
	emit_signal("truck_respawn", self.spawn)

func anim_truck_respawn():
	emit_signal("truck_respawn", self.spawn)

func set_checkpoint(spawn_point: Transform):
	self.spawn = spawn_point

func set_next_checkpoint(position: Vector3):
	self.next_checkpoint = position
