extends Node

var all_chara = {}

func _ready():
	# define all your game characters here.
	# You can also change the scale of your character here. For example,
	# var test = character.new("test", "test")
	# test.change_scale(Vector2(0.7,0.7))
	
	# Default Narrator. 
	var narrator = character.new(vn.narrator_display_name, vn.narrator_UID)
	narrator.in_all = false
	narrator.apply_highlight = false
	# format: (display_name, unique_id, Color)
	
	# Your characters...
	var female = character.new("A", "female", Color(0,0,0))
	female.in_all = true
	female.apply_highlight = true
	var test2 = character.new("B", "test2", Color(0,255,0))
	test2.in_all = true
	test2.apply_highlight = true

#----------------------------------------------------------------------------

