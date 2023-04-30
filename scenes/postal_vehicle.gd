extends VehicleBody

export(bool) var input_throttle = false
export(bool) var input_brake = false
export(bool) var input_reverse = false
export(float) var input_steer = 0.0

enum {DRIVE_PENDING, DRIVE_ACTIVE, DRIVE_CRASH}
var drive_state: int

func _ready():
	self.drive_state = DRIVE_PENDING
	# self.connect("child_entered_tree", 
	Director.connect("truck_start", self, "on_truck_start")
	Director.connect("truck_stop", self, "on_truck_stop")
	Director.connect("truck_respawn", self, "respawn")
	Director.set_checkpoint(self.global_transform)

func on_truck_start():
	self.apply_torque_impulse(Vector3(20.0, 0.0, 0.0))
	self.drive_state = DRIVE_ACTIVE

func on_truck_stop():
	self.drive_state = DRIVE_PENDING

func _drive(delta):
	var target_gas = 0.0
	if self.input_throttle:
		target_gas = 100.0
	elif self.input_reverse:
		target_gas = -30.0
	var target_steer: float = self.input_steer * 0.8

	# Apply to vehicle
	self.engine_force = target_gas
	self.steering = lerp(self.steering, target_steer, delta*2.0)
	self.brake = self.input_brake

	# Check crash status
	if transform.basis.y.y < 0.35:
		drive_state = DRIVE_CRASH
		Director.truck_crashed()

func _pending():
	self.engine_force = 0
	self.brake = true

func respawn(checkpoint: Transform):
	self.global_transform = checkpoint
	self.drive_state = DRIVE_ACTIVE
	self.set_axis_velocity(Vector3())
	self.linear_velocity = Vector3()

func _process(delta):
	if self.drive_state == DRIVE_ACTIVE:
		self._drive(delta)
	elif self.drive_state == DRIVE_PENDING:
		self._pending()
