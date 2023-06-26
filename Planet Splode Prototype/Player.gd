extends KinematicBody2D


# Declare member variables here. Examples:
var velocity = Vector2()
var minXSpeed = 10
var acceleration = Vector2()
var gravityAcceleration = 500
var dragConstant = 0.5*3/2
var generalFriction = 200
var slideSlowdown = 300
var maxFallSpeed = 400


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	anims(delta)
	
func anims(delta):
	if abs(acceleration.x) > 0:
		$AnimatedSprite.play("side-glide")
	
	if is_on_wall():
		$AnimatedSprite.play("slide")
	
	if is_on_floor() || velocity.y < 0:
		$AnimatedSprite.play("roll")
		if velocity.x > 0:
			$AnimatedSprite.rotate(6*PI * delta)
		else:
			$AnimatedSprite.rotate(-6*PI * delta)
	else:
		$AnimatedSprite.rotation = 0
		if (abs(velocity.x) < 50 || $AnimatedSprite.animation == "roll") && !is_on_wall():
			$AnimatedSprite.play("default")
	
	if velocity.x > 0:
		$AnimatedSprite.flip_h = true
	
	if velocity.x < 0:
		$AnimatedSprite.flip_h = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	movement(delta)
	

func movement(delta):
	acceleration = Vector2()
	
	acceleration += (Vector2.DOWN * gravityAcceleration)
	
	if Input.is_action_pressed("move_left") && !is_on_floor():
		acceleration += Vector2.LEFT * 500
	
	if Input.is_action_pressed("move_right") && !is_on_floor():
		acceleration += Vector2.RIGHT * 500
	
	if is_on_floor():
		velocity -= velocity.normalized() * generalFriction * delta
		
	if is_on_wall():
		acceleration.y -= slideSlowdown
		if Input.is_action_pressed("jump"):
			velocity += Vector2.LEFT * maxFallSpeed
	
	velocity += (acceleration * delta) - (dragConstant * velocity * delta)
	if abs(velocity.x) < minXSpeed && acceleration.x == 0:
		velocity.x = 0
	if acceleration.x != 0 && !is_on_floor():
		velocity = velocity.normalized() * min(maxFallSpeed,velocity.length())
	
	if is_on_floor():
		if get_floor_angle(Vector2.UP) == 0:
			velocity.y = -500
			velocity.x = 0
	#	print(get_floor_angle(Vector2.UP))
	
	print(velocity)
	
	velocity.x = move_and_slide(velocity, Vector2.UP).x
	
	
