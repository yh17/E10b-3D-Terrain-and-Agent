extends Spatial

func _ready():
	pass

func _unhandled_input(event):
	if Input.is_action_pressed("Quit"):
		get_tree().quit()
