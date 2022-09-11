tool
extends Panel

var coolDown = 1.0

func _physics_process(delta):
	self.rect_size.x = $Label.rect_size.x+5
	if modulate.a == 1:
		visible = true
		coolDown -= delta
	if modulate.a > 0 and coolDown <= 0:
		modulate.a -= 0.01
	if modulate.a < 0:
		modulate.a = 0
		visible = false
		coolDown = 1.0
