extends Node


var speed_previous := 0.0
var angle_previous := 0.0
var vel_previous  := Vector2.ZERO

var speed := 0.0 			setget set_speed
var angle := 0.0 			setget set_angle
var vel   := Vector2.ZERO	setget set_vel
onready var kinematic_node	: KinematicBody2D 	= $KinematicBody2D


func set_speed(new_value):
	speed_previous = speed
	speed = new_value
	
func set_angle(new_value):
	angle_previous = angle
	angle = new_value

func set_vel(new_value):
	vel_previous = vel
	vel = new_value


func _ready():
	angle = kinematic_node.rotation
	

func _physics_process(delta):

#	self.angle += deg2rad( (Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left"))*150*delta )  #1 degré en radian *3
	var tmp_angle = angle + ( (Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left"))*(TAU/2)*delta)  #1 degré en radian *3
	self.angle = wrapf(tmp_angle, 0, TAU)
#	print (self.angle) 
	self.speed += (Input.get_action_strength("ui_up") - Input.get_action_strength("ui_down")) * 2000 *delta
	move_it()
		
	

func move_it():
	kinematic_node.rotation = lerp_angle(kinematic_node.rotation,angle, 0.2)
	speed = clamp (speed, -500, 1000)
#	speed = lerp (speed,0.0,0.04)
	vel = Vector2(0,-speed).rotated(kinematic_node.rotation)
	kinematic_node.move_and_slide(vel)


