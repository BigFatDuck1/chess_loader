extends Node

# Nodes
onready var Main = get_node("/root/Main")
var input_node # FENInput is stored here
var gm = self

# Board info
var board_pieces = Array()
var dimension = Vector2(8,8)
var database = "res://Database/" # File path for .json

# File info
var json_data # The file itself
var file_name
var board_state = null # Same as FEN_clear
var FEN_clear = [] # Array that stores each piece on the board ("white rook" etc)
var total_number = 0 # Total number of problems in JSON
var problem_number = 0
var turn # Whose turn it is
var solution = null
var text = null # Additional information, see "text" in JSON file

# Recognizes the number in FEN string
var numbers = ["1","2","3","4","5","6","7","8"]

# Converts FEN to file name
var piece_dict = {
	"P": "white_pawn",
	"R": "white_rook",
	"N": "white_knight",
	"B": "white_bishop",
	"Q": "white_queen",
	"K": "white_king",
	"p": "black_pawn",
	"r": "black_rook",
	"n": "black_knight",
	"b": "black_bishop",
	"q": "black_queen",
	"k": "black_king",
	"c": "clear_clear"
}

func _ready():
	load_file("Sample1.json") # Debug
	pass

func load_file(file_path):
	json_data = get_json(database + file_path)
	if json_data == []:
		total_number = 0
		return false
	else:
		file_name = file_path
		# Loads current set's data into autoload
		load_current_set(0)
		# Sets total number of problems in GUI
		GameManager.total_number = json_data.size()
		Main.get_node("GUI/Total").text = "/" + str(total_number)
		Main.get_node("GUI/ProblemError").text = ""
		#OS.shell_open("") # Opens file explorer
		return true

func load_current_set(n):
	problem_number = n + 1 
	raw_convert(json_data[n]["FEN"])
	GameManager.turn = json_data[n]["Turn"]
	GameManager.solution = json_data[n]["Solution"]
	GameManager.text = json_data[n]["Text"]
	# Sets who to play
	if turn == "w":
		Main.get_node("Board/AnimatedSprite").visible = true
		Main.get_node("Board/AnimatedSprite").frame = 0
	elif turn == "b":
		Main.get_node("Board/AnimatedSprite").visible = true
		Main.get_node("Board/AnimatedSprite").frame = 1
	else:
		Main.get_node("Board/AnimatedSprite").visible = false
	# Sets title
	Main.get_node("GUI/Title").bbcode_text = "[center]" + file_name + "[/center]" + " - " + str(problem_number)
	# Sets solution
	show_solution()
	
func show_solution():
	Main.get_node("GUI/Solution").text = (
		"\n" + GameManager.text + "\n\n" + GameManager.solution
	)
	
func FEN_ready():
	board_reset()
	fill_array()
	fill_board()

func fill_array():
	for x in range(dimension.x * dimension.y):
		board_pieces.append(Piece.new(board_state[x]))

func fill_board():
	# Remember to set Vseparation and Hseparation on Theme Overrides->Constants to 0
	for x in range(dimension.x * dimension.y):
		Main.get_node("Board/GridContainer").add_child(board_pieces[x])

func board_reset():
	board_pieces = []
	var child_array = Main.get_node("Board/GridContainer").get_children()
	for child in child_array:
		child.queue_free()

func raw_convert(text):
	FEN_clear = []
	# 1. Convert all numbers into clear
	var clear_number
	for i in text:
		if i == " ":
			break
		if numbers.has(i):
			for n in int(i):
				FEN_clear.append("c")
		else:
			FEN_clear.append(i)
	
	# 2. Remove all backslashes
	while "/" in FEN_clear:	
		FEN_clear.erase("/")
	
	# 3. Replace all FEN notation with file name
	for n in range(FEN_clear.size()):
		if FEN_clear.size() != 64:
			input_node.get_node("Label").text = "Try again!"
			break
		FEN_clear[n] = piece_dict[FEN_clear[n]]
	
	if FEN_clear.size() == 64:
		GameManager.board_state = FEN_clear
		GameManager.FEN_ready()
	else:
		input_node.get_node("Label").text = "Input not registered! Try again!"

func get_json(filename):
	var file = File.new()
	if not file.file_exists(filename):
		var error = []
		return error
	else:
		file.open(filename, File.READ) # Put directory in filename
		var raw_text = file.get_as_text()
		var data = parse_json(raw_text)
		file.close()
		return data
	
