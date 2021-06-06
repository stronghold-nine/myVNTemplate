extends Node

# Constants

# dialog
const max_dialog = 500 # might remove this constant later.
var max_dialog_display = 300 # only display 300. 
# If I allow user to change
# the max number to display, change this number, and max_dialog will be the 
# absolute max.

# Narrator
const narrator_UID = ''
const narrator_display_name = ''
# paths
const main_menu_path = "res://scenes/mainMenu.tscn"
const start_scene_path = "res://scenes/sampleScene.tscn"
const credit_scene_path = "" # if you have one
const ending_scene_path = "res://scenes/mainMenu.tscn" # by default, ending scene = go back to main
# default directories
const VOICE_DIR = "res://voice/"
const BGM_DIR = "res://bgm/"
const AUDIO_DIR = "res://audio/"
const BG_DIR = "res://assets/background/"
const CHARA_DIR = "res://assets/characters/"
const SAVE_DIR = "user://save/"
const THUMBNAIL_DIR = "user://temp/"
# size of thumbnail on save slot. Has to manually adjust the TextureRect's size as well
const THUMBNAIL_WIDTH = 175
const THUMBNAIL_HEIGHT = 100

# const starter_scene = "scene1" # 


# --------------------------- Game Experience Variables ------------------------
# can be changed in game
var music_volume : float = 0 # the default initial value on the BGM audio bus
var effect_volume : float = 0 # for sound effect
var voice_volume: float = 0 # for voice acting
var auto_on = false # Auto forward or not
var auto_speed: int = 1 # Auto forward speed
# 0 = slow: after all text is shown on screen, forward to next in 6s
# 1 = Normal: after all text is shown on screen, forward to next in 4s
# 2 = fast: after all text is shown on screen, forward to next in 2s
var auto_bound = ((-1)*auto_speed + 3.25)*20 # how many 0.05s do we need to wait if auto is on
# Formula ((-1)*auto_speed + 3.25)*20

var cps : int = 50 # either 50 or 25
# cps correspondence = {fast:50, slow:25, instant:0, slower:10}

# ---------------------------- Dvar Varibles ----------------------------
# VERY IMPORTANT
# PLEASE DO NOT NAME A DVAR THE SAME AS THE NAME OF ANY BBCODE!
# Also not "nw"

var dvar = {}

# ------------------------- Game State Variables--------------------------------

# Special game state variables, don't need to save.
var inLoading = false
var inNotif = false
var inSetting = false
var noMouse = false
var skipping = false

func reset_states():
	inLoading = false
	inNotif = false
	inSetting = false
	noMouse = false
	skipping = false
	auto_on = false
		
func error(message, ev = {}):
	if message == "p" or message == "path":
		message = "Path invalid."
	if message == 'dvar':
		message = "Dvar not found."
	
	if ev.size() != 0:
		message += "\n Possible error at event: " + str(ev)
			
	message += "\n Index is " + str(game.currentIndex) +\
	" in block " + game.currentBlock
	
	push_error(message)
	get_tree().quit()
