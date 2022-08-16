tool
extends EditorPlugin

#*******************************************************************************/
#----------------------------Save And Load InputMap----------------------------*/
#--------------------PLEASE BE AWARE THIS MIGHT BE INSTABLE--------------------*/
#-----------------------THIS MIGHT CORRUPT YOUR PROJECT -----------------------*/
#---------LOAD THE INPUT MAP BEFORE YOU START WORKING ON YOUR PROJECT---------*/
#*******************************************************************************/


var button = preload("res://addons/LoadSaveInputMap/Button.tscn").instance() 

#-------------------------------Entring the tree-------------------------------*/
#------------------------------Connecting signals------------------------------*/
func _enter_tree():
	add_control_to_container(EditorPlugin.CONTAINER_PROJECT_SETTING_TAB_RIGHT,button)
	button.get_node("Button").connect("clicked",self,"SaveProjectFile")
	button.get_node("Load").connect("loadSignal",self,"LoadInputMap")
#--------------------------Removing plugin from tree--------------------------*/
func _exit_tree():
	remove_control_from_docks(button)
	button.free()

#------------------------------Saving Input File------------------------------*/
func SaveProjectFile():
#--------------------Loading project.godot as a config file--------------------*/
	var newPF = ConfigFile.new()
	newPF.load("res://project.godot")
#----------------------Checking if "input" section exists----------------------*/
	if newPF.has_section("input"):
#--------------------------Checking the next section--------------------------*/
		var nextSection = myNextSection(newPF)
#---------------------Loading project.godot as a text file---------------------*/
		var newFile = File.new()
		newFile.open("res://project.godot", File.READ)
		var asAText = newFile.get_as_text()
		var subStringInput = asAText.substr(asAText.find("[input]",0))
		var myInputs
		if nextSection != "Null":
			myInputs = subStringInput.left(subStringInput.find("[",nextSection,"]"))
		else:
			myInputs = subStringInput
		var myInputFile = File.new()
#-------------------------------Saving inputFile-------------------------------*/
		myInputFile.open("addons/LoadSaveInputMap/myInputMap.input",File.WRITE)
#		print(myInputs)
		myInputFile.store_line(myInputs)
		myInputFile.close()
		print("Input Map Saved")
	else:
		print ("Error No Input Map Aviable")

#----------------------------Loading the Input Map----------------------------*/
func LoadInputMap():
	var openFile = File.new()
	if not openFile.file_exists("addons/LoadSaveInputMap/myInputMap.input"):
		print("Error - InputMapFile not found!")
		return
	openFile.open("addons/LoadSaveInputMap/myInputMap.input",File.READ)
	var godotProjectConfig = ConfigFile.new()
	godotProjectConfig.load("project.godot")
	if godotProjectConfig.has_section("input"):
		godotProjectConfig.erase_section("input")
		godotProjectConfig.save("project.godot")
		print("myconfi is done")
		var ProjectFileAsText = File.new()
		ProjectFileAsText.open("project.godot", File.READ_WRITE)
		var myContent = ProjectFileAsText.get_as_text()
		ProjectFileAsText.store_string(str(myContent," ", openFile.get_as_text()))
		print("Input Map Loaded")
	else:
		var ProjectFileAsText = File.new()
		ProjectFileAsText.open("project.godot", File.READ_WRITE)
		var myContent = ProjectFileAsText.get_as_text()
		ProjectFileAsText.store_string(str(myContent," ", openFile.get_as_text()))
		print("Input Map Loaded")
	openFile.close()

#----------------------Calculating positions and sections----------------------*/
func myNextSection(dati):
	var myNextSection = dati.get_sections()
	var inputPosition = myNextSection.find("input")
	var poolDim = myNextSection.size()
	if poolDim-1 > inputPosition:
		print("We're Doing Ok :",poolDim) 
		var nextPosition = myNextSection[inputPosition+1]
		return nextPosition
	elif poolDim-1 == inputPosition:
		print("There's No other section Fallowing")
		return "Null"

#*******************************************************************************/
