extends Control


func _ready():
	pass


func _on_Start_Button_pressed():
	get_tree().change_scene("res://Scenes/World.tscn")
	pass # Replace with function body.


func _on_Quit_Button_pressed():
	get_tree().quit()
	pass # Replace with function body.
