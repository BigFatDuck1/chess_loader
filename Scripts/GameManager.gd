extends Node

onready var Main = get_node("/root/Main")
var input_node # FENInput is stored here

var board_pieces = Array()
var dimension = Vector2(8,8)

var json_data # The file itself
var board_state = null # Same as FEN_clear
var FEN_clear = [] # Array that stores each piece on the board ("white rook" etc)
var total_number # Total number of problems in JSON
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
	json_data = get_json("res://Database/Sample.json")
	raw_convert(json_data[0]["FEN"])
	GameManager.solution = json_data[0]["Solution"]
	GameManager.text = json_data[0]["Text"]
	#OS.shell_open("C:\\\\Users\\cleme\\Downloads") # Opens file explorer

func show_solution(solution):
	Main.get_node("GUI/Solution").text = solution
	

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
	file.open(filename, File.READ) # Put directory in filename
	var raw_text = file.get_as_text()
	var data = parse_json(raw_text)
	file.close()
	return data
	
