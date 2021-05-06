extends Node

const FILE_NAME = "res://save_data.save"

var current_selected_skin_suffix = "_00"

var stored_data = {
	"skin": current_selected_skin_suffix,
}

func save():
	var file = File.new()
	file.open(FILE_NAME, File.WRITE)
	file.store_string(to_json(stored_data))
	file.close()
	
	
func loadData():
	var file = File.new()
	if file.file_exists(FILE_NAME):
		file.open(FILE_NAME, File.READ)
		var data = parse_json(file.get_as_text())
		file.close()
		if typeof(data) == TYPE_DICTIONARY:
			stored_data = data
