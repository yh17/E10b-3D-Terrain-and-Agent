extends KinematicBody

var speed = 1
var state = ""

func _ready():
	change_state("scanning")

func change_state(new_state):
	state = new_state
	var material = $MeshInstance2.mesh.surface_get_material(0)
	if state == "scanning":
		material.albedo_color = Color(0,1,0)
	if state == "active":
		material.albedo_color = Color(1,1,0)
	if state == "hiding":
		material.albedo_color = Color(0,0,1)
	if state == "shooting":
		material.albedo_color = Color(1,0,0)
	$MeshInstance2.set_surface_material(0, material)		


func _physics_process(delta):
	if state == "scanning":
		rotate(Vector3(0, 1, 0), speed*delta)
		var c = $Scan.get_collider()
		if c != null and c.name == 'Player':
			change_state("active")
			$Timer.start()


func _on_Timer_timeout():
	var c = $Scan.get_collider()
	if state == "active":
		if c != null and c.name == 'Player':
			change_state("shooting")
			$Timer.start()
		else:
			change_state("scanning")
	if state == "shooting":
		if c != null and c.name == 'Player':
			$Timer.start()
		else:
			change_state("scanning")
		
		

func _on_Nearby_body_entered(body):
	if body.name == 'Player':
		change_state("hiding")


func _on_Nearby_body_exited(body):
	if body.name == 'Player':
		change_state("scanning")
