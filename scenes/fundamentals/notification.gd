extends CanvasLayer

var quit = preload("res://scenes/fundamentals/details/notificationBox.tscn")
var override = preload("res://scenes/fundamentals/details/overrideNotifBox.tscn")
var back2Main = preload("res://scenes/fundamentals/details/back2MainBox.tscn")




func clear():
	for n in get_node("currentNotif").get_children():
		n.queue_free()

func hide():
	vn.inNotif = false
	clear()
	get_node("backgroundColor").visible = false
	
func show(which : String) -> void:
	vn.inNotif = true
	get_node("backgroundColor").visible = true
	if which == "quit" :
		get_node("currentNotif").add_child(quit.instance())
	elif which == "override" :
		get_node("currentNotif").add_child(override.instance())
	elif which == "main":
		get_node("currentNotif").add_child(back2Main.instance())
	else:
		pass

func get_current_notif():
	return get_node("currentNotif").get_child(0)
