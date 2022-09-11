tool
extends EditorPlugin

#*******************************************************************************/
#----------------------------Save And Load InputMap----------------------------*/
#--------------------PLEASE BE AWARE THIS MIGHT BE INSTABLE--------------------*/
#-----------------------THIS MIGHT CORRUPT YOUR PROJECT -----------------------*/
#---------LOAD THE INPUT MAP BEFORE YOU START WORKING ON YOUR PROJECT---------*/
#*******************************************************************************/

#-----------------------------------Signals-----------------------------------*/
signal callAlert(text)

#-------------------------------------Vars-------------------------------------*/
var button = preload("res://addons/LoadSaveInputMap/Button.tscn").instance() 
const dirName = "inputMapsSaves"
var documents
var newFileName
var fileSelected = null

#-------------------------------Entring the tree-------------------------------*/
#------------------------------Connecting signals------------------------------*/
func _enter_tree():
	add_control_to_container(EditorPlugin.CONTAINER_PROJECT_SETTING_TAB_RIGHT,button)
	documents = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS)
	checkForDirectory()
	button.get_node("Button").connect("clicked",self,"SaveProjectFile")
	button.get_node("Load").connect("loadSignal",self,"LoadInputMap")
	button.get_node("LineEdit").connect("text_changed",self,"updateNewFileName")
	self.connect("callAlert",self,"callAlert")
	button.get_node("MainContainer/ItemList").connect("mySelectedText",self,"updateMySelection")
	
#--------------------------Removing plugin from tree--------------------------*/
func _exit_tree():
	remove_control_from_container(EditorPlugin.CONTAINER_PROJECT_SETTING_TAB_RIGHT,button)
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
			myInputs = subStringInput.left(subStringInput.find(str("[",nextSection,"]"),0))
		else:
			myInputs = subStringInput
		var myInputFile = File.new()
#-------------------------------Saving inputFile-------------------------------*/
		myInputFile.open(documents+"/"+dirName+"/"+newFileName+".input",File.WRITE)
		myInputFile.store_line(myInputs)
		myInputFile.close()
		button.get_node("MainContainer/ItemList").updateItems()
		print("Input Map Saved")
		emit_signal("callAlert","Inputmap saved successfully")
	else:
		print ("Error No Input Map Aviable")

#----------------------------Loading the Input Map----------------------------*/
func LoadInputMap():
	if fileSelected == null:
		emit_signal("callAlert","Please select a valid file ")
		return
	var openFile = File.new()
	if fileSelected != "Default":
		if not openFile.file_exists(documents+"/"+dirName+"/"+fileSelected):
			emit_signal("callAlert","File Not Found")
			return
		openFile.open(documents+"/"+dirName+"/"+fileSelected,File.READ)
	else:
		if not openFile.file_exists("res://addons/LoadSaveInputMap/myInputMap.input"):
			emit_signal("callAlert","File Not Found")
			return
		openFile.open("res://addons/LoadSaveInputMap/myInputMap.input",File.READ)
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
	emit_signal("callAlert","InputMap loaded, please reload your project!")
	
#----------------------Calculating positions and sections----------------------*/
func myNextSection(dati):
	var myNextSection = dati.get_sections()
	var inputPosition = myNextSection.find("input")
	var poolDim = myNextSection.size()
	if poolDim-1 > inputPosition:
#		print("We're Doing Ok :",poolDim) 
		var nextPosition = myNextSection[inputPosition+1]
		return nextPosition
	elif poolDim-1 == inputPosition:
#		print("There's No other section Fallowing")
		return "Null"

#*******************************************************************************/
#--------------------------Check if directory exists--------------------------*/
#*******************************************************************************/
func checkForDirectory():
	var myDir = Directory.new()
	myDir.open(documents)
	if !myDir.dir_exists(dirName):
		myDir.make_dir(dirName) 

#-----------------------------Update new File Name-----------------------------*/
func updateNewFileName(newName):
#	var notUse = ["\\","!","\"","£","$","&"]
	if newName.length() > 0:
		if newName.is_valid_identifier():
			newFileName = newName
#			print("It's a valid filename")
		else:
			var caretPos = newName.length()
#			print("were inside the not allowed string")
			button.get_node("LineEdit").text = newName.substr(0,newName.length()-1)
			button.get_node("LineEdit").set_cursor_position(caretPos)
			emit_signal("callAlert","Only letters and numbers are allowed")
			button.get_node("LineEdit").emit_signal("text_changed",button.get_node("LineEdit").text)

#----------------------------------Call alert----------------------------------*/
func callAlert(text):
	button.get_node("MainContainer/alertPanel").modulate.a = 1
	button.get_node("MainContainer/alertPanel/Label").set_text(text)
#	print("Sto chiamando l'alert")

func updateMySelection(fileName):
	fileSelected = fileName
#	print(fileSelected)
