extends CharacterBody2D

@export var speed = 400
@export var jumpForce = 450
@export var gravity = 981
@export var fallGravity = 2100

@export var jumpBuffer = 0.1
@export var coyoteTime = 0.1

var bufferTimer = 0.0
var coyoteTimer = 0.0

func _physics_process(delta):
	var direction = Input.get_axis("left","right")
	
	if direction:
		velocity.x = speed * direction
		if is_on_floor():
			$AnimatedSprite2D.play("walk")
	else:
		velocity.x = 0
		if is_on_floor():
			$AnimatedSprite2D.play("idle")
	
	if direction == 1:
		$AnimatedSprite2D.flip_h = false
	elif direction == -1:
		$AnimatedSprite2D.flip_h = true
	
	if not is_on_floor():
		if velocity.y < 0:
			velocity.y += gravity * delta
		else:
			velocity.y += fallGravity * delta
		
		if Input.is_action_pressed("down"):
			velocity.y += (fallGravity * delta)
			
		if Input.is_action_just_released("jump"):
			if velocity.y < 0.0:
				velocity.y *= 0.5
					
		coyoteTimer -= delta
	else:
		coyoteTimer = coyoteTime
	
	if bufferTimer > 0:
		bufferTimer -= delta
	
	if Input.is_action_just_pressed("jump") and (is_on_floor() or coyoteTimer > 0):
		velocity.y = -jumpForce
		
		coyoteTimer = 0.0
		bufferTimer = 0.0
	
	move_and_slide()
