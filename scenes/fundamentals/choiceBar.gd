extends TextureButton

signal choice_made(event)

var choice_action = null

func setup_choice_event(t: String, ev: Dictionary):
	get_node('text').bbcode_text = "[center]" + t + "[/center]"
	choice_action = ev

func _on_choiceBar_pressed():
	emit_signal("choice_made", choice_action)
