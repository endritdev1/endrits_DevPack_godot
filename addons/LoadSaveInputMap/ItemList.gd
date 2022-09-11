tool
extends ItemList
#-----------------------------------Singals-----------------------------------*/
signal mySelectedText(nomeFileSelezionato)

#------------------------------------Vars ------------------------------------*/
const dirPath = "inputMapsSaves"
var documents 
var selectedItemIndex = [-1]
var justSelected

#-----------------Initializing vars and updating list on start-----------------*/
func _ready():
	documents = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS)
	updateItems()

func _physics_process(delta):
#-----------------Emitting a signal with the selected fileName-----------------*/
	if get_selected_items():
		justSelected = get_selected_items()
		if justSelected[0] != selectedItemIndex[0] :
			emit_signal("mySelectedText",get_item_text(justSelected[0]))
			selectedItemIndex = get_selected_items()

#------------------------------Updating file list------------------------------*/
func updateItems():
	clear()
	add_item("Default")
	var myDir = Directory.new()
	myDir.open(documents)
	if myDir.dir_exists(dirPath):
		myDir.open(documents+"/"+dirPath)
		myDir.list_dir_begin()
		var fileNamee = myDir.get_next()
		while fileNamee != "":
			if fileNamee.ends_with(".input"):
#				print(fileNamee)
				add_item(fileNamee)
			fileNamee = myDir.get_next()
#		print("dir exists ZIO")
		myDir.list_dir_end()
	else:
#		print("dir doesn't exists ZIO")
		myDir.make_dir(dirPath)

