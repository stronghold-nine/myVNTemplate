extends TextureRect

var following = false
var dragging_start_pos = Vector2()

func _on_back2MainBox_gui_input(event):
	if event is InputEventMouseButton:
		if event.get_button_index() == 1:
			following = !following
			dragging_start_pos = get_local_mouse_position()


func _process(_delta):
	if following:
		self.rect_position = (get_global_mouse_position() - dragging_start_pos)


func _on_noButton_pressed():
	notif.hide()

func _on_yesButton_pressed():
	# It is possible that the player clicks return to main during some screen effects
	# that has not been removed yet. So here we remove those.
	screenEffects.removeTint()
	music.stop_bgm()
	stage.remove_chara('absolute_all')
	#----------------------------------------
	var error = get_tree().change_scene(vn.main_menu_path)
	if error == OK:
		vn.reset_states()
		notif.hide()
		
