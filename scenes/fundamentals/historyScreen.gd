extends CanvasLayer

var text = preload("res://scenes/fundamentals/details/textBoxInHistory.tscn")
var atBottom = false


func _ready():
	vn.inSetting = true
	var container = $ScrollContainer/textContainer
	for i in game.history.size():
		var textbox = text.instance()
		var temp = game.history[i]
		var c = chara.all_chara[temp[0]]
		textbox.setName(c.display_name, c.default_color)
		textbox.setText(temp[1])
		container.add_child(textbox)

func _on_returnButton_pressed():
	vn.inSetting = false
	self.queue_free()

func _process(_delta):
	if not atBottom:
		var scrollContainer = $ScrollContainer
		var bar = scrollContainer.get_v_scrollbar()
		scrollContainer.set_v_scroll(bar.max_value)
		atBottom = true
		
	if Input.is_action_pressed("ui_cancel"):
		vn.inSetting = false
		self.queue_free()
