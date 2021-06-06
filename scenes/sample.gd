extends generalDialog


#---------------------------------- Choices ---------------------------------------
var food_choices = [
	
	{"Sushi": {"dvar": "money -= 20" }}, 
	{"Expensive Sushi": {"then": "complaints"}, "condition":"money >= 50"}, 
	{"Ramen": {"dvar": "money -= 15"}}
	
]


#---------------------------------- Core Dialog ---------------------------------------
var main_block = [
	
	# start of content
	{"bg": "Sitting_Room.png"},
	{"fadein": 2},
	{'chara': "female join", "loc": Vector2(115,500), "expression":""},
	{'wait': 2},
	{"female smile1": "[center]Hello World![/center]", 'voice': '001.wav'},
	{"female": "How are you feeling today?", 'voice':'002.wav'},
	{"female smile1": "Let's walk through the features of this VN template."},
	{"female": "To follow along this tutorial, please take a look at sample.gd."},
	{'quick_menu': false},
	{"female smile1": "First, let me be clear: this template is potentially harder to use " +\
	"than Renpy. It is highly recommended you have basic knowledge of Godot and knowledge on " +\
	"basic data structures before you begin."},
	{'quick_menu': true},
	{"female smile1": "In the process, you'll learn more coding, gain more " +\
	"customizability for your game and have an easier time integrating other games into your VN."},
	{'female': "Among all general computer science knowledge, it is highly recommended you know " +\
	"what is a dictionary in order to grasp this template."},
	{"female smile2": "Second, [b] I have no intention to add rollback functionality " +\
	"any time soon.[/b]"},
	{"female" : "This is partly because of technical difficulty, as rollback will mess with many other " +\
	"systems and the overall design,"},
	{"female": "and because I think the player should read the text more carefully and use " +\
	 "the history screen and save more often without rollback. (which is good imo)"},
	{"female": "We may debate on this. But I don't want to dwell too much on this contentious point."},
	{"" : "This is how you summon the great narrator! You can customize the narrator's name in globalSettings.gd."},
	{"female": "Now, let's have some [color=#ff00ff]music[/color]."},
	{"bgm" : "myuu-angels.mp3"},
	{"female": "That's easy. So now let's introduce dvar variables system. (Variables that will be saved " +\
	 "by the system. I coined 'dvar', which is short for dialog variables.)"},
	{"female": "dvar are stored in a dictionary as a key value pair, any value that " +\
	"Godot allows can theoretically be saved."},
	{"female": "But due to some difficulty, right now, you can only save floats or strings using the built-in dvar command. "+\
	"(Use 0, 1 if you want to save booleans.)"},
	{"female": "For complex data, like array/dictionary, you'll need to add get/set functions to generalDialog.gd. " +\
	"To save those variables, see saveSlot.gd and fileRelated.gd for details."},
	{"dvar": "money = 50" },
	{"female": "Now, regarding the built-in dvar, if you look at the code, I have just set a dvar " +\
	 "variable called 'money'. "},
	{"female": "To set a dvar, we just write dvar_name = something."},
	{"female": "If we want to make change to a dvar, remember that [b]will require the dvar to exist beforehand[/b] and " +\
	"[b]will require the value to be compatible with the current type.[/b]"},
	{"female": "That means two things: first if we want to make change to a dvar, the dvar must be defined "+\
	"once using dvar_name = something, and second, the value to be added/subtracted/.. must be compatible "+\
	"with the current value of the dvar."},
	{"female": "We can add numbers, but we cannot add a number to a string."},
	{"female": "Available operations are: =,+=,-=,*=,/=,%="},
	{"female": "Unfortunately, right now the system doesn't support arithmetic operation given in the form "+\
	"dvar1 = dvar2 + dvar3. If you really want something like this, then it might be a good idea to write "+\
	"some custom functions and add to generalDialog.gd."},
	{"female": "You can display a dvar like this. \n Money: [money]" },
	{"dvar": "money += 10"},
	{"female": "And now magically I have [money].Cool, right? And you can check this is not hardcoded." },
	{"female": "Haha, I'm rich. (This text will only show when you have more than 55.)", \
	"condition": "money >=   55"},
	{"female": "I have to admit this variable system is far more inferior to Renpy's. I will think of ways "+\
	"to improve. (This is partly due to limitations in GDscript...)"},
	{"female": "However, (as a defense) if you really need to do more complex computations or "+\
	"other complex manipulations, then you can always make custom functions and do those directly "+\
	"in GDscript. We're on a general game engine after all."},
	{"female": "Next, let's talk about text speed."},
	{"female": "This is how you make the dialog show up instantly.", 'speed': 'instant'},
	{"female": "This is how you make me talk slowly.", 'speed': 'slow'},
	{"female": "Or [b]really really slowly[/b]... THIS IS HARD... ...", 'speed': 'slower'},
	{'female': "And you can make the dialog auto forward the same way as in Renpy. It doesn't matter "+\
	"where you put the nw. (Extra symbols so you can read the text... ...)[nw]"},
	{'female': 'Also, try to avoid using square brackets in your text.'},
	{"female": "Now, music stop."},
	{"bgm": ""},
	{"female": "Stop will stop the music completely. Now, music start (from beginning with fadein)!"},
	{"bgm" : "myuu-angels.mp3", 'fadein': 3},
	{"female": "And of course you can fadeout music. It is done like this."},
	{"bgm":"", "fadeout":3},
	{"female": "Now let's keep the music up and look at text and expressions."},
	{'bgm': "myuu-angels.mp3"},
	{'font': 'normal', 'path': 'res://fonts/ARegular.tres' },
	{"female surprised": "Surprised that the font changed? It is very easy to do. We need to remember "+\
	"here that the path is the path to a Godot resource, which is made by a ttf file."},
	{"female smile1": "The Godot resource is very easy to make. And you can decide the font size when you "+\
	"are making the font into a Godot resource. So I don't provide a way to change the size here."},
	{'font': 'normal', 'path': 'res://fonts/EBGregular.tres' },
	{"female wink": "Let's call my friend here."},
	{"test2 annoyed1": "You cannot see me of course. Wonder why? Because you" + \
	" need the join statement."},
	{"test2 annoyed1": "Use my unique id and specify a location and expression and then I will show up."},
	{"audio": "cartoon_jump.wav"},
	{'chara': 'test2 join', "loc": Vector2(1150,500), "expression":"annoyed1"},
	{"test2 annoyed1": "Now you should be able to see me right?"},
	{"test2 annoyed2": "The tutorial is a bit long and boring."},
	{"camera": "vpunch"},
	{"test2 annoyed2": "This is how you do a dialog with a vpunch"},
	{"camera": "hpunch"},
	{"test2 annoyed2": "Same way you can do a hpunch."},
	{"camera": "shake", "amount": 400, "time": 3},
	{"test2 annoyed2": "And some random shaking. Remember to specify the shake amount" + \
	" and time (duration). Both are floats."},
	{"female": "You noticed my expression is the same when all that is happening?"},
	{"female": "It's because no one tells me to change expression."},
	{"female": "When someone joins the screen, if you put \"\", an empty string, " +\
	"then the expression will be the default one. Make sure you always have a " +\
	"default png for your character."},
	{"female": "If you want to change my expression without me speaking, " +\
	"use express: unique_id expression instead."},
	{"express": "female worried"},
	{"test2 smile1": "Hey! You made her worried."},
	{"female smile1": "I'm all good. Thanks for worrying about me."},
	{"test2 annoyed1": "A, wanna go to a restuarant?"},
	{'female': "Sure. We can introduce some new mechanics there as well."},
	{"fadeout":2},
	{"bg": "Restaurant_A.png"},
	{"fadein":2},
	{'test2': "Now, every VN engine should support branching, and choices. Let's see how " +\
	"works here."},
	{"condition": "money>=50", "then": "has_money", "else": "no_money", 'id':0},
	{'test2': "Try to change the value of the dvar money to something like 10 and see which branch "+\
	"we will go into."},
	{"test2": "If you're understanding the code, then you might realize that we have returned " +\
	"to main_block. You don't have to return, this is just an option. "},
	{"female": "Now let's see how to make questions and choices."},
	{"female smile1" : "What should I order today?", "choice": 'food_choices', 'id':1},
	{"female": "This restaurant has some really good food. Don't you think? (Money left: [money])"},
	{"female": "Only that it cost me a lot. (This text is showing bc I have only [money].)", \
	 "condition":"money < 20"},
	{"test2" : "I agree. How about going back to your place now?"},
	{"bg": "Futon_Room.png"},
	{"fadein": 2},
	{"chara" : 'female shake', "amount": 200, 'time': 2},
	{"test2 sad1" : "Are you alright?"},
	{'female smile1': "I'm perfectly fine. I just want to showcase some built-in sprite effects."},
	{"chara" : 'all shake', "amount": 200, 'time': 2},
	{"test2 default" : "Now you're making both of us shake..."},
	{"screen":'tint', 'color' : Color(0,0,0.8,0.6), 'time': 1},
	{"test2": "What is that?"},
	{"female": "That's called a tint effect. You can tint the screen with any color. The time here "+\
	"indicates the time it takes for the screen to transition to the tinted state."},
	{'test2' : "Looks cool."},
	{'screen':'tint', 'color': Color(0.8,0,0,0.6), 'time': 4, 'wave': true},
	{'female' : "What about now?"},
	{'test2': 'Scary... ...'},
	{'female' : "You can also make a tint wave like this. If it's a wave, then time is the time period " +\
	"for one wave. Newer tints will override older ones."},
	{'female': 'And you can also use screen:false to turn off the tint effect and other lasting ' +\
	"screen effects."},
	{'screen': false},
	{'test2': 'What are some other screen effects?'},
	{'female': 'You can cast a shockwave like this.'},
	{'screen': 'shockwave'},
	{'test2': 'Ok, a cool visual effect but maybe not that useful.'},
	{"audio": "cartoon_jump.wav"},
	{'chara': 'female jump', 'dir':'up', 'amount': 80, 'time': 0.4},
	{'female': 'I can jump like this.'},
	{"audio": "cartoon_jump.wav"},
	{'chara': 'all jump', 'dir':'up', 'amount': 80, 'time': 0.4},
	{'female': 'We can all jump like this. Right now, this is simply a linear jump. Nothing regarding '+\
	"gravity is considered. (Might make this more realistic in the future.)"},
	{'female': 'Now, here is a cool effect. (Finger snap...)'},
	{'chara': 'test2 fadeout', 'time': 2},
	{'test2': "No, don't forget me."},
	{'female': 'She will be back soon.'},
	{'chara': 'test2 fadein', 'loc': Vector2(1150,500), 'expression': 'angry', 'time':1},
	{'test2': "That's mean... ... I though I would never come back."},
	{'female': 'Now, some blood.'},
	{'sprite': 'res://scenes/fundamentals/details/spriteExample.tscn', 'loc': Vector2(600,300), 'anim': 'fadeout3s'},
	{"female": 'This way, you can show the animation on your prebuilt Godot sprite on the '+\
	"screen! Easy, right? There are a few caveats though."},
	{"female": "First, you need to make sure the sprite will be queue freed when animation is done. "+\
	"This event is meant to show only temporary effects. That means in your Godot sprite scene, "+\
	"you have to add queue free after animation is done."},
	{"female": "If this temporary sprite effect lasts 10s, and the player saves the game at 2s. Then "+\
	"when loading back, the sprite effect is not going to be shown. If savepoint is after the sprite "+\
	"event, then the effect is not going to trigger at all."},
	{"female": "Another notice: the sprite event isn't limited to sprites scenes. It can be applied to any Godot "+\
	"scenes with a subnode animation player with the default name AnimationPlayer that has the animation name you give."},
	{"test2": "I see. But to avoid unexpected outcomes, we should mostly use it for a sprite animation, "+\
	"am I understanding this right?"},
	{'female': "Correct! It can be used, for instance, to show a popping exclamation mark, a brief explosion "+\
	"animation, blood dripping and disappearing, etc."},
	{"female": "Or any short animtion that you preprogrammed into Godot."},
	{"test2" : 'I see. Quite handy.'},
	{"female": 'You can make me move like this.'},
	{'chara':'female move', 'type': 'linear', 'loc': Vector2(400, 500), 'time': 0.5},
	{'female': 'If type is instant, time is optional and will be ignored. If uid is all, this will also '+\
	"be ignored and nothing will happen. Ok, let me return to my old position."},
	{'chara':'female move', 'type': 'linear', 'loc': Vector2(115, 500), 'time': 0.5},
	{"test2 smile2": "I think this will be a useful command."},
	{"female smile1": "I will showcase the nvl mode here."},
	{'nvl':true},
	{"female": "Welcome to NVL mode."},
	{"female": "This is a short test sentence with my current money: [money]."},
	{"test2": "This is a long test sentenceeeeeeeeeeeeeeeeeeeeeeeeeee "+\
	"adsfadsfaegasfdfaefadfafaefdafaefef fasefasdfdsaf fasfdsafadf."},
	{"female": "[color=#ff00ff]This is a short test sentence with color.[/color]"},
	{"": "This is a short test sentence by the narrator."},
	{"": "Another short test sentence by the narrator."},
	{'female': "Hahahahahahahahahahahahahahahahahahaha."},
	{'test2': "Try to save during nvl mode and load back."},
	{'female': "Another short test sentence, hahahahahahahahahahahahahaha."},
	{'female': "[center]Another short test sentence.[/center]"},
	{'test2': "[center]Trying out all possibilities.[/center]"},
	{'female': "NVL mode lacks sprite interactions. It might be good for a sound novel though."},
	{'female': "Also if you're using nvl mode, please remember to clear the screen often, "+\
	"which is done by nvl:clear. You can see how messy it gets."},
	{'nvl': 'clear'},
	{'female': 'I just cleared the screen. Easy.'},
	{'nvl':false},
	{'female': "Now we are back to normal."},
	{'test2 smile1': "Finally."},
	{"center": "This is how you show a centered text"},
	{"center": 'Nothice that you cannot specify a narrator for the centered text.'},
	{'center': 'It is basically a one-shot nvl text with less background dimming.'},
	{'center': "You can use Godot's builtin bbcode to style the text as usual."},
	{'female': "That's about centered text."},
	{'nvl':true},
	{'female': "Let's see how center interacts with nvl mode."},
	{'center': "Hahahahahaha"},
	{"female": "So you see, after center, nvl mode is automatically turned off."},
	{"female": "If you want to continue nvl, then you need to manually turn on nvl again."},
	{"nvl": true},
	{"test2": 'So long story short. Try to avoid using center when nvl is on.'},
	{"female": "Correct."},
	{"nvl": false},
	{'female': "Now, let's see how to do a scene change. Here by scene, I mean a scene in Godot, "+\
	"not a scene in a play/story."},
	{'female': 'To do that, you only need a valid path.'},
	{"GDscene": "res://scenes/sampleScene2.tscn"}
	# end of content
]

var has_money = [
	{'female': 'Good, I have enough money.'},
	{'female': "What do you wanne eat, B?"},
	{'test2 smile2': 'Anything goes.'},
	{'then': 'starter', 'target id':0}
]

var no_money = [
	{'female': "Bad, bad... ... I have only [money]."},
	{'test2': "I don't mind getting something cheap."},
	{'then': 'starter', 'target id':0}
]

var complaints = [
	{"dvar": "money -= 50" },
	{'female' : 'This will cost me 50, hmmm... ...'},
	{'test2' : "A, don't worry. We can split. I will pay you later."},
	{'female smile2': "Thank you, B!"},
	{'then': 'starter', 'target id': 1}
]


#---------------------------------------------------------------------
# If you change the key word 'starter', you will have to go to generalDialog.gd
# and find start_scene, under if == 'new_game', change to blocks['starter'].
# Other key word you can change at will as long as you're refering to them correctly.
var conversation_blocks = {'starter' : main_block, 'has_money': has_money, \
	'no_money': no_money, 'complaints': complaints}

var choice_blocks = {'food_choices': food_choices}


#---------------------------------------------------------------------
func _ready():
	
	game.currentNodePath = get_tree().current_scene.filename
	get_tree().set_auto_accept_quit(false)
	start_scene(conversation_blocks, choice_blocks, game.load_instruction)
	
