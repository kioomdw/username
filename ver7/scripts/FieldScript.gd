# FieldScript.gd
extends Node2D

var player
var camera
var ui_layer
var interact_prompt
var npc_list = []
var portal_areas = []
var quest_manager

func _ready():
    preload_map()
    setup_player()
    setup_camera()
    setup_ui()
    setup_npcs()
    setup_portals()
    quest_manager = QuestManager.new()
    add_child(quest_manager)
    setup_buttons()
    safe_area.connect("body_entered", self, "_on_SafeArea_body_entered")

func preload_map():
    var background = Sprite2D.new()
    background.texture = load("res://assets/backgrounds/field_bg.png")
    background.position = Vector2(640, 360)
    add_child(background)

func setup_player():
    player = Sprite2D.new()
    player.texture = load("res://assets/characters/lilia_idle.png")
    player.position = Vector2(640, 360)
    add_child(player)

func setup_camera():
    camera = Camera2D.new()
    camera.current = true
    player.add_child(camera)

func setup_ui():
    ui_layer = CanvasLayer.new()
    interact_prompt = Label.new()
    interact_prompt.text = "[E] 상호작용"
    interact_prompt.visible = false
    interact_prompt.position = Vector2(600, 700)
    ui_layer.add_child(interact_prompt)
    add_child(ui_layer)

func setup_npcs():
    for i in range(3):
        var npc = Sprite2D.new()
        npc.texture = load("res://assets/characters/npc_" + str(i) + ".png")
        npc.position = Vector2(300 + i * 200, 500)
        add_child(npc)
        npc_list.append(npc)

func setup_portals():
    var portal = Area2D.new()
    var sprite = Sprite2D.new()
    sprite.texture = load("res://assets/objects/portal.png")
    portal.add_child(sprite)
    portal.position = Vector2(1000, 800)
    var collision = CollisionShape2D.new()
    collision.shape = CircleShape2D.new()
    collision.shape.radius = 50
    portal.add_child(collision)
    portal.connect("body_entered", self, "_on_portal_entered")
    add_child(portal)
    portal_areas.append(portal)

func _process(delta):
    var input_vector = Vector2.ZERO

    if Input.is_action_pressed("ui_right"):
        input_vector.x += 1
    if Input.is_action_pressed("ui_left"):
        input_vector.x -= 1
    if Input.is_action_pressed("ui_down"):
        input_vector.y += 1
    if Input.is_action_pressed("ui_up"):
        input_vector.y -= 1

    input_vector = input_vector.normalized()
    player.position += input_vector * 200 * delta

    check_npc_interaction()

func check_npc_interaction():
    interact_prompt.visible = false
    for npc in npc_list:
        if player.position.distance_to(npc.position) < 80:
            interact_prompt.visible = true
            if Input.is_action_just_pressed("interact"):
                _talk_to_npc(npc)

func _talk_to_npc(npc):
    print("NPC와 대화했습니다.")
    quest_manager.give_reward("gacha_currency", 10)

func _on_portal_entered(body):
    if body == player:
        get_tree().change_scene_to_file("res://scenes/BattleScene.tscn")

# 퀘스트 매니저 클래스
class QuestManager:
    extends Node

    var gacha_currency = 0

    func give_reward(item_type, amount):
        if item_type == "gacha_currency":
            gacha_currency += amount
            print("가챠 재화 획득: ", gacha_currency)
            GameDataManager.save_game()

    func spend_currency(amount):
        if gacha_currency >= amount:
            gacha_currency -= amount
            print("가챠 재화 사용: ", gacha_currency)
            return true
        else:
            print("가챠 재화 부족")
            return false

# 전투를 시작할 때, 현재 씬 경로 저장
previous_scene_path = get_tree().current_scene.filename
get_tree().change_scene("res://BattleScene.tscn")


# FieldScript.gd

extends Node2D

var encounter_chance := 0.05 # 5% 확률
var encounter_cooldown := 5.0 # 5초 쿨타임
var can_encounter := true

# 현재 필드에 등장할 수 있는 몬스터 리스트
var encounter_enemy_list = [
    {"name": "Slime", "base_exp": 50, "base_gold": 30},
    {"name": "Goblin", "base_exp": 80, "base_gold": 50},
    {"name": "Wolf", "base_exp": 100, "base_gold": 70}
]

onready var random = RandomNumberGenerator.new()

func _ready():
    random.randomize()

func _process(delta):
    if Input.is_action_just_pressed("ui_right") or Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down"):
        try_encounter()

func try_encounter():
    if not can_encounter:
        return

    if random.randf() < encounter_chance:
        print("Encounter! Battle Start!")
        can_encounter = false
        start_battle()
        yield(get_tree().create_timer(encounter_cooldown), "timeout")
        can_encounter = true

func start_battle():
    # BattleScene으로 적 리스트를 넘기면서 이동
    var battle_scene = load("res://scenes/BattleScene.tscn").instantiate()
    battle_scene.encounter_enemy_list = encounter_enemy_list
    get_tree().root.add_child(battle_scene)
    queue_free()


func setup_buttons():
    $BackButton.connect("pressed", self, "_on_BackButton_pressed")

# === 버튼 눌림 처리 ===
func _on_BackButton_pressed():
    apply_button_effect($BackButton)
    go_to_home_scene()

# === 버튼 이펙트 ===
func apply_button_effect(button):
    var tween = create_tween()
    tween.tween_property(button, "scale", Vector2(1.2, 1.2), 0.1)
    tween.tween_property(button, "scale", Vector2(1, 1), 0.1)

# === 씬 이동 ===
func go_to_home_scene():
    get_tree().change_scene_to_file("res://HomeScene.tscn")


func trigger_story():
    var story_layer = load("res://scripts/ui/StoryUI.gd").new()
    add_child(story_layer)



@onready var safe_area = $SafeArea  # 예: Area2D 노드


func _on_SafeArea_body_entered(body):
    if body.name == "Player":  # 또는 조건에 따라
        trigger_story()
        safe_area.queue_free()  # 컷씬 중복 방지

