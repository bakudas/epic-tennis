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
	match (state):
		states.idle:
			if parent.motion.x != 0:
				if parent.motion.z < 0:
					return states.side_up
				elif parent.motion.z > 0:
					return states.side_down
				return states.side
			elif parent.motion.z < 0:
					return states.up
			elif parent.motion.z > 0:
					return states.down
			elif parent.hitting:
				return states.load
		states.side:
			if parent.motion.z < 0:
					return states.side_up
			elif parent.motion.z > 0:
					return states.side_down
			elif parent.motion.x == 0:
				if parent.motion.z < 0:
					return states.up
				elif parent.motion.z > 0:
					return states.down
				else:
					return states.idle
			elif parent.hitting:
				return states.load 
		states.up:
			if parent.motion.x != 0:
				if parent.motion.z > 0:
					return states.side_down
				elif parent.motion.z < 0:
					return states.side_up
			elif parent.motion.x == 0:
				if parent.motion.z > 0:
					return states.down
				elif parent.motion.z == 0:
					return states.idle
			elif parent.hitting:
				return states.load
		states.down:
			if parent.motion.x != 0:
				if parent.motion.z < 0:
					return states.side_up
				else:
					return states.side
			elif parent.motion.x == 0:
				if parent.motion.z < 0:
					return states.up
				elif parent.motion.z == 0:
					return states.idle
			elif parent.hitting:
				return states.load
		states.side_up:
			if parent.motion.x == 0:
				if parent.motion.z == 0:
					return states.idle
				elif parent.motion.z < 0:
					return states.up
				elif parent.motion.z > 0:
					return states.down
			elif parent.motion.x != 0:
				if parent.motion.z > 0:
					return states.side_down 
				if parent.motion.z == 0:
					return states.side
			elif parent.hitting:
				return states.load
		states.side_down:
			if parent.motion.x == 0:
				if parent.motion.z == 0:
					return states.idle
				elif parent.motion.z < 0:
					return states.up
				elif parent.motion.z > 0:
					return states.down
			elif parent.motion.x != 0:
				if parent.motion.z < 0:
					return states.side_up
			elif parent.hitting:
				return states.load
		states.load:
			if parent.shoot and !parent.hitting:
				return states.play
			elif !parent.hitting and !parent.shoot:
				return states.idle
		states.play:
			if !parent.shoot:
				return states.idle
		states.jump:
			pass
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

func _on_range_body_entered(body):
	var bola:Node = get_parent().get_node("../bola")
	var target:Node = get_parent().get_node("../aim_target")
	var dir:Vector3 = target.translation - parent.translation

	if body.is_in_group("ball"):
			parent.hitting = false
			parent.shoot = true
			target.translation = target.inicial_pos
			body.set_linear_velocity(dir.normalized() * parent.force + parent.ball_dir)
