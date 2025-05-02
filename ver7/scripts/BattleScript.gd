extends Node

class_name BattleScript

# ====== 전역 변수 ======
var allies = []
var enemies = []
var turn_queue = []
var current_turn_unit = null
var is_battle_active = false
var selected_skill_name = ""

# ====== 전투 시작 ======
func start_battle(ally_units, enemy_units):
    allies = ally_units
    enemies = enemy_units
    turn_queue = allies + enemies
    turn_queue.sort_custom(self, "compare_speed")
    is_battle_active = true
    start_turn()

# ====== 속도 비교 ======
func compare_speed(a, b):
    return b.speed - a.speed

# ====== 턴 시작 ======
func start_turn():
    if not is_battle_active:
        return

    if turn_queue.size() == 0:
        refill_turn_queue()

    current_turn_unit = turn_queue.pop_front()

    if not current_turn_unit.is_alive():
        start_turn()
        return

    if current_turn_unit.is_enemy:
        enemy_turn()
    else:
        player_turn()

# ====== 턴 큐 리필 ======
func refill_turn_queue():
    turn_queue = []
    for unit in allies + enemies:
        if unit.is_alive():
            turn_queue.append(unit)
    turn_queue.sort_custom(self, "compare_speed")

# ====== 적 턴 ======
func enemy_turn():
    var available_skills = []
    for skill_data in current_turn_unit.skills:
        if skill_data["type"] == "active":
            if not current_turn_unit.skill_cooldowns.has(skill_data["name"]) or current_turn_unit.skill_cooldowns[skill_data["name"]] == 0:
                available_skills.append(skill_data)

    if available_skills.size() > 0:
        var random_skill = available_skills[randi() % available_skills.size()]
        SkillSystem.activate_skill(current_turn_unit, random_skill["name"])
    else:
        var target = SkillSystem.choose_single_ally()
        if target:
            SkillSystem.deal_physical_damage(target, current_turn_unit, 1.0)

    end_turn()

# ====== 플레이어 턴 ======
func player_turn():
    show_skill_panel()
    # 여기서 UI를 통해 skill_name을 선택하고
    # 선택이 완료되면 use_skill(skill_name)을 호출해야 함

func show_skill_panel():
    $SkillPanel.visible = true
    for btn in $SkillPanel.get_children():
        btn.disabled = false
        btn.show()

# ====== 스킬 사용 ======
func use_skill(skill_name):
    if current_turn_unit == null:
        return

    if not current_turn_unit.is_alive():
        start_turn()
        return

    var success = SkillSystem.activate_skill(current_turn_unit, skill_name)
    if success:
        end_turn()
    else:
        print("스킬 사용 실패")

# === 버튼에서 호출될 함수 ===
func _on_SkillButton_pressed(skill_name):
    $SkillPanel.visible = false
    use_skill(skill_name)

# ====== 턴 종료 ======
func end_turn():
    # 현재 유닛의 스킬 쿨다운 감소
    for skill_data in current_turn_unit.skills:
        if skill_data["type"] == "active":
            if current_turn_unit.skill_cooldowns.has(skill_data["name"]):
                current_turn_unit.skill_cooldowns[skill_data["name"]] = max(0, current_turn_unit.skill_cooldowns[skill_data["name"]] - 1)

    check_battle_end()
    if is_battle_active:
        start_turn()


# ====== 전투 종료 체크 ======
func check_battle_end():
    var allies_alive = false
    var enemies_alive = false

    for ally in allies:
        if ally.is_alive():
            allies_alive = true
            break

    for enemy in enemies:
        if enemy.is_alive():
            enemies_alive = true
            break

    if not allies_alive:
        is_battle_active = false
        print("패배")
       show_battle_result(false) # ✅ 패배 결과창 띄우기
    elif not enemies_alive:
        is_battle_active = false
        print("승리")
        distribute_exp_to_party(50)
        show_battle_result(true)    # ✅ 승리 결과창 띄우기

# ====== 경험치 분배 함수 ======
func distribute_experience():
    var exp_gain = 100  # 예시로 100 경험치 (나중에 전투 난이도에 따라 조정 가능)
    GameDataManager.save_game()

    for ally in allies:
        if ally.is_alive():
            AllyManager.gain_experience(ally["id"], exp_gain)

# ====== 유틸성 함수 ======
func get_random_alive_enemy():
    return SkillSystem.choose_single_enemy()

func get_random_alive_allies(count):
    return SkillSystem.choose_multiple_allies(count)

func get_all_enemies():
    return SkillSystem.get_all_enemies()

func get_all_allies():
    return SkillSystem.get_all_allies()








func spawn_enemy(enemy_data):
    var enemy_scene = preload("res://scenes/Enemy.tscn")  # 적 프리팹 경로 (수정 가능)
    var enemy = enemy_scene.instantiate()

    # 스탯 부여
    enemy.hp = enemy_data["hp"]
    enemy.physical_attack = enemy_data["physical_attack"]
    enemy.magical_attack = enemy_data["magical_attack"]
    enemy.defense = enemy_data["defense"]
    enemy.magic_resistance = enemy_data["magic_resistance"]
    enemy.speed = enemy_data["speed"]
    enemy.skills = enemy_data["skills"]

    # 배치
    enemy.position = Vector2(700, 300)  # 필드 내 좌표
    add_child(enemy)






var enemy = EnemyData["잔재된 감정"]
spawn_enemy(enemy)


var is_tutorial = true  # 이 전투가 튜토리얼인지 여부


get_tree().change_scene_to_file("res://scenes/StoryScene.tscn")
StorySystem.load("story_ch1_intro.json")




