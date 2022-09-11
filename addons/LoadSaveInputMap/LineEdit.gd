extends LineEdit



func _on_LineEdit_text_changed(new_text):
	if !new_text.is_valid_filename() or "!" in new_text:
		print(new_text.substr(0,new_text.length()-1))
		text = new_text.substr(0,new_text.length()-1)

