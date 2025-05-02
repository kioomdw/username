# HiddenBossSystem.gd
extends Node

var hidden_boss_spawned = false
var hidden_boss_defeated = false

var boss_hp = 3000
var player_hp = 1000

signal boss_defeated

func _ready():
    print("숨겨진 보스 시스템 준비 완료.")

# 숨겨진 보스 소환 함수
func spawn_hidden_boss():
    if not hidden_boss_spawned:
        hidden_boss_spawned = true
        boss_hp = 3000
        print("숨겨진 보스 등장!")
        show_boss_announcement()

func show_boss_announcement():
    var announcement = Label.new()
    announcement.text = "숨겨진 보스가 출현했습니다!"
    announcement.position = Vector2(400, 300)
    announcement.set_scale(Vector2(2,2))
    add_child(announcement)

# 플레이어가 보스와 전투할 때 호출
func player_attack_boss(damage):
    if hidden_boss_spawned and not hidden_boss_defeated:
        boss_hp -= damage
        print("보스에게 ", damage, " 데미지를 입혔다. 남은 HP:", boss_hp)
        check_boss_defeat()

# 보스가 플레이어를 공격할 때 호출
func boss_attack_player():
    player_hp -= 200
    print("보스 공격! 플레이어 남은 HP:", player_hp)
    check_player_defeat()

func check_boss_defeat():
    if boss_hp <= 0:
        hidden_boss_defeated = true
        print("숨겨진 보스 처치 성공!")
        emit_signal("boss_defeated")
        give_hidden_reward()

func check_player_defeat():
    if player_hp <= 0:
        print("플레이어 패배! 보스를 쓰러뜨리지 못했습니다.")
        get_tree().change_scene_to_file("res://scenes/FieldScene.tscn")

func give_hidden_reward():
    print("특별한 전설 장비를 획득했습니다!")
    GameDataManager.save_game()

    # 장비 지급 로직 추가 예정

# 외부 호출용 (필드나 특정 조건 달성 시)
func trigger_hidden_boss():
    spawn_hidden_boss()