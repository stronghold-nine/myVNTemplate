extends Node

#----------------------------------Important------------------------------------
# 
#-------------------------------------------------------------------------------
#
# 
var currentNodePath = null

# Current time line 
var currentBlock = null

# Current index in the block
var currentIndex = null

# Current save description, if there is one
var currentSaveDesc = ""


#---------------------------------Important-------------------------------------

# Playback/lasting events are defined as events that should be remembered when loading
# back from a save.

# Current playback_events:
# text in nvl mode

# If player saves in the middle of nvl mode,
# then when loading back, we need to restore all the nvl text.
var nvl_text = ''

# Last bgm, bg change
# Last lasting screen effects (currently all lasting screen effects are
# exclusive, meaning if one is on, the other will override the previous one.)
# Only two lasting screen effects now: tint, and tintWave
# Notice: effects that will expire after a few seconds should not be considered
# as lasting effects

# Current characters on stage together w/ their expressions 


var playback_events = {'bg':{}, 'bgm':{}, 'screen':{}, 'charas':[], 'weather': {}, 'nvl': ''}
# specific to one scene in godot

func get_latest_onstage():
	playback_events['charas'] = stage.all_on_stage()

func get_latest_nvl():
	playback_events['nvl'] = nvl_text


#-------------------------------------------------------------------------------
# "new_game" = start from new
# "load_game" = start from time line and index
var load_instruction = "new_game"
#-------------------------------------------------------------------------------


# Do not touch unless you will change the current save and load system, 
# This is only used in the process of save and load and 
# has something to do with the thumbnail.
var currentFormat = null # save current format. Used for thumbnail creation



#-------------Important--------------------------------
# The max length of historyDialog is controlled by
# globalSettings.max_dialog_display, which is not a constant.
# However, I also set an absolute max, which is
# globalSettings.max_dialog. The reason for the absolute max 
# is that the current implementation will be slow when there 
# are a lot of dialogs. (See Godot documentation of arrays for
# detials. Also the absolute max is probably more than anyone 
# would ever go back and reread in history). However, there 
# might be a case in your game that you wish to display 2000+ 
# lines of history... In that case, you might wish to re-implement 
# the historyDialog functionality using other data structure
#------------------------------------------------------
var history = []

# Utility functions

# remember the input is not just a line, it is an array [unique id, text]
func updateHistory(textbox):
	history.push_back(textbox)
	if (history.size() > vn.max_dialog_display):
		history.pop_front()
		# will be slow if this array gets too long
		
	
