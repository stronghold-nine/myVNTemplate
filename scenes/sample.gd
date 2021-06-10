extends generalDialog


#---------------------------------- Choices ---------------------------------------
var food_choice = [
	{"Sushi": {"dvar": "money -= 20" }}, 
	{"Caviar": {"then": "complaints"}, "condition":"money >= 50"}, 
	{"Ramen": {"dvar": "money -= 15"}},
	{"Nothing": {}}
]


#---------------------------------- Core Dialog ---------------------------------------
var main_block = [
	
	# start of content
	{"bg": "busstop.jpg"},
	{'dvar': 'money = 100'},
	{'chara': "female fadein", 'time':3, "loc": Vector2(1600,600), "expression": ''},
	{"female": "Some random filler."},
	{"female": "Even more fillers."},
	{"female": "Let's try the pixellate transition."},
	{'bg': 'busstop.jpg', 'pixellate': 3},
	{"female": 'Cool?'},
	{'female': 'Let me turn on the weather system.'},
	{'weather': 'rain'},
	{'female': 'You can customize the rain in the weather scene.'},
	{'audio': 'thunder.wav'},
	{'sfx': 'res://scenes/sfx_scenes/flash.tscn'},
	{'female': 'Scary. Let me go home.'},
	{'bg': 'condo.jpg', 'fade':3},
	{'female': 'Remember to turn off weather system.'},
	{'weather': ''},
	{'female': 'Music, start.'},
	{'bgm': 'myuu-angels.mp3', 'fadein':3},
	{'choice': "food_choice", 'female smile2': 'What should I order today?', 'id': 0},
	{'female': 'Alright, let me show you some other functions.'},
	{'chara': 'test2 join', 'loc': Vector2(200,630), 'expression':''},
	{'audio': 'cartoon_jump.wav'},
	{'chara': 'female jump', 'amount': 80, 'time': 0.4, 'dir': 'up'},
	{'test2': 'Hello, I suddenly appeared.'},
	{'female': 'You scared me.'},
	{'test2': "It will get even scarier."},
	{'screen': 'tint', 'color': Color(1,0,0,0.5), 'time': 1, 'wave': true},
	{'chara': 'female shake', 'amount': 200, 'time':1 },
	{'female': 'What is this?'},
	{'test2': 'A screen tint effect with wave.'},
	{'female': 'Might be useful for a horror game.'},
	{'test2': 'Certainly, and you can turn it off like this.'},
	{'screen': false},
	{"female": "We all need to break up our VN into chapters or similar "+\
	"structures like that. One good way to do that is to go to another Godot scene. "+\
	"It can be done like this."},
	{'GDscene':'res://scenes/sampleScene2.tscn'}
]

var complaints = [
	{'dvar': 'money -= 80'},
	{'female': 'Caviar is expensive... But I like it.'},
	{'female': 'Now I have only 20.', 'condition': "money <= 20"},
	{'then': 'starter', 'target id':0}
	
]


#---------------------------------------------------------------------
# If you change the key word 'starter', you will have to go to generalDialog.gd
# and find start_scene, under if == 'new_game', change to blocks['starter'].
# Other key word you can change at will as long as you're refering to them correctly.
var conversation_blocks = {'starter' : main_block, 'complaints': complaints}

var choice_blocks = {'food_choice': food_choice}


#---------------------------------------------------------------------
func _ready():
	
	game.currentNodePath = get_tree().current_scene.filename
	get_tree().set_auto_accept_quit(false)
	start_scene(conversation_blocks, choice_blocks, game.load_instruction)
	
