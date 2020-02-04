extends RigidBody

var inicial_pos:Vector3

func _ready():
	inicial_pos = translation

func _physics_process(delta):
	var bodies = get_colliding_bodies()
	for body in bodies:
		if body.is_in_group("wall"):
			get_tree().reload_current_scene()
