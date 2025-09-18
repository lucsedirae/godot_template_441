# root/init.gd
extends Node

## Scene identifier for the main game scene
const SCENE_MAIN: String = "main"

## Node name of the camera that should be loaded by default
const CAMERA_PLAYER: String = "PlayerCamera"

## Initializes the game on startup
func _ready() -> void:
	ControlsManager.init_controls()
	SceneManager.load_scene(SCENE_MAIN)
	CameraManager.find_all_cameras(self)
	CameraManager.set_current(CAMERA_PLAYER)

## Global input handling
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("cycle_camera"):
		CameraManager.cycle_next_camera()
