extends TextureRect

var following = false
var dragging_start_pos = Vector2()

signal decision(yes)

func _on_overrideBox_gui_input(event):
	if event is InputEventMouseButton:
		if event.get_button_index() == 1:
			following = !following
			dragging_start_pos = get_local_mouse_position()


func _process(_delta):
	if following:
		self.rect_position = (get_global_mouse_position() - dragging_start_pos)


func _on_noButton_pressed():
	emit_signal("decision", false)
	notif.hide()


func _on_yesButton_pressed():
	emit_signal("decision", true)
	notif.hide()

