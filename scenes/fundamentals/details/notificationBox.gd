extends TextureRect

#--------------Important----------------
# This has to be a child, becuase otherwise
# on noButton pressed won't get a parent
#---------------------------------------

var following = false
var dragging_start_pos = Vector2()

func _on_notificationBox_gui_input(event):
	if event is InputEventMouseButton:
		if event.get_button_index() == 1:
			following = !following
			dragging_start_pos = get_local_mouse_position()


func _process(_delta):
	if following:
		self.rect_position = (get_global_mouse_position() - dragging_start_pos)


func _on_noButton_pressed():
	notif.hide()
	self.queue_free()

func _on_yesButton_pressed():
	get_tree().quit()



