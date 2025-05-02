extends Node

var is_ready = false

func _ready():
    preload_ui()
    setup_music()
    start_loading_animation()
    set_process_input(true)
    save_manager.load_game()
    if GameDataManager.player_name == "이름없음":
        get_player_name()
    else:
        go_to_home_scene()

func preload_ui():
    # 필요한 리소스를 미리 불러오는 작업
    pass

func setup_music():
    var bgm = AudioStreamPlayer.new()
    bgm.stream = load("res://assets/music/main_bgm.ogg")
    bgm.autoplay = true
    add_child(bgm)

func start_loading_animation():
    # 로딩 애니메이션 로직 구현
    pass

func get_player_name():
    # 플레이어 이름 입력 로직
    var dialog = WindowDialog.new()
    dialog.popup_centered()
    dialog.get_ok().connect("pressed", self, "_on_NameEntered", [dialog])
    add_child(dialog)

func _on_NameEntered(dialog):
    var name_input = dialog.get_line_edit().text
    GameDataManager.player_name = name_input
    dialog.queue_free()
    go_to_home_scene()

func go_to_home_scene():
    get_tree().change_scene("res://scenes/Home.tscn")
