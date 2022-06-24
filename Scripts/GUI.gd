extends Control

var solution_state = 0 # 0=hidden, 1=show

func _ready():
	$Solution.visible_characters = 0
	$ShowHide.connect("pressed", self, "show_hide_pressed")
	show_solution()
	pass

func show_solution():
	if GameManager.solution != null:
		$Solution.text = (
			"\n" + GameManager.text + "\n\n" + GameManager.solution	
		)

func show_hide_pressed():
	if solution_state == 0: #hidden
		solution_state = 1
		$Solution.visible_characters = -1
	elif solution_state == 1: #showing
		solution_state = 0
		print("show")
		$Solution.visible_characters = 0
