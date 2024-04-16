extends CharacterBody2D

const GRAVITY : int = 1000 # determine how quickly the bird drops
const MAX_VEL : int = 600 # limit the max fall speed
const FLAP_SPEED : int = -500 # will control much the bird jumps up
var flying : bool = false 
var falling : bool = false # is active when the bird hits a pipe and falls to the ground
const START_POS = Vector2(100,400) # defines the coordinates of the bird at the start of the game

# Called when the node enters the scene tree for the first time. flags and position of the bird correct 
func _ready(): 
	reset()
	# the ready finction will fire the reset function which reset the flags and position the bird correctly as well as reset any rotation that has been applied
func reset():
	falling = false 
	flying = false
	position = START_POS
	set_rotation(0)
	
# called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta): # physisc process will handle all the bird movement 
	if flying or falling: # check if the bird is in the air
		velocity.y += GRAVITY * delta # apply gravity
		# terminal velocity
		if velocity.y > MAX_VEL:
			velocity.y = MAX_VEL
		if flying: #as long as the bird is flying
			set_rotation(deg_to_rad(velocity.y * 0.05)) #rotate it
			$AnimatedSprite2D.play() # play the animation
		elif falling: # if the bir hits a pipe and is falling
			set_rotation(PI/2) # rotate it to face down
			$AnimatedSprite2D.stop() # then stop the animation
		move_and_collide(velocity * delta) # to move the bird
	else: # trigger when the bird isnt in the air
		$AnimatedSprite2D.stop() # we stop the animation completely
		
func flap(): # allow the bird to flap and fly upwards
		velocity.y = FLAP_SPEED
		
	
			
			
			
