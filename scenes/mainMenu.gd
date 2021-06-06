extends CanvasLayer

var settingsScreen = preload("res://scenes/fundamentals/settings.tscn")
var loadScreen = preload("res://scenes/fundamentals/loadScreen.tscn")


#------------------------------------------------------------------------------
func _ready():
	# no need to read quit message to quit the game in main menu
	get_tree().set_auto_accept_quit(true)

# if you want to start from a non-sample scene, then change
# _on_newGameButoon_pressed() below

func _on_exitButton_pressed():
	get_tree().quit()

func _on_settingsButton_pressed():
	self.add_child(settingsScreen.instance())

func _on_newGameButton_pressed():
	game.load_instruction = "new_game"
	var error = get_tree().change_scene(vn.start_scene_path)
	if error == OK:
		self.queue_free()


func _on_loadButton_pressed():
	self.add_child(loadScreen.instance())

