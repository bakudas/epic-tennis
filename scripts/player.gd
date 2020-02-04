extends KinematicBody
class_name player

var speed:int = 800
var player_id:int = 1
var motion:Vector3 = Vector3.ZERO
var hitting:bool = false
var shoot:bool = false
var ball_dir:Vector3 = Vector3(0, 11, 0)

export (float, .1, 1) var friccao:float = .1
export (float, .25, 1) var aceleracao:float = .25
export (float, 10, 100) var force:float = 23

onready var anim:Node2D = $AnimationPlayer
onready var sprite:Node2D = $render
onready var bola:Node = get_node("../bola")
onready var target:Node = get_node("../aim_target")

func _ready() -> void:
	
#	player_variables.player_stats["player_id"] += 1
	player_id = 1
	
	print("O jogador " + String(player_id) + " está pronto para jogar!")

func _is_hitting() -> void:
	if hitting:
		speed = 650
		target.move_and_slide(motion)
	else:
		target.visible = false
		speed = 300
		move_and_slide(motion)

func _shoot() -> void:
	if shoot:
		shoot = false
	else:
		shoot = true	
	
func _controls(delta) -> void:
	var play:bool
	var up:bool
	var down:bool
	var left:bool
	var right:bool
	var bola_pos = bola.translation
	
	match (player_variables.player_stats["player_id"]):
		_:
			play = Input.is_action_just_pressed("p" + String(player_id) + "_shoot")
			up = Input.is_action_pressed("p" + String(player_id) + "_up")
			down = Input.is_action_pressed("p" + String(player_id) + "_down")
			left = Input.is_action_pressed("p" + String(player_id) + "_left")
			right = Input.is_action_pressed("p" + String(player_id) + "_right")

	if left:
		motion.x = (-speed * delta) * 2
		sprite.flip_h = true
	elif right:
		motion.x = (speed * delta) * 2
		sprite.flip_h = false
	else:
		motion.x = 0 #motion.x * friccao

	if up:
		motion.z = -speed * delta
	elif down:
		motion.z = speed * delta
	else:
		motion.z = 0 #motion.z * friccao 

	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().reload_current_scene()
