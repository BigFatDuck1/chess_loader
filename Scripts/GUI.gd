extends Control

var solution_state = 0 # 0=hidden, 1=show

func _ready():
	$Solution.visible_characters = 0
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

# File browser
func load_button_pressed():
	var input_text = $Browser.text
	browser_text_entered(input_text)

func browser_text_entered(text):
	var load_check = GameManager.load_file(text)
	if load_check == false:
		$LoadError.text = "Error!"
	else:
		$Browser.text = ""
		$LoadError.text = ""
		$ProblemNumber.max_value = GameManager.total_number
		$ProblemNumber.value = 0

# Problem scroller
func play_pressed():
	if GameManager.total_number != 0:
		GameManager.problem_number = $ProblemNumber.value - 1
		GameManager.load_current_set(GameManager.problem_number)
		$ProblemError.text = ""
	elif GameManager.total_number == 0:
		$ProblemError.text = "No file loaded!"



func show_hide_pressed():
	if solution_state == 0: #hidden
		solution_state = 1
		$Solution.visible_characters = -1
	elif solution_state == 1: #showing
		solution_state = 0
		print("show")
		$Solution.visible_characters = 0

