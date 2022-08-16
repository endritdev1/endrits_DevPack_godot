tool
extends Button
signal clicked()

func _on_Button_pressed():
	emit_signal("clicked")
