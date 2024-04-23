extends Node

func parse_json_to_dict(path_to_json:String) -> Dictionary:
	var file = path_to_json
	var json_as_text = FileAccess.get_file_as_string(file)
	var json_as_dict = JSON.parse_string(json_as_text)
	if json_as_dict:
		return json_as_dict
	else:#I need to do some error handling here in the future
		return {}
