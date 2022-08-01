extends RichTextLabel
var parent

func _ready():
	parent = get_parent().get_parent()


func _process(delta):
	set_text("")
	var myScript : GDScript = parent.get_script()
#	print(myScript.resource_path)
	if myScript:
		for proprertyInfo in myScript.get_script_property_list():
			var propertyName : String = proprertyInfo.name
			var propertyValue = parent.get((propertyName))
#			print(myScript.get(propertyName))
			add_text('%s = %s' % [propertyName,propertyValue])
			newline()
