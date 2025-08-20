extends CharacterBody3D

@export var speed = 5.0
@export var jump_velocity = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta):
	# Add gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	# Get input direction using WASD controls
	var input_dir = Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		input_dir.x -= 1
	if Input.is_action_pressed("move_right"):
		input_dir.x += 1
	if Input.is_action_pressed("move_up"):
		input_dir.y -= 1  # Forward (negative Z in 3D)
	if Input.is_action_pressed("move_down"):
		input_dir.y += 1  # Backward (positive Z in 3D)

	# Apply horizontal movement
	if input_dir != Vector2.ZERO:
		velocity.x = input_dir.x * speed
		velocity.z = input_dir.y * speed  # Map input_dir.y to velocity.z
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	# Apply the movement
	move_and_slide()
