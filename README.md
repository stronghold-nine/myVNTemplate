# vntemplate

A Visual Novel Template for Godot Engine

Credits to assets used in this demo:
Choicebar:
morg, credit
https://lemmasoft.renai.us/forums/viewtopic.php?f=52&t=45028

Background:
Noraneko Games, free to use
https://noranekogames.itch.io/yumebackground

Character sprites:
WitPOP, non-commercial license
https://red-baby.itch.io/sprite-pack-female-beauty-spot
https://red-baby.itch.io/sprite-pack-female-dark-hair

Voice:
Cicifyre, free to use,
https://cicifyre.itch.io



Character Initialization:
Go to gameCharacter.gd to register your character in the form (display_name, unique_id, color), where color = Color(r,g,b,a), and default color (if none is given), will be Color(0,0,0,1), which is black.
For instance:
var test = character.new("B", "test", Color(0,255,0))
test.in_all = true (is true by default, here this is only for demonstration)
test.apply_highlight = true (same as above)
(In reality, we want the uid to be as short as possible. Here, I used “test” to make it easier to understand.)
in_all: By default, a newly initialized character object is a real talking character. However, there might be cases when you just want to display an object, say a box, on the screen, and let it stay there. You may want to use {express} or {chara : jump, …} to change the box’s sprite or do simple animation with it. Ok no problem. Just initialize it as a character! 
	However, if you actual main characters are on screen together with this box, and you want to do {chara : all jump…}, then this box is going to jump as well. To exclude the box from ‘all’, we should set box.in_all = false when initializing. 

apply_highlight: By default, when a character is talking, its sprite will be brighter, and when it’s not talking, its sprite will be slightly dimmer. If you don’t want this effect to apply to the character, set this to false when initializing.
	No highlight or de-highlight will be applied in nvl mode.

Special UIDs: the uid ‘all’ is reserved for the obvious reason. {chara: all join} will report an error.  {chara: all leave} will remove all characters on stage, except those with in_all = false. If you absolutely want to remove all characters, you can use: stage.remove_chara(‘absolute_all’) in code.

Speech event:
If character with uid test is correctly registered in gameCharacters.gd, then to let the character say something, we simply need
{test: words…}
To add voice acting, you simply write:
{test: words, voice: file_name.wav}
Make sure your voice file is in the default voice folder. If you change path to the default voice file, then make sure you update the new path in globalSettings.gd as well.

How to prepare character sprites?
You want to name your sprites in the format uid_expression.png, in order for the system to automatically recognize the sprites. I recommend putting those in the default folder: assets/characters. If you change the path, you need to go to globalSettings.gd and change the const CHARA.DIR there too. 
By default, if you initialized a character with uid = ‘a’, then when you write a speech event like
{a happy: Hello!}
Then the character a with automatically show the expression happy, provided that there is a png file called a_happy.png in the right folder, and provided that the character has joined the stage.

Character Event:
Caution: Use jump and shake responsibly. Dialog will not wait for jump or shake to finish before it continues. If jump event is read during shake event, then jump will override the shake, and vice versa.
Character events are of the format:
{chara: uid action_name, other key value pairs related to the specific action…}
So far, the following character events are available:
{chara: uid jump, amount:, time:, dir:,}
Direction can be up, down, left or right. 
{chara: uid shake, amount:, time:,}
{chara: uid fadein, time:, expression:, loc,} where loc requires a Vector2 value. This will also make the character join the stage.
{chara: uid fadeout, time}
{chara: uid move, type: , loc: } where loc requires a Vector2 value. Available types are: instant, linear.

Dialog Variables:
These are variables that will be carried in your saves. You can use dvar to decide if dialog should branch or not. Right now, dvar only works properly for floats or strings.
{dvar: money = 50} will set the dvar money to 50, or create a new dvar called money and set it to 50. (Here money is the name of the dvar.)
{dvar: money +=, -=, *=, /=, %= value} can be understood by the system. Value has to be of a compatible type with money. 
Unfortunately, right now the system won’t understand expressions like “dvar1 = dvar2 + dvar3”. However, it is possible to do such thing in code. All you need to do is to create some custom function that manipulates dvar and put in in generalDialog.gd, and make a custom event.
You can display your dvar in text by writing [dvar_name].
Do not use any bbcode name for your dvar. Also do not use nw because [nw] has special use. If you put [nw] in your sentence, the game will automatically progress to the next sentence after display all the text in previous one. (nw is short for no wait.)

Conditional Branches according to Dvars.
Suppose you want a sentence to show only if player has more than 55 money. Ez.
{female: Haha, I'm rich. (This text will only show when you have more than 55.), condition: money >=   55},
Similarly, you may attach the key value pair:  conditional:dvar (comparison) value, to any statement.

Conditional branch:
{condition: money >= 50, then: name_of_then _block, else: name_of_else _block}

The current conversation block will be changed to the new one according to whether the condition is met. The names have to correspond to keys in conversation_blocks.

Optional keys are allowed, but won’t be executed. It is advised you only use the above three keywords, or add an “id” keyword if you need to return to this block. Currently if you use this to change conversation block, then it will start at the beginning of the new block.

Jump to certain index at other conversation blocks
{then: name_of_target_block,  target id: 1}
This event will look through all indices inside the block (array) with key name_of_target_block, and if there is an event with id:1, then it will jump to the next event after the event with id:1.
In this way, you can return to your main conversation block after some branching.


Choices:
A typical choice event is 
{female smile1 : What should I order today?, choice: food_choices},
where the key ‘food_choices’ corresponds to the variable food_choices inside choice_block:
var food_choices = [
	{"Sushi": {"dvar": "money -= 20" }}, 
	{"Expensive Sushi": {"then": "complaints"}, "condition":"money >= 50"}, 
	{"Ramen": {"dvar": "money -= 15"}}
]
Optional keywords inside a choice event include id and voice.

Events in choice block should be formatted in this way:
{text_to_be_displayed_on_the_choice_button : choice_action}

Choice action: a dictionary indicating an event that will happen if the corresponding choice button is selected. Currently only two choice actions are allowed: {dvar: … } XOR {then : block name}. 
If the action is about dvar, then the conversation will go down the same block after dealing with the dvar. Otherwise, it will go to the indicated block and start from beginning. There can only be one choice action per choice. If you want to do more, change to new block, do your things, and then come back.

Camera events:
{camera: shake, amount:, time:} Self-explanatory.
{camera: vpunch} Vertical punch. Shake the screen vertically with default parameters.
{camera: hpunch} Horizontal punch.

Screen effects:
{fadein: 3} fadein screen in 3 seconds, unskippable. Value should be a float.
{fadeout: 2} fadeout screen in 2 seconds, unskippable.
These two are so commonly used that they deserve their special shortcuts.
Other screen effects so far:
{screen: tint, time:, color:} tint the screen with the given color. Color should be a Godot color. For instance, color: Color(0,0,0,1) for black. Time here indicates the time for the screen to reach the tinted state.
{screen: tint, time: , color:, wave: true} This will tint the screen, fade the tint, and tint the screen again. Here time indicates the time for one repetition.
These two are lasting screen effects, meaning that they’re lasting and will be played back if player saves during the effects.
Use {screen: false} to turn any of them off.
{screen: shockwave} A random effect I learned when watching tutorials on custom shaders.

Sprite events:
If you preprogrammed some cool sprite animation, and want to play it during the dialog, you can do it by:
{sprite: res://scenes/fundamentals/details/spriteExample.tscn, loc: Vector2(600,300), anim: fadeout3s},
Here, we’re playing a preprogrammed sprite animation called fadeout3s. In fact, any Godot scene with a preprogrammed animation can be displayed like this.
Note, you’re responsible for queue_freeing this new scene. Usually, it should be done at the end of the animation.
The sprite event is only meant to show temporary effects and long sprite animation won’t be saved. That means if you’re playing a long animation using this event, and player saves when the animation is still going on, then after loading back, the sprite effect will not be shown.
If you want to make something like raining, create a lasting screen effect in screenEffect.tscn, and make it a lasting screen effect by remembering it. (Check the screen tint events in generalDialog.gd to see what I mean by remembering. Also, the comments in gameProgress.gd might be helpful.)

BGM and sound effects:
{bgm: music_name.wav/mp3} Play the bgm with the name, provided that it is inside the default folder indicated in globalSettings.gd. If you make a new default folder, you need to change the path in globalSettings.gd as well.
{bgm: music_name.mp3, vol: db}, db is the standard decibel measure for volume. By default, this is 0. And 0 doesn’t mean it is muted!
{bgm, music_name.wav/mp3, fadein: 3, vol: db} Play the bgm with 3 seconds of fadein time.
{bgm: “”} If you put an empty string, bgm stops.
{bgm: “”, fadeout:3} Stop the music by fading it out in 3 seconds
{audio: audio_name.wav/mp3}, same as bgm. Notice: audios are meant to be short. There is no inbuilt event to stop an audio.

NVL mode:
	You can use {nvl:true} to turn on nvl mode. All text after this will be displayed in nvl mode. Use {nvl:false} to turn off nvl mode. 
You can use {nvl: clear}to clear the current text. The clear command will only clear the text, and will not exit nvl mode. 
Character highlighting will not be available in nvl mode.
	{choice:…} event will automatically turn off nvl mode.
{center:…} event is essentially a one-shot reformatted nvl dialog. Center will cancel the existing nvl, and when center ends, nvl will be turned off automatically.

Other events:
{bg: bg_name.png}. Change background. Change to the bg with the name, provided that it is inside the default folder indicated in globalSettings.gd. If you make a new default folder, you need to change the path in globalSettings.gd as well.

{font: normal, path: path_to_a_font_resource.tres}, change the normal font for dialog box and nvl box. Notice if you’re in regular mode, font in namebox won’t  be changed. However, if you’re in nvl mode, name font will also be changed.
Notice ttf files won’t work. You need to package them into a Godot resource first in the editor. Set the size when you’re making your ttf into a Godot resource. I am not providing a size change currently.
Instead of normal, you can also use: italics, bold, bold_italics, mono

{wait: 2} Pause the game for 2 seconds and then automatically continues. 

{express: uid expression}: change the expression of character with that uid.

{GDscene: path_to_another_Godot_scene}: this will change current scene to the one indicated by the path. All characters will be removed and will need to be rejoined. BGM on the other hand, will keep playing.

Some Constants:
	Highlighting speaking character is done by changing sprite’s modulate property. Highlight means modulate = Color(1,1,1,1), and de-highlight means modulate = Color(0.86,0.86,0.86,1)

Some other random questions/problems:
1.	The main menu’s canvas layer is 5. Is there any particular reason for that?
Ans. No. There was a weird bug. If you save during nvl mode, and then return to main (do nothing in between), then buttons in the main menu becomes unclickable. My guess it that something is on a higher level that prevents the buttons from being clicked. When I changed the main menu’s layer to 5, the issue went away. 



Other important remarks:
If you’re editing conversation blocks directly in GDscript, then you will need quotation marks around everything of type string. 
There might be typos in this document. 
Please use Godot ver. 3.3+. I don’t know what will happen if you use an older version. (3.3 supports playing mp3. Before 3.3, mp3 is not supported.)
Do not change the name of nodes inside VNUI (you can, but then you have to go into the code and fix a few strings) and also Also do not change the name of background. (Should be just “background”.)


