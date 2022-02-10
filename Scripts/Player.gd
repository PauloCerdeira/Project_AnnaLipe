extends KinematicBody2D

var dir
var velocity = Vector2.ZERO
var lastJumpPress = 1000
var jumpHeight = 325
var grounded = false
var canLegdeHelp = false
export var speed = 350
export var maxSpeed = 275
var gravity = 500
var frictionTimer = 0

func _ready():
	pass

func _process(delta):
	handleInput(delta)
	handleSprite()
	
func handleInput(delta):
	dir = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	frictionTimer += delta
	if dir == 0 && frictionTimer > 0.1:
		if velocity.x > -1.5 and velocity.x < 1.5:
			velocity.x = 0
		else:
			velocity.x = velocity.x / 1.6
		frictionTimer = 0
	
	velocity.x += (dir * speed) * delta
	velocity.y += gravity * delta
	
	if velocity.x > maxSpeed:
		velocity.x = maxSpeed
	if velocity.x < -maxSpeed:
		velocity.x = -maxSpeed
	
	lastJumpPress += delta
	if Input.is_action_just_pressed("jump"):
		 lastJumpPress = 0
	if not Input.is_action_pressed("jump") && velocity.y < 0:
		velocity.y = velocity.y/1.7
	if lastJumpPress < 0.15 and grounded:
		velocity.y = -jumpHeight 
	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("menu"):
		$Camera2D/Menu.visible = !$Camera2D/Menu.visible
	
#	print(-maxSpeed / 1.25, velocity)

func handleSprite():
	$AnimatedSprite.speed_scale = 1
	if grounded:
		if (velocity.x < -0.5):
			$AnimatedSprite.flip_h = true
			if (dir < 0):
				$AnimatedSprite.play("running")
			else:
				$AnimatedSprite.play("stopping")
			if velocity.x == -maxSpeed:
					$AnimatedSprite.speed_scale = 1.8
		elif (velocity.x > 0.5):
			$AnimatedSprite.flip_h = false
			if (dir > 0):
				$AnimatedSprite.play("running")	
			else:
				$AnimatedSprite.play("stopping")
			if velocity.x == maxSpeed:
					$AnimatedSprite.speed_scale = 1.8
		else:
			$AnimatedSprite.play("standing")
			$AnimatedSprite.flip_h = false
	#	if (velocity.x != 0):
	#		if dir !=
	#		$AnimatedSprite.play("running")
	#		if dir < 0:
	#			$AnimatedSprite.flip_h = true
	#		else:
	#			$AnimatedSprite.flip_h = false
	#	else:
	#		$AnimatedSprite.flip_h = false
	#		$AnimatedSprite.play("standing")
	else:
		$AnimatedSprite.play("jumping")
	


func _on_GroundCheckArea2D_body_entered(_body):
	if _body.name != 'Player':
		grounded = true


func _on_GroundCheckArea2D_body_exited(_body):
	if _body.name != 'Player':
		grounded = false


func _on_TouchArea_body_entered(body):
	if body.name == "TileMap" && canLegdeHelp && dir > 0:
		self.position.x += 10
		print("ativo porra " + str(dir))


func _on_checkArea_body_entered(body):
	canLegdeHelp = true


func _on_checkArea_body_exited(body):
	canLegdeHelp = false
