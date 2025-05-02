extends Control

var craftable_items = [
    {"name": "브론즈 소드", "id": "bronze_sword"},
    {"name": "아이언 쉴드", "id": "iron_shield"}
]

@onready var item_list = $ItemList
@onready var craft_button = $CraftButton
@onready var return_button = $ReturnButton

func _ready():
    populate_items()
    craft_button.pressed.connect(craft_selected_item)
    return_button.pressed.connect(func():
        get_tree().change_scene_to_file("res://HomeScene.tscn")
    )

func populate_items():
    for item in craftable_items:
        var entry = Button.new()
        entry.text = item["name"]
        entry.name = item["id"]
        item_list.add_child(entry)

func craft_selected_item():
    if item_list.get_child_count() == 0:
        return
    var selected = item_list.get_child(0) # 첫 번째 항목 제작 (임시, 나중에 선택방식 변경 가능)
    var inventory = ConfigFile.new()
    var path = "user://inventory.cfg"
    var err = inventory.load(path)
    if err != OK:
        inventory = ConfigFile.new()
    var count = inventory.get_value("items", selected.name, 0)
    inventory.set_value("items", selected.name, count + 1)
    inventory.save(path)
    print("제작 완료: " + selected.text)
    GameDataManager.save_game()
