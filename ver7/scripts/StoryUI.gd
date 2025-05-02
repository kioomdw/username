extends CanvasLayer

var dialogue_index := 0
var dialogue_data := []

@onready var character_image = $CharacterImage
@onready var name_label = $DialogueBox/NameLabel
@onready var text_label = $DialogueBox/DialogueLabel
@onready var next_indicator = $DialogueBox/NextIndicator
@onready var skip_button = $SkipButton

func _ready():
    load_story("res://data/story_intro.json")
    show_dialogue(dialogue_index)
    next_indicator.connect("pressed", self, "_on_NextIndicator_pressed")
    skip_button.connect("pressed", self, "_on_SkipButton_pressed")

func load_story(path: String):
    var file = File.new()
    if file.open(path, File.READ) == OK:
        var text = file.get_as_text()
        var result = JSON.parse(text)
        if result.error == OK:
            dialogue_data = result.result
        file.close()

func show_dialogue(index):
    if index >= dialogue_data.size():
        end_story()
        return
    var entry = dialogue_data[index]
    var speaker_name = entry.get("name", "")
    if speaker_name == "주인공":
        speaker_name = GameDataManager.player_name
    name_label.text = speaker_name
    text_label.text = entry.get("text", "")
    var image_path = "res://characters/%s.png" % entry.get("name", "")
    if ResourceLoader.exists(image_path):
        character_image.texture = load(image_path)
    else:
        character_image.texture = null
    next_indicator.visible = true

func _on_NextIndicator_pressed():
    dialogue_index += 1
    show_dialogue(dialogue_index)

func _on_SkipButton_pressed():
    end_story()

func end_story():
    queue_free()
