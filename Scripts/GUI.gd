extends Control

var solution_state = 0 # 0=hidden, 1=show

var loaded = 0

func _ready():
	$Solution.visible_characters = 0
	$Title.text = ""
	# Solution button
	$ShowHide.connect("pressed", self, "show_hide_pressed")
	# File Browser
	$Load.connect("pressed", self, "load_button_pressed")
	$Browser.connect("text_entered", self, "browser_text_entered")
	$LoadError.text = ""
	# Problem scroll
	$ProblemNumber.max_value = GameManager.total_number
	$Play.connect("pressed", self, "play_pressed")
	$ProblemError.text = ""
	# Next and Previous button
	$Next.connect("pressed", self, "next")
	$Previous.connect("pressed", self, "previous")
	# Random button
	$Random.connect("pressed", self, "shuffle")
	# Rotate button
	$Rotate.connect("pressed", self, "rotate")
	# Clears error message
	$ClearErrorMessages.connect("timeout", self, "clear_error_messages")

# File browser
func load_button_pressed():
	var input_text = $Browser.text
	browser_text_entered(input_text)

func browser_text_entered(text):
	var load_check = GameManager.load_file(text)
	if load_check == false:
		$LoadError.text = "Error!"
	else:
		loaded = 1
		$Browser.text = ""
		$LoadError.text = ""
		$ProblemNumber.max_value = GameManager.total_number
		$ProblemNumber.min_value = 1
		$ProblemNumber.value = 0

# Problem scroller
func play_pressed():
	if $ProblemNumber.value == 0:
		$ProblemError.text = "Problem doesn't exist!"
	elif GameManager.total_number != 0:
		GameManager.problem_number = $ProblemNumber.value - 1
		GameManager.load_current_set(GameManager.problem_number)
		$ProblemError.text = ""
		# So user won't accidentally show the next solution
		solution_state = 1
		show_hide_pressed()
		$ShowHide.pressed = false
	elif GameManager.total_number == 0:
		$ProblemError.text = "No file loaded!"
	GameManager.Main.get_node("FENInput").text = GameManager.raw_FEN

func next():
	$ProblemNumber.value += 1
	play_pressed()

func previous():
	$ProblemNumber.value -= 1
	play_pressed()

func shuffle():
	randomize()
	$ProblemNumber.value = randi()%GameManager.total_number + 1
	play_pressed()

# Solution button
func show_hide_pressed():
	if solution_state == 0: #hidden
		solution_state = 1
		$Solution.visible_characters = -1
	elif solution_state == 1: #showing
		solution_state = 0
		$Solution.visible_characters = 0

# Rotate button
func rotate():
	# Turn indicator
	if GameManager.Main.get_node("Board/AnimatedSprite").flip_v == true:
		GameManager.Main.get_node("Board/AnimatedSprite").flip_v = false
	elif GameManager.Main.get_node("Board/AnimatedSprite").flip_v == false:
		GameManager.Main.get_node("Board/AnimatedSprite").flip_v = true
	# Flip pieces
	var all_pieces = GameManager.Main.get_node("Board/GridContainer").get_children()
	if GameManager.Main.get_node("Board/GridContainer").rect_rotation == 0.0:
		GameManager.Main.get_node("Board/GridContainer").rect_rotation = 180.0
		for p in all_pieces:
			p.flip_v = true
	elif GameManager.Main.get_node("Board/GridContainer").rect_rotation == 180.0:
		GameManager.Main.get_node("Board/GridContainer").rect_rotation = 0.0
		for p in all_pieces:
			p.flip_v = false 
		
	
# Clears error messages after approximately 5 seconds
func clear_error_messages():
	if $ProblemError.text != "":
		$ProblemError.text = ""
	if $LoadError.text != "":
		$LoadError.text = ""
