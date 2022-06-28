extends LineEdit

var FEN_raw = ""

func _ready():
	connect("text_entered", self, "on_enter_pressed")
	$TextureButton.connect("pressed", self, "button_pressed")
	self.text = ""
	$Label.text = ""
	GameManager.input_node = self
	
func on_enter_pressed(fen):
	FEN_raw = fen
	# Changes label to clear
	self.text = ""
	$Label.text = ""
	# Converts FEN into Chess Loader format
	GameManager.raw_convert(FEN_raw)


	
func button_pressed():
	on_enter_pressed(self.text)


