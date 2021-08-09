extends Node


var speed_previous := 0.0
var angle_previous := 0.0
var vel_previous  := Vector2.ZERO

var speed := 0.0 			setget set_speed
var angle := 0.0 			setget set_angle
var vel   := Vector2.ZERO	setget set_vel
onready var kinematic_node	: KinematicBody2D 	= $KinematicBody2D
onready var smooth_node 	: Node2D			= $Smooth

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
	
#var first_phy_iter_of_frame = false
var iter_of_frame := 0
var first_iter_of_frame := false
var first_iter_of_frame_tick :=0
var current_iter_tick := 0
var current_frame_tick := 0
var last_frame_tick := 0
var move_reminder := Vector2.ZERO
var rota_reminder := 0.0
var rotation_reminder := 0.0
var moved := Vector2.ZERO
var rotated := 0.0
#var complete_iteration_move := Vector2.ZERO
#var last_iter_move:= Vector2.ZERO
var previous_kinematic_position := Vector2.ZERO
var previous_kinematic_rotation := 0.0

func _process(delta):
	
	var tmp = smooth_node.position
	
	last_frame_tick = current_frame_tick
	current_frame_tick = OS.get_ticks_usec()
	
#	if first_frame_of_iter==false:
#		first_frame_of_iter = true

	var time_delta := 0.0
	if iter_of_frame>0: 
			
		move_reminder = Vector2.ZERO
		moved = Vector2.ZERO
		smooth_node.position = previous_kinematic_position
		smooth_node.rotation = previous_kinematic_rotation

		#time_delta = (float(current_frame_tick)-float(current_iter_tick)) / (1000000.0/float(Engine.iterations_per_second))
		time_delta = Engine.get_physics_interpolation_fraction()
		time_delta = clamp (time_delta, 0.0 ,1.0)
#		prints ("iter", time_delta)
		
#		smooth_node.position += (move_reminder-moved)
		moved = Vector2.ZERO
		smooth_node.position = smooth_node.position.linear_interpolate(kinematic_node.position, time_delta)
		move_reminder  = kinematic_node.position  - smooth_node.position
		
#		smooth_node.rotation += (rota_reminder-rotated)
		rotated = 0.0
		smooth_node.rotation = lerp_angle(smooth_node.rotation, kinematic_node.rotation, time_delta)
		rota_reminder = kinematic_node.rotation - smooth_node.rotation
		if abs (rota_reminder) > PI:
			rota_reminder = wrapf(rota_reminder, -PI, PI)

	else: 
		time_delta = (float(current_frame_tick)-float(last_frame_tick)) / (1000000.0/float(Engine.iterations_per_second))
		time_delta = clamp (time_delta, 0 ,1.0)
		var delta_move = move_reminder*time_delta
		smooth_node.position  = smooth_node.position + delta_move
#		moved += delta_move
		
		var delta_rota = rota_reminder*time_delta
		smooth_node.rotation  = smooth_node.rotation+ delta_rota
#		rotated += delta_rota
	
	
#	prints (
#		iter_of_frame,
#		"physic interpo fract :", Engine.get_physics_interpolation_fraction(),
#		"current_iter_tick :", current_iter_tick,
#		"frame_tick :", last_frame_tick, current_frame_tick,
#		"time_delta :", time_delta,
#		"smooth pos :",
#		tmp,
#		smooth_node.position,
#		smooth_node.position-tmp,
#		"kine pos", kinematic_node.position
#	)
	
	iter_of_frame = 0
	first_iter_of_frame = false
		



func _physics_process(delta):
	
	current_iter_tick = OS.get_ticks_usec()

	iter_of_frame +=1

	if first_iter_of_frame == false:
		first_iter_of_frame_tick = current_iter_tick
		first_iter_of_frame = true
	previous_kinematic_position = kinematic_node.position
	previous_kinematic_rotation = kinematic_node.rotation

	
	
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


