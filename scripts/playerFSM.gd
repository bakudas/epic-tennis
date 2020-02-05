extends StateMachine

signal shoot_ball

func _ready():
	add_state("idle")
	add_state("up")
	add_state("down")
	add_state("side")
	add_state("side_up")
	add_state("side_down")
	add_state("load")
	add_state("play")
	add_state("jump")
	call_deferred("set_state", states.idle)
	
func _input(event):
	if !parent.hitting:
		if event.is_action_pressed("p1_shoot"):
			parent.hitting = true
	else:
		if event.is_action_pressed("p1_cancel"):
			parent.hitting = false

func _state_logic(delta):
	parent._controls(delta)
	parent._is_hitting()
	
func _get_transition(delta):
	var move:Dictionary = {
		"idle" : parent.motion.z == 0 && parent.motion.x == 0,
		"up" : parent.motion.z < 0 && parent.motion.x == 0,
		"down" : parent.motion.z > 0 && parent.motion.x == 0,
		"side" : parent.motion.z == 0 && parent.motion.x != 0,
		"side_up" : parent.motion.z < 0 && parent.motion.x != 0,
		"side_down" : parent.motion.z > 0 && parent.motion.x != 0,
		"load" : parent.hitting && parent.shoot,
		"play" : parent.shoot && !parent.hitting,
		"jump" : null,
	}
	
	match (state):
		_:
			if move.up:
				return states.up
			elif move.down:
				return states.down
			elif move.side:
				return states.side
			elif move.side_up:
				return states.side_up
			elif move.side_down:
				return states.side_down
			elif move.load:
				return states.play
			elif move.play:
				return states.idle
			elif move.jump:
				return states.jump
	return null
	
func _enter_state(new_state, old_state):

	match(new_state):
		states.idle:
			parent.anim.play("idle")
		states.side:
			parent.anim.play("walk")
		states.side_up:
			parent.anim.play("walk_up")
		states.side_down:
			parent.anim.play("walk_down")
		states.up:
			parent.anim.play("up")
		states.down:
			parent.anim.play("up")
		states.load:
			parent.anim.play("load")
		states.play:
			if parent.bola.translation.x < parent.translation.x:
				parent.anim.play("backhand")
			else:
				parent.anim.play("forehand")
		
func _exit_state(new_state, old_state):
	pass
	
func _check_player_dir(dir:String):
	pass

func _on_range_body_entered(body):
	var bola:Node = get_parent().get_node("../bola")
	var target:Node = get_parent().get_node("../aim_target")
	var dir:Vector3 = target.translation - parent.translation

	if body.is_in_group("ball"):
			parent.hitting = false
			parent.shoot = true
			target.translation = target.inicial_pos
			body.set_linear_velocity(dir.normalized() * parent.force + parent.ball_dir)
