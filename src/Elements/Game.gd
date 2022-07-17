# This script is responsible for storing all the info regarding a game
# or a piece of media available through the launcher
# if you're trying to add more games to the launcher this is NOT the place to be
# instead go edit the export vars of Game node instances in the main scene

extends Node2D
export (String) var game_name
export (String) var author_name
export (String, MULTILINE) var description
export (Texture) var Cover;
export (int, "keep rotation", "rotate clockwise", "rotate counter clockwise") var rotate
export (int, "no file", "windows exe", "link/pdf/html/other file", "gameboy rom") var game_type
export (String) var file_to_run;
var was_prepared = false
var prepared = false
var selected = false
var anim_scale = 1
var info_anim_scale = 0.5
var prep_scale = 2.05
var select_scale = 1.3
# this variable is written from the Carousel script, changing it here is useless
var unselected_tint: Color

func _ready():
	# some pages acquired through pdf2png.com may be intended to be read in 
	# landscape mode, this is what the export booleans are for
	if rotate == 1:
		$visuals/page.rotate(PI/2)
	if rotate == 2:
		$visuals/page.rotate(-PI/2)
	
	# assigns the display text to match the provided info
	$TextInfo/GameName.text = game_name
	$TextInfo/ExtraInfo.text = "by " + author_name + "\n"
	match game_type:
		0:
			# no exe
			$TextInfo/ExtraInfo.text += "no compatible file available"
			pass
		1:
			# exe
			$TextInfo/ExtraInfo.text += "a Windows executable"
			pass
		2:
			# pdf/html
			$TextInfo/ExtraInfo.text += "opens a file"
			pass
		3:
			# gb rom
			$TextInfo/ExtraInfo.text += "GameBoy ROM that runs in emulator"
			pass
	
	# assigns the provided cover image to be displayed and adjusts its scale
	# so that its biggest side is of the same size on screen for all covers
	$visuals/page.texture = Cover
	var biggest_side = max(Cover.get_size().x, Cover.get_size().y)
	var adjust_scale = 2200/biggest_side
	$visuals/page.scale = Vector2.ONE*0.2*adjust_scale
	
	
	pass


func _process(delta):
	
	# this is done to lower the burden on the computer while the launched game
	# is in focus (happens automatically when it is run)
	if OS.is_window_focused():
		
		# if prepared make the sprite bigger
		if prepared:
			anim_scale = lerp(anim_scale, prep_scale, 10*delta)
		elif selected:
			# if selected make sprite slightly bigger and remove tint
			anim_scale = lerp(anim_scale, select_scale, 10*delta)
			$visuals.modulate = lerp($visuals.modulate, Color.white, 10*delta)
		else:
			# if not selected or prepared return to normal
			anim_scale = lerp(anim_scale, 1, 10*delta)
			$visuals.modulate = lerp($visuals.modulate, unselected_tint, 10*delta)
		
		# apply anim_scale variable which was changed above
		$visuals.scale = Vector2.ONE*anim_scale
		
		# if selected show the info text, if not - hide it
		if selected:
			info_anim_scale = lerp(info_anim_scale, 1, 10*delta)
		else:
			info_anim_scale = lerp(info_anim_scale, 0, 10*delta)
		$TextInfo.scale = info_anim_scale*Vector2.ONE
		pass
		
		if not was_prepared and prepared:
			$Select.play()
		was_prepared = prepared
	pass

func play():
	# make the cover small again
	prepared = false
	
	# run the game using the appropriate method
	match game_type:
		0:
			# nothing to run
			$Failure.play()
			pass
		1:
			# exe
			OS.execute(file_to_run, [], false)
			$Success.play()
			pass
		2:
			# pdf/html/other file
			OS.shell_open(file_to_run)
			$Success.play()
			pass
		3:
			# gb rom
			OS.execute("GB Emulator\\bgb.exe", ["-rom", file_to_run], false)
			$Success.play()
			pass
	
	pass
