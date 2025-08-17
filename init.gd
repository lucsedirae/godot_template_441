extends Node

const PATH_MODULES = "res://Modules/"

func _ready() -> void:
	var modules = get_modules(PATH_MODULES);
	

func get_modules(path: String) -> Array:
	var files = []
	var dir = DirAccess.open(path)
	
	if dir == null:
		print("Failed to open directory: ", path)
		return files
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	while file_name != "":
		if file_name.begins_with("init_") and file_name.ends_with(".gd"):
			files.append(file_name)
		file_name = dir.get_next()
	
	dir.list_dir_end()
	return files
	

func test():
		pass
# Example usage:
# var init_files = scan_init_files("res://scripts/")
# print(init_files)  # Outputs: ["init_player.gd", "init_enemy.gd", etc.]
