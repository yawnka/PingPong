extends Node2D

#variables
var screen_size
var pad_size
var direction = Vector2(1.0, 0.0)

#constant for ball speed in pixels/per second
const INITIAL_BALL_SPEED = 80
#speed of the ball
var ball_speed = INITIAL_BALL_SPEED
#constant for pads speed
const PAD_SPEED = 150

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	pad_size = get_node("left").get_texture().get_size()
	set_process(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var ball_pos = get_node("ball"). get_position()
	var left_rect = Rect2(get_node("left"). get_position() - pad_size*0.5, pad_size)
	var right_rect = Rect2(get_node("right"). get_position() - pad_size*0.5, pad_size)
	#Integral new ball pos
	ball_pos += direction * ball_speed * delta
	#test collisions by flipping when ball hits roof/floor
	if ((ball_pos.y < 0 and direction.y <0) or (ball_pos.y > screen_size.y and direction.y >0)):
		direction.y = -direction.y
	#invert the direction of ball once it hits a pad
	#we change the direction and increase the speed
	if ((left_rect.has_point(ball_pos) and direction.x < 0) or (right_rect.has_point(ball_pos) and direction.x > 0)):
		direction.x = -direction.x
		direction.y = randf()*2.0 - 1
		direction = direction.normalized()
		ball_speed *= 1.1
	#check if ball went out the screen
	if (ball_pos.x < 0 or ball_pos.x > screen_size.x):
		ball_pos = screen_size*0.5
		ball_speed = INITIAL_BALL_SPEED
		direction = Vector2(-1, 0)
	get_node("ball"). set_position(ball_pos)
	# Move left pad
	var left_pos = get_node("left"). get_position()
	if (left_pos.y > 0 and Input.is_action_pressed("left_move_up")):
		left_pos.y += -PAD_SPEED * delta
	if (left_pos.y < screen_size.y and Input.is_action_pressed("left_move_down")):
		left_pos.y += PAD_SPEED * delta
	get_node("left"). set_position(left_pos)

	# Move right pad
	var right_pos = get_node("right").get_position()

	if (right_pos.y > 0 and Input.is_action_pressed("right_move_up")):
		right_pos.y += -PAD_SPEED * delta
	if (right_pos.y < screen_size.y and Input.is_action_pressed("right_move_down")):
		right_pos.y += PAD_SPEED * delta

	get_node("right"). set_position(right_pos)
