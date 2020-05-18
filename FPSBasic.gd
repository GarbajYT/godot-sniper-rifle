extends KinematicBody

var speed = 7
var acceleration = 10
var gravity = 0.09
var jump = 10

var mouse_sensitivity = 0.03

var direction = Vector3()
var velocity = Vector3()
var fall = Vector3() 

var ads_anim_played = false

onready var head = $Head
onready var awp = $Head/Hand/AWP

onready var camera = $Head/Camera
onready var scope = $Head/Camera/Scope
onready var ap = $Head/Hand/AWP/AnimationPlayer

func _ready():
	pass
	
func _input(event):
	
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity)) 
		head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity)) 
		head.rotation.x = clamp(head.rotation.x, deg2rad(-90), deg2rad(90))
		
func scope():
	if Input.is_action_pressed("fire2"):
		if not ads_anim_played:
			if ap.current_animation != "ADS":
				ap.play("ADS")
		yield(get_tree().create_timer(0.1), "timeout")
		ads_anim_played = true
		scope.visible = true
		camera.fov = 50
		mouse_sensitivity = 0.015
		awp.visible = false
	else:
		scope.visible = false
		if ads_anim_played:
			if ap.current_animation != "ADS":
				ap.play_backwards("ADS")
		yield(get_tree().create_timer(0.1), "timeout")
		ads_anim_played = false
		camera.fov = 100
		mouse_sensitivity = 0.03
		awp.visible = true
		
		
func _physics_process(delta):
	
	scope()
	
	direction = Vector3()
	
	move_and_slide(fall, Vector3.UP)
	
	if not is_on_floor():
		fall.y -= gravity
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		fall.y = jump
		
	
	if Input.is_action_pressed("move_forward"):
	
		direction -= transform.basis.z
	
	elif Input.is_action_pressed("move_backward"):
		
		direction += transform.basis.z
		
	if Input.is_action_pressed("move_left"):
		
		direction -= transform.basis.x			
		
	elif Input.is_action_pressed("move_right"):
		
		direction += transform.basis.x
			
		
	direction = direction.normalized()
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta) 
	velocity = move_and_slide(velocity, Vector3.UP) 

