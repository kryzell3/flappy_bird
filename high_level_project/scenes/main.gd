extends Node

@export var pipe_scene : PackedScene

var game_running : bool # a flag to determine the games state
var game_over : bool # a flag to determine the games state
var scroll # to use to move the images across the screen smoothly
var score # track progress/score
const SCROLL_SPEED : int = 4 # can adjust to make the game slower or faster
var screen_size : Vector2i #placeholders (comeback)
var ground_height : int # placeholders (comeback)
var pipes : Array # allow us to store all the pipes that we create
const PIPE_DELAY : int = 100 #control the pipe generation
const PIPE_RANGE : int = 200 # control pipe generation

# Called when the node enters the scene tree for the first time.
func _ready(): # fire the new game function
	screen_size = get_window().size
	ground_height = $Ground.get_node("Sprite2D").texture.get_height()
	new_game()
	
func new_game(): # will define or reset the starting variables  
	# reset variables
	game_running = false
	game_over = false
	score = 0
	scroll = 0
	$ScoreLabel.text = "SCORE: " + str(score)
	$GameOver.hide()
	get_tree().call_group("pipes","queue_free")
	pipes.clear()
	#generate starting pipes
	generate_pipes()
	$Bird.reset() # run the birds reset function together ready?
	
func _input(event):
	if game_over == false: # check if the game isnt over
		if event is InputEventMouseButton: # then look for a mouse clicks, when the game first starts the bird is stationary until the mouse clicked
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed: #the first mouse clicked should start the game and the subsequent mouse click flaps the birds wings 
				if game_running == false: # check if the game is running and if it isnt 
					start_game() # we use this first mouse click to start the game
				else: # if the game is runnig 
					if $Bird.flying: #and if the bird is flying and hasnt hit a pipe or the ground
						$Bird.flap() # flap its wings
						check_top()
						
func start_game(): # starts the game
	game_running = true
	$Bird.flying = true # sets tge bird flying flag to true 
	$Bird.flap() # flap its wings
	# start pipe timer
	$PipeTimer.start()

func _process(delta):
	if game_running:
		scroll += SCROLL_SPEED
		# reset scroll
		if scroll >= screen_size.x:
			scroll = 0
		#move ground node
		$Ground.position.x = -scroll
		#move pipes
		for pipe in pipes:
			pipe.position.x -= SCROLL_SPEED
		

func _on_pipe_timer_timeout():
	generate_pipes()
	
func generate_pipes():
	var pipe = pipe_scene.instantiate()
	pipe.position.x = screen_size.x + PIPE_DELAY
	pipe.position.y = (screen_size.y - ground_height) / 2  + randi_range(-PIPE_RANGE, PIPE_RANGE)
	pipe.hit.connect(bird_hit)
	pipe.scored.connect(scored)
	add_child(pipe)
	pipes.append(pipe)

func scored():
	score+= 1
	$ScoreLabel.text = "SCORE: " + str(score)

	
func check_top():
	if $Bird.position.y < 0:
		$Bird.falling = true
		stop_game()

func stop_game():
	$PipeTimer.stop()
	$GameOver.show()
	$Bird.flying = false
	game_running = false
	game_over = true
	
func bird_hit():
	$Bird.falling = true
	stop_game()


func _on_ground_hit():
	$Bird.falling = false
	stop_game()

func _on_game_over_restart():
	new_game()
