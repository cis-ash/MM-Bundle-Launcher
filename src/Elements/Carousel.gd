# this script is supposed to animate the display and run the show
# if you are trying to add more games you are NOT supposed to be here
# change the export variables in the game nodes that are children of this one

extends YSort
# influences the shape of the ellipse the covers travel along
const SCALE_OF_CAROUSEL = Vector2(1920/3, 1080/4)
# currently selected game
var selected_game = 0
# where the carousel should be, lags behind currently selected game
var angle_of_visuals = 0
# assigned in ready
var games;
# blocks input if quit popup is visible
var exiting = false

# scale of cover when far away
export (float) var min_scale;
# scale of cover when close up
export (float) var max_scale;
# play when a different cover is selected
export (NodePath) var move_sound;
export (NodePath) var exit_popup;

# tint of cover when far away, close tint is always white
export (Color) var far_tint;
# tint of cover when it is not selected, is multiplied with far tint
export (Color) var unselected_tint;


func _ready():
	# get games based on current children nodes
	games = get_children()
	for game in games:
		game.unselected_tint = unselected_tint
	pass 



func _process(delta):
	if OS.is_window_focused():
		# if the quit game popup is visible - act on it and ignore other inputs
		if exiting:
			if Input.is_action_just_pressed("ui_accept"):
				get_tree().quit()
			if Input.is_action_just_pressed("ui_cancel"):
				exiting = false
		else:
			# if quit game popup is not visible - act as usual
			if Input.is_action_just_pressed("ui_left"):
				selected_game += 1;
				get_node(move_sound).play()
			if Input.is_action_just_pressed("ui_right"):
				selected_game -= 1;
				get_node(move_sound).play()
			
			# this bit ensures the selected game never goes out of bounds
			if selected_game > games.size()-1:
				selected_game -= games.size()
			if selected_game < 0:
				 selected_game += games.size()
			
			
			if Input.is_action_just_pressed("ui_accept"):
				if games[selected_game].prepared:
					# if cover already taking up entire screen - launch it
					games[selected_game].play()
				else:
					# expands the selected cover to fill entire screen if it was not
					games[selected_game].prepared = true;
			if Input.is_action_just_pressed("ui_cancel"):
				if games[selected_game].prepared:
					# if cover was taking up entire screen - return it to normal
					games[selected_game].prepared = false;
				else:
					# if it was already normal - ask the player if they want to quit
					exiting = true;
		
		
		# makes the visual rotation of the carousel lag behind the selection
		# TAU = full circle in radians
		angle_of_visuals = lerp_angle(angle_of_visuals, 
				TAU/games.size()*selected_game - TAU/4, delta*10)
		
		# if exiting - popup visible, if not - it is not
		get_node(exit_popup).visible = exiting
		
		# move games on the carousel (and more!)
		move_games()
	pass

func move_games():
	
	# perform actions on every game that is on display
	for i in range(games.size()):
		
		var angle_per_game = TAU/games.size()
		# translates games position in list and global offset in radians 
		# into x & y coordinates
		var game_position = Vector2(cos(angle_per_game*(i)-angle_of_visuals), 
				sin(angle_per_game*(i)-angle_of_visuals))*SCALE_OF_CAROUSEL
		games[i].position = game_position
		
		# makes the game aware of its state so it can animate appropriately
		if i != selected_game:
			games[i].prepared = false
			games[i].selected = false
		else:
			games[i].selected = true
		
		# makes games in front be bigger than games in the back
		games[i].scale = Vector2.ONE*(lerp(min_scale, max_scale, 
				sin(angle_per_game*(i)-angle_of_visuals)/2+0.5 ))
		
		# makes games in the back tinted and the ones in the front - white
		games[i].modulate = lerp(far_tint, Color.white, 
				sin(angle_per_game*(i)-angle_of_visuals)/2+0.5)
		pass
	pass
