tool
extends Button



func _on_helpBTN_pressed(): 
	get_parent().get_node("HelpContainer").visible = true
