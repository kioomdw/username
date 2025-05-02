extends Node

var ally_data = {}

func _ready():
    load_ally_data()

func load_ally_data():
    var file = File.new()
    if file.file_exists("res://scripts/Data/ally_data.json"):
        file.open("res://scripts/Data/ally_data.json", File.READ)
        var parsed = JSON.parse(file.get_as_text())
        if parsed.error == OK:
            ally_data = parsed.result.get("allies", {})
        else:
            push_error("Failed parsing ally_data.json: %s" % parsed.error_string)
        file.close()
    else:
        push_error("ally_data.json not found")
