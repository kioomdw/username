extends Control

@onready var inventory_list = $InventoryList
@onready var return_button = $ReturnButton

func _ready():
    load_inventory()
    return_button.pressed.connect(self, "_on_ReturnButton_pressed")

func load_inventory():
    inventory_list.clear()
    var inventory = ConfigFile.new()
    var path = "user://inventory.cfg"
    if inventory.load(path) == OK:
        for item_name in inventory.get_section_keys("items"):
            var count = inventory.get_value("items", item_name, 0)
            var label = Label.new()
            label.text = "%s x%s" % [item_name, count]
            inventory_list.add_child(label)

func _on_ReturnButton_pressed():
    apply_button_effect($ReturnButton)
    GameDataManager.save_game()
    get_tree().change_scene_to_file("res://HomeScene.tscn")

func apply_button_effect(button):
    var tween = create_tween()
    tween.tween_property(button, "scale", Vector2(1.2, 1.2), 0.1)
    tween.tween_property(button, "scale", Vector2(1, 1), 0.1)
