extends Control

func setName(name, color):
	$HBoxContainer/speaker.set("custom_colors/font_color", color)
	$HBoxContainer/speaker.text = name + ": "
	

func setText(text):
	$HBoxContainer/text.bbcode_text = text
	
