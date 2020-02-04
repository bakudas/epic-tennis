extends KinematicBody
class_name bot

var speed:int = 400
var player_id:int = 1
var motion:Vector3 = Vector3.ZERO
var hitting:bool = false
var ball_dir:Vector3 = Vector3(0, 9, 0)
var targets:Array

export (float, .1, 1) var friccao:float = .1
export (float, .25, 1) var aceleracao:float = .25
export (float, 10, 100) var force:float = 19
export (NodePath) var target1:NodePath
export (NodePath) var target2:NodePath
export (NodePath) var target3:NodePath

onready var bola:Node = get_node("../bola")
onready var player:Node = get_node("../player")

func _ready():
	targets.append(get_node(target1))
	targets.append(get_node(target2))
	targets.append(get_node(target3))

func _physics_process(delta):
	
	if bola.translation.z < player.translation.z && bola.translation.z > translation.z:
		translation.x = bola.translation.x
	if translation.x != 0:
#		$AnimationPlayer.play("left")
		pass
	
	if hitting:
#		target.visible = true
		speed = 500
	else:
#		target.visible = false
		speed = 300
		move_and_slide(motion)
		

func _on_range_body_entered(body):

	if body.is_in_group("ball"):
		var dir:Vector3
		if targets != null:
			dir = targets[rand_range(0,3)].translation - translation
		body.set_linear_velocity(dir.normalized() * force + ball_dir)


