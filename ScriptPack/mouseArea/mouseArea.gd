tool
extends Area2D
class_name MouseArea, "res://ScriptPack/mouseArea/icon_mouseArea.svg"

#*******************************************************************************/
#--------------------------------Mouse Pointer--------------------------------*/
#*********************************************************************HELP DOWN*/

#-----------------------------------Signals-----------------------------------*/
signal mouseOver(node)
signal mouseNotOver()

#---------------------------Exporting some variables---------------------------*/
export (Texture) var normalMousePointer 
#export (Texture) var overMousePointer # Nod used yet
export (bool) var collisionShape = false
export (bool) var hideMouse = false
export (bool) var active = false
#-------------------------------Other variables-------------------------------*/
var spriteExists = false
var collisionBoxExists = false

#----------------------------Initializing the mouse----------------------------*/
#-------------Calling functions to create sprite and collision box-------------*/
func _ready():
	if not Engine.editor_hint:
		if !spriteExists and !collisionBoxExists:
			newMouseImage()
			newHitBox()
		if active:
			if hideMouse:
				Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
#------------------------------Connecting Signals------------------------------*/
		if collisionBoxExists:
			connect("area_entered",self,"areaEntred")
			connect("area_exited",self,"areaExit")
			connect("body_entered",self,"bodyEntred")
			connect("body_exited",self,"bodyExit")

#---------------------------------Running code---------------------------------*/
func _process(delta):
	if not Engine.editor_hint:
		if active:
			position = get_global_mouse_position()
#--------------------------Running code in the editor--------------------------*/
#-----------Creating dinamically the sprite and the collision shape-----------*/
	if Engine.editor_hint:
		if normalMousePointer:
			if !spriteExists:
				newMouseImage()
		if normalMousePointer == null:
			if spriteExists:
				for child in get_children():
					if child is Sprite:
						child.queue_free()
				spriteExists = false
		if collisionShape:
			if !collisionBoxExists:
				newHitBox()
		else:
			if collisionBoxExists:
				for child in get_children():
					if child is CollisionShape2D:
						child.queue_free()
				collisionBoxExists = false


#------------------------------Create Mouse Image------------------------------*/
func newMouseImage():
	if normalMousePointer:
		var newM = Sprite.new()
		newM.set_texture(normalMousePointer)
		add_child(newM)
		spriteExists = true

#-----------------------------Create Mouse Hitbox-----------------------------*/
func newHitBox():
	var newH = CollisionShape2D.new()
	newH.set_shape(CircleShape2D.new())
	add_child(newH)
	collisionBoxExists = true
 
#--------------------Functions to connect and emit signals--------------------*/
func areaEntred(body):
	emit_signal("mouseOver",body)

func bodyEndtred(body):
	emit_signal("mouseOver",body)

func bodyExit():
	emit_signal("mouseNotOver")

func areExit():
	emit_signal("mouseNotOver")




#*******************************************************************************/
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>HELP SECCTION<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<*/
#*******************************************************************************/

#-----------------------------SETTING THE TEXTURE-----------------------------*/
# Just drag and drop a texture and put it on the normal mouse pointer

#-------------------------------COLLISION SHAPE-------------------------------*/
# Checking the collision shape checkbox, it'll create a round collisionBox
# Other shapes will be aviable in future
# Other dimensions will be aviable in the future
# There's no functionallity yet to this

#---------------------------------HIDE MOUSE ---------------------------------*/
# By checking Hide Mouse it will hide the mouse in game

#------------------------------------ACTIVE------------------------------------*/
# By checking active it makes the pointer actually active in game
# The mouseArea will fallow the global mouse positition 
#*******************************************************************************/
