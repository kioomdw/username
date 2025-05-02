# GachaSystem.gd
extends Node

var gacha_currency = 0
var gacha_cost = 100

var four_star_units = ["4성 동료 A", "4성 동료 B", "4성 동료 C", "4성 동료 D", "4성 동료 E", "4성 동료 F", "4성 동료 G", "4성 동료 H", "4성 동료 I", "4성 동료 J"]
var five_star_units = ["5성 동료 X", "5성 동료 Y", "5성 동료 Z", "5성 동료 W", "5성 동료 V", "5성 동료 U", "5성 동료 T", "5성 동료 S"]

var summon_result_label
var summon_animation

func _ready():
    setup_ui()

func setup_ui():
    summon_result_label = Label.new()
    summon_result_label.position = Vector2(500, 600)
    summon_result_label.text = "소환 결과 대기 중"
    add_child(summon_result_label)

    summon_animation = AnimationPlayer.new()
    add_child(summon_animation)
    setup_animation()

func setup_animation():
    var anim = Animation.new()
    anim.length = 2.0
    anim.track_insert_key(0, 0.0, Vector2(640, 0))
    anim.track_insert_key(0, 2.0, Vector2(640, 720))
    summon_animation.add_animation("summon_effect", anim)

func attempt_summon():
    if gacha_currency >= gacha_cost:
        gacha_currency -= gacha_cost
        summon_animation.play("summon_effect")
        yield(summon_animation, "animation_finished")
        perform_summon()
    else:
        print("가챠 재화 부족!")

func perform_summon():
    var roll = randi() % 100
    if roll < 2:
        summon_five_star()
    elif roll < 12:
        summon_four_star()
    else:
        summon_three_star()


func summon_four_star():
    var index = randi() % four_star_units.size()
    summon_result_label.text = "★4 동료 획득: " + four_star_units[index]
    print("★4 동료 획득: ", four_star_units[index])
    GameDataManager.ally_data.append(new_ally)
    GameDataManager.save_game()

func summon_five_star():
    var index = randi() % five_star_units.size()
    summon_result_label.text = "★5 동료 획득: " + five_star_units[index]
    print("★5 동료 획득: ", five_star_units[index])
    GameDataManager.ally_data.append(new_ally)
    GameDataManager.save_game()

func summon_three_star():
    summon_result_label.text = "★3 기본 병사 획득"
    print("★3 기본 병사 획득")
    GameDataManager.ally_data.append(new_ally)
    GameDataManager.save_game()

# 재화 지급 (퀘스트, 보상 등에서 호출)
func add_gacha_currency(amount):
    gacha_currency += amount
    print("가챠 재화 추가됨: ", gacha_currency)

# 재화 사용 (추후 확장 가능)
func spend_gacha_currency(amount):
    if gacha_currency >= amount:
        gacha_currency -= amount
        return true
    return false