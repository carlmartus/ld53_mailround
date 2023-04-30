extends Control

func _ready():
	Director.connect("clock_set", self, "on_set_clock")

func _on_start_pressed():
	Director.start_truck()

func _on_ui_down(ui_name: String):
	Input.action_press(ui_name)

func _on_ui_up(ui_name: String):
	Input.action_release(ui_name)

func _on_button_respawn_pressed():
	Director.truck_respawn()

func on_set_clock(time: int):
	$ClockDisplay.text = "Time: " + String(time)
