extends Spatial

var reverse_brakes: int = 0

func _ready():
	Director.connect("game_end", self, "on_game_end")

func _process(delta):
	var basis = $Truck.transform.basis.z
	var basis_offset = Vector3(basis.x, 0.0, basis.z) * 5.0
	$Cambox.translation = $Truck.translation + Vector3(-5.0, 10.0, 5.0) + basis_offset

	# Steering
	var steer = 0.0
	if Input.is_action_pressed("ui_left"):
		steer += 1.0
	if Input.is_action_pressed("ui_right"):
		steer -= 1.0

	# Check reverse controlls
	if Input.is_action_just_pressed("ui_down"):
		self.reverse_brakes += 1
	if Input.is_action_pressed("ui_up"):
		self.reverse_brakes = 0

	# Set truck input
	$Truck.input_steer = steer
	$Truck.input_throttle = Input.is_action_pressed("ui_up")
	$Truck.input_brake = Input.is_action_pressed("ui_down")
	$Truck.input_reverse = Input.is_action_pressed("ui_down") and (self.reverse_brakes >= 2)

	# Set arrow
	$Arrow.transform.origin = $Truck.transform.origin
	var dir: Vector3 = Director.next_checkpoint -  $Truck.translation
	$Arrow.rotation_degrees.y = -atan2(dir.z, dir.x) * 180.0 /  3.141593

func on_game_end():
	$WinCanvas.show()
