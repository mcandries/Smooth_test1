extends Node


var speed := 0.0
var angle := 0.0
var vel   := Vector2.ZERO
onready var kinematic_node	: KinematicBody2D 	= $KinematicBody2D
onready var smooth_node 	: Node2D			= $Smooth


var iter_of_frame := 0
var current_frame_tick := 0
var last_frame_tick := 0
var move_reminder := Vector2.ZERO
var rota_reminder := 0.0
var previous_kinematic_position := Vector2.ZERO
var previous_kinematic_rotation := 0.0
var first_iter_of_frame := false

func _process(delta):
	
	var tmp = smooth_node.position
	
	last_frame_tick = current_frame_tick
	current_frame_tick = OS.get_ticks_usec()
	
	var time_delta := 0.0
	if iter_of_frame>0: 
		move_reminder = Vector2.ZERO
		smooth_node.position = previous_kinematic_position
		smooth_node.rotation = previous_kinematic_rotation

		time_delta = Engine.get_physics_interpolation_fraction()
		time_delta = clamp (time_delta, 0.0 ,1.0)

		smooth_node.position = smooth_node.position.linear_interpolate(kinematic_node.position, time_delta)
		move_reminder  = kinematic_node.position  - smooth_node.position
		
		smooth_node.rotation = lerp_angle(smooth_node.rotation, kinematic_node.rotation, time_delta)
		rota_reminder = kinematic_node.rotation - smooth_node.rotation
		if abs (rota_reminder) > PI:
			rota_reminder = wrapf(rota_reminder, -PI, PI)

	else: 
		time_delta = (float(current_frame_tick)-float(last_frame_tick)) / (1000000.0/float(Engine.iterations_per_second))
		time_delta = clamp (time_delta, 0 ,1.0)
		smooth_node.position  +=  move_reminder*time_delta
		smooth_node.rotation  +=  rota_reminder*time_delta

	iter_of_frame = 0
	first_iter_of_frame = false

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



func _physics_process(delta):
	
	iter_of_frame +=1
	previous_kinematic_position = kinematic_node.position
	previous_kinematic_rotation = kinematic_node.rotation

#	var tmp_angle = angle + ( (Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left"))*(TAU/2)*delta)
#	angle = wrapf(tmp_angle, 0, TAU)
	angle = angle + ( (Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left"))*(TAU/2)*delta)
	speed += (Input.get_action_strength("ui_up") - Input.get_action_strength("ui_down")) * 2000 *delta
	move_it()


func move_it():
	kinematic_node.rotation = lerp_angle(kinematic_node.rotation,angle, 0.2)
	speed = clamp (speed, -500, 1000)
#	speed = lerp (speed,0.0,0.04)
	vel = Vector2(0,-speed).rotated(kinematic_node.rotation)
	kinematic_node.move_and_slide(vel)


