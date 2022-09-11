tool
extends Button
signal loadSignal

func _on_Button_pressed():
	emit_signal("loadSignal")
