extends TextureButton

class_name Piece

# Struct
var file_name
var source # File path
	# These two combine to form the coordinate system e.g. d5
	# But convert the letter to a number
var letter 
var number


func _init(f):
	file_name = f
	source = load("res://Assets/Pieces/" + f + ".png")
	set_normal_texture(source)

