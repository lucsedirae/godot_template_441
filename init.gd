# root/init.gd
extends Node

## Scene identifier for the main game scene
const SCENE_MAIN: String = "main"

## Initializes the game on startup
func _ready() -> void:
	ControlsManager.init_controls()
	SceneManager.load_scene(SCENE_MAIN)
