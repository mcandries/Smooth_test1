extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$ITS_Value.text = str (Engine.iterations_per_second)
	$FPS_Value.text = str (Engine.get_frames_per_second())



func _on_Button_pressed():
	if int($ITS_Edit.text)>0 and int($ITS_Edit.text)<240:
		Engine.iterations_per_second = int ($ITS_Edit.text)
		


func _on_Button_FPS_pressed():
	if int($FPS_Edit.text)>0 and int($FPS_Edit.text)<240:
		Engine.target_fps = int ($FPS_Edit.text)
	pass # Replace with function body.
