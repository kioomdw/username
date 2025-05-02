extends Control

var selected_character_texture : Texture
var selected_background_texture : Texture

@onready var background = $Background
@onready var character_display = $CharacterDisplay
@onready var menu_overlay = $MenuOverlay
@onready var open_menu_button = $OpenMenuButton

func _ready():
    load_background()
    load_character()
    menu_overlay.visible = false
    open_menu_button.pressed.connect(show_menu)
    character_display.gui_input.connect(on_character_clicked)

func load_background():
    # 백그라운드 로드 로직 구현
    pass

func load_character():
    # 캐릭터 로드 로직 구현
    pass

func show_menu():
    menu_overlay.visible = true

func on_character_clicked(event):
    # 캐릭터 클릭 처리 로직 구현
    pass
