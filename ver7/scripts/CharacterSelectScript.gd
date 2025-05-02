extends Control

var characters = [
    {"name": "릴리아", "texture_path": "res://assets/characters/lilia.png"},
    {"name": "프레이야", "texture_path": "res://assets/characters/freya.png"},
    {"name": "에리스", "texture_path": "res://assets/characters/eris.png"}
]

@onready var character_list = $CharacterList
@onready var return_button = $ReturnButton

func _ready():
    populate_characters()
    return_button.pressed.connect(func():
        get_tree().change_scene_to_file("res://HomeScene.tscn")
    )

func populate_characters():
    for char in characters:
        var btn = Button.new()
        btn.text = char["name"]
        btn.pressed.connect(func(): select_character(char["texture_path"]))
        character_list.add_child(btn)

func select_character(texture_path: String):
    var config = ConfigFile.new()
    config.set_value("home", "selected_character_texture", texture_path)
    config.save("user://save_config.cfg")
    get_tree().change_scene_to_file("res://HomeScene.tscn")

# 캐릭터 선택 화면에 추가
selectable_characters.append("엘로이즈")
selectable_characters.append("로웬")
