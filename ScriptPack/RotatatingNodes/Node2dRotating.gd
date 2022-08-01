tool
extends Node2D
class_name Node2DRotating, "res://ScriptPack/RotatatingNodes/Node2dRotatingIcon.svg"
#*******************************************************************************/
#-------------------------------Rotation Script -------------------------------*/
#-----------------------------by Yellow Hat Games-----------------------------*/
#********************************************************************HELP DOWN*/

#-------------------------------Just some variable-------------------------------*/
export (float) var rotationSpeed = 1
export (String,"clockWise","antiClockWise") var rotationVerse 
export var preview = false
export var active = false


func _process(delta):
#----------------------------Working in the editor----------------------------*/
	if Engine.editor_hint:
		if preview:
			rotateNode(delta)
#-------------------------------Working on game-------------------------------*/
	if not Engine.editor_hint:
		if active:
			rotateNode(delta)

#--------------------------------startRotating--------------------------------*/
func start(speed:float = 1,verse:int = 1):
	if speed != 1:
		rotationSpeed = speed
	if verse == -1:
		rotationVerse = "antiClockWise"
	if verse == 1 :
		rotationVerse = "clockWise"
	active = true
	
func stop(stop:bool = false):
	active = stop

#------------------------------Rotating function------------------------------*/
func rotateNode(delta):
	if rotationVerse == "clockWise":
		rotation += rotationSpeed*delta
	elif rotationVerse == "antiClockWise":
		rotation -= rotationSpeed*delta


#*******************************************************************************/
#---------------------------------HELP SECTION---------------------------------*/
#*******************************************************************************/

#-----------------------------------PREVIEW-----------------------------------*/
# By checking the preview you'll see the rotation in action in the editor
# It may require reloading the scene to work
# Preview doesn't mean active in game

#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<ACTIVE>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>*/
# Check this box to make it work in game

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>SPEED<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<*/
# The speed it's going to rotate
# Can be a flat
# It's moltiplyed by delta so it's affected by time scale

#--------------------------------ROTATION VERSE--------------------------------*/
# You can chose if the node will rotate in clockwise or antiClockWise

#--------------------------------START AND STOP--------------------------------*/
# You can call the start() and stop() functions
# Start (speed:1 by default, verse: 1 by default)
# You can specify speed value inside start if not it's going to use the variable
# you can specify verse of rotation on start 1==clockwise , -1 antiClockWise
# Stop() stops your rotation
#*******************************************************************************/

