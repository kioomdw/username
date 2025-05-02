extends Node

class Ally:
    var name = ""
    var rarity = 3
    var base_stats = {}
    var active_skills = []
    var passive_skills = []
    var battle_skills = [] # 전투용 슬롯 스킬 (3개)
    var current_level = 1
    var current_exp = 0
    var max_exp = 100

    func _init(_name, _rarity, _base_stats, _active_skills, _passive_skills):
        name = _name
        rarity = _rarity
        base_stats = _base_stats.duplicate()
        active_skills = _active_skills.duplicate()
        passive_skills = _passive_skills.duplicate()
        set_default_battle_skills()

    func set_default_battle_skills():
        # 액티브 스킬 중 앞 3개를 기본으로 세팅
        for i in range(min(3, active_skills.size())):
            battle_skills.append(active_skills[i])

# 경험치 획득 함수
func gain_exp(id: String, amount: int):
    for ally in allies:
        if ally["id"] == id:
            ally["exp"] += amount
            while ally["exp"] >= get_required_exp(ally["level"]):
                ally["exp"] -= get_required_exp(ally["level"])
                ally["level"] += 1
                level_up(ally)
            break

# 경험치 요구량 계산
func get_required_exp(level: int) -> int:
    return 100 + (level - 1) * 50

# 레벨업 시 스탯 증가 (타입별 적용)
func level_up(ally):
    match ally["type"]:
        "공격형":
            ally["hp"] += 30
            ally["physical_attack"] += 15
            ally["magical_attack"] += 10
            ally["defense"] += 3
            ally["magic_resistance"] += 3
        "방어형":
            ally["hp"] += 70
            ally["physical_attack"] += 5
            ally["magical_attack"] += 5
            ally["defense"] += 10
            ally["magic_resistance"] += 10
        "마법형":
            ally["hp"] += 30
            ally["physical_attack"] += 5
            ally["magical_attack"] += 15
            ally["defense"] += 3
            ally["magic_resistance"] += 5
        "균형형":
            ally["hp"] += 50
            ally["physical_attack"] += 10
            ally["magical_attack"] += 10
            ally["defense"] += 5
            ally["magic_resistance"] += 5

    ally["hp"] = ally["hp"] # 체력 풀 회복 (필요시 max_hp 별도 관리 가능)




    func check_promotion():
        if current_level == 20:
            apply_promotion_boost(1)
            print(name, "1차 전직 완료!")
        elif current_level == 50:
            apply_promotion_boost(2)
            print(name, "2차 전직 완료!")

    
func _ready():
    print("동료 관리 시스템 준비 완료.")

func add_ally(name, rarity, base_stats, active_skills, passive_skills):
    var new_ally = Ally.new(name, rarity, base_stats, active_skills, passive_skills)
    ally_list.append(new_ally)
    print("동료 추가됨:", name)
    GameDataManager.save_game()

func show_allies():
    for ally in ally_list:
        print("동료:", ally.name, "| 레벨:", ally.current_level, "| 등급:", ally.rarity, "성")

func show_ally_detail(ally_name):
    for ally in ally_list:
        if ally.name == ally_name:
            print("[동료 상세정보]")
            print("이름:", ally.name)
            print("레벨:", ally.current_level)
            print("등급:", ally.rarity, "성")
            print("스탯:")
            for stat in ally.base_stats.keys():
                print("-", stat, ":", ally.base_stats[stat])
            print("액티브 스킬:", ally.active_skills)
            print("패시브 스킬:", ally.passive_skills)
            print("전투 슬롯 스킬:", ally.battle_skills)

func strengthen_ally(ally_name, stat_key, amount):
    for ally in ally_list:
        if ally.name == ally_name and stat_key in ally.base_stats:
            ally.base_stats[stat_key] += amount
            print(ally.name, stat_key, "강화 완료! +", amount)

func promote_ally(ally_name):
    for ally in ally_list:
        if ally.name == ally_name:
            ally.check_promotion()


func get_required_exp(level: int) -> int:
    return int(50 * pow(level, 1.5))


# AllyManager.gd

func create_ally(ally_data):
    var ally = Ally.new()
    ally.name = ally_data["name"]
    
    # 체력 관련 수정
    ally.max_hp = ally_data["base_stats"]["hp"]
    ally.current_hp = ally.max_hp

    # 나머지 스탯
    ally.physical_attack = ally_data["base_stats"]["physical_attack"]
    ally.magical_attack = ally_data["base_stats"]["magical_attack"]
    ally.defense = ally_data["base_stats"]["defense"]
    ally.magic_resistance = ally_data["base_stats"]["magic_resistance"]
    ally.speed = ally_data["base_stats"]["speed"]
    ally.critical_rate = ally_data["base_stats"]["critical_rate"]
    ally.critical_damage = ally_data["base_stats"]["critical_damage"]
    ally.evasion_rate = ally_data["base_stats"]["evasion_rate"]
    ally.accuracy = ally_data["base_stats"]["accuracy"]

    # 스킬 세팅
    ally.skills = ally_data["skills"]

    return ally

# 경험치 누적 + 레벨업 처리
func gain_experience(id, exp_gain):
    if not allies.has(id):
        return # 존재하지 않으면 무시

    var ally = allies[id]
    ally["exp"] += exp_gain

    var required_exp = 100 + (ally["level"] - 1) * 20  # 레벨업 필요 경험치 공식

    while ally["exp"] >= required_exp:
        ally["exp"] -= required_exp
        ally["level"] += 1
        level_up(ally)
        print(ally["name"], " 레벨업! 현재 레벨: ", ally["level"])

        required_exp = 100 + (ally["level"] - 1) * 20  # 다음 레벨업 경험치 갱신

# 신규 캐릭터 등록
allies["엘로이즈"] = AllyData.get_data("엘로이즈")
allies["로웬"] = AllyData.get_data("로웬")

func apply_promotion_boost(phase):
    if not AllyData.has_data(name):
        return
    var promo = AllyData.get_data(name).get("promotion_bonus", {})
    if promo.has(phase):
        for stat in promo[phase]:
            if base_stats.has(stat):
                base_stats[stat] += promo[phase][stat]


# ====== 장비 기반 데미지 계산 확장 ======
var bonus_physical_damage := 0
var bonus_magical_damage := 0
var weapon_multiplier := 1.0
var bonus_physical_percent := 0
var bonus_magical_percent := 0

# 실전 데미지 계산: 물리 or 마법
func get_total_damage(base, type: String, skill_coeff: float) -> int:
    var flat_bonus := (type == "physical") ? bonus_physical_damage : bonus_magical_damage
    var percent_bonus := (type == "physical") ? bonus_physical_percent : bonus_magical_percent
    var multiplier := weapon_multiplier if type == "physical" else 1.0  # 마법 무기는 multiplier 없음 처리

    var base_damage = base * skill_coeff + flat_bonus
    base_damage *= multiplier
    base_damage += int(base_damage * (percent_bonus / 100.0))

    return int(base_damage)

# ====== 장비 장착 처리 ======
func equip_item(slot: String, item_data: Dictionary):
    if slot == "weapon":
        if item_data.has("bonus_physical_damage"):
            bonus_physical_damage = item_data["bonus_physical_damage"]
        if item_data.has("bonus_magical_damage"):
            bonus_magical_damage = item_data["bonus_magical_damage"]
        if item_data.has("weapon_multiplier"):
            weapon_multiplier = item_data["weapon_multiplier"]
    elif slot == "accessory":
        if item_data.has("bonus_physical_percent"):
            bonus_physical_percent = item_data["bonus_physical_percent"]
        if item_data.has("bonus_magical_percent"):
            bonus_magical_percent = item_data["bonus_magical_percent"]