extends Node

onready var Main = get_node("/root/Main")

var board_pieces = Array()
var dimension = Vector2(8,8)

var board_state = null

var piece_clicked_on

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
