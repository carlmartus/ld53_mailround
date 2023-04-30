extends Spatial

signal collected

export(Mesh) var mesh_data
export(int) var collect_index = 0
export(bool) var collect_on = false
export(bool) var collect_last = false

func _ready():
	add_to_group("collects")
	if mesh_data:
		$Pedistal.mesh = mesh_data
	$SpinRing.play("rotate")
	$SpinMesh.play("spin")
	set_active(collect_on)
	$Direction.visible = false

func _on_Area_body_entered(body):
	if self.collect_last:
		Director.collected_all()
	else:
		Director.collected(collect_index)
		Director.set_checkpoint($Checkpoint.global_transform)

func activate(index: int):
	self.set_active(index == collect_index)

func set_active(active: bool):
	self.visible = active
	$Area.monitoring = active
	if active:
		Director.set_next_checkpoint(self.translation)
