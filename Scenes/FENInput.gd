extends LineEdit

var FEN_raw = ""
var FEN_clear = []

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

var numbers = ["1","2","3","4","5","6","7","8"]

func _ready():
	connect("text_entered", self, "on_enter_pressed")

	
func on_enter_pressed(fen):
	FEN_raw = fen
	# Reset FEN_clear
	FEN_clear = []
	# Changes label to clear
	self.text = ""
	# Converts FEN into Chess Loader format
	raw_convert(FEN_raw)

func raw_convert(text):
	# 1. Convert all numbers into clear
	var clear_number
	for i in FEN_raw:
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
		FEN_clear[n] = piece_dict[FEN_clear[n]]
	
	GameManager.board_state = FEN_clear
	
	GameManager.FEN_ready()

