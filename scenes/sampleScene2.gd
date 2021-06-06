extends generalDialog


#---------------------------------- Choices ---------------------------------------


#---------------------------------- Core Dialog ---------------------------------------
var main_block = [
	
	# start of content
	{"bg": "Bathroom.png"},
	{"fadein": 2},
	{'chara': "female join", "loc": Vector2(1150,500), "expression":""},
	{"female smile1": "Hmm, why am I in a bathroom?"},
	{"female smile1": "This scene is meant to show you how to change from a Godot scene " +\
	"to another."},
	{'female': "Skip and auto will also be stopped after a GDscript."},
	{"female": "If the dialog gets too long, it becomes inevitably hard to organize things. So "+\
	"breaking it up by chapters or scenes is a good idea."},
	{"female": "A few caveats: 1. Notice that music is still the same. If you want music to stop, "+\
	"please do so manually before scene change."},
	{"female": "2. You will need to rejoin all the characters. 3. Everything else will go away. " +\
	"So you don't need to worry if you need to turn off nvl mode or not."},
	{"female": "Another important thing you need to keep in mind is that: it's perfectly fine to "+\
	"duplicate a scene, if you don't want to manually add a background or VNUI."},
	{"female": "However, if you do so, please rename the top node to something else, like here I named "+\
	"it sample2. Also notice that the name of this script is different."},
	{"female": "When you duplicate a scene in Godot, by default, the scenes will have the same script. "+\
	"That means if you're making changes in one, you're actually making changes in both."},
	{"female": "So make sure you detach the old script and make a new one after you duplicate."},
	{"female": "As long as your new script extends generalDialog, you do the three things in _ready," +\
	"and have a conversation block and choice block like here, your story will play."},
	{"female": "If you're interested in adding/customizing functionalities, then generalDialog.gd is what you "+\
	"want to take a look at."},
	{"female": "A few other crucial code files: globalSettings, this is a Godot singleton with alias vn. "+\
	"Other singletons are important too if you want to customize. You can find them in project settings, "+\
	"autoload."},
	{"female": "Don't forget one thing! When you game ends, do the following."},
	{"female": "Use a GDscene change to go back to your designated ending scene. By default, the ending "+\
	"scene will be your main screen. But don't remember to change it to your actual ending if you "+\
	"have one!"},
	{"female": "Thank you so much for bearing with me!"},
	{"fadeout":2},
	{'bgm': ''},
	{"GDscene": vn.ending_scene_path}
	
	# end of content
]


#---------------------------------------------------------------------
# If you change the key word 'starter', you will have to go to generalDialog.gd
# and find start_scene, under if == 'new_game', change to blocks['starter'].
# Other key word you can change at will as long as you're refering to them correctly.
var conversation_blocks = {'starter' : main_block}

var choice_blocks = {}


#---------------------------------------------------------------------
func _ready():
	
	game.currentNodePath = get_tree().current_scene.filename
	get_tree().set_auto_accept_quit(false)
	start_scene(conversation_blocks, choice_blocks, game.load_instruction)
	
