extends TextureRect

const FACESETS = [preload("res://Sprites/Faceset/Player_Faceset_Skin_00.png"),
				 preload("res://Sprites/Faceset/Player_Faceset_Skin_01.png")]
				
				
func _ready():
	Singleton.loadData()
	var selected_skin = Singleton.stored_data.skin
	match selected_skin:
		"_00":
			set_faceset_texture(FACESETS[0])
			
			
		"_01":
			set_faceset_texture(FACESETS[1])
			
			
func set_faceset_texture(selected_texture):
	texture = selected_texture
