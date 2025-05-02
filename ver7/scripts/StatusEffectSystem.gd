extends Node

class StatDebuff:
    var name = ""
    var level = 1
    var duration = 3.0

    func _init(_name, _level, _duration):
        name = _name
        level = _level
        duration = _duration

class StatusAilment:
    var name = ""
    var duration = 3.0

    func _init(_name, _duration):
        name = _name
        duration = _duration

var active_debuffs = []
var active_ailments = []

func _ready():
    print("상태이상 + 디버프 시스템 준비 완료.")

func apply_debuff(debuff_name, level, duration=3.0):
    for debuff in active_debuffs:
        if debuff.name == debuff_name:
            if debuff.level < level:
                debuff.level = level
            debuff.duration = duration
            return
    var new_debuff = StatDebuff.new(debuff_name, level, duration)
    active_debuffs.append(new_debuff)

func apply_ailment(ailment_name, duration=3.0):
    for ailment in active_ailments:
        if ailment.name == ailment_name:
            return
    var new_ailment = StatusAilment.new(ailment_name, duration)
    active_ailments.append(new_ailment)

func _process(delta):
    for debuff in active_debuffs:
        debuff.duration -= delta
    for ailment in active_ailments:
        ailment.duration -= delta

    var valid_debuffs = []
    for d in active_debuffs:
        if d.duration > 0:
            valid_debuffs.append(d)
    active_debuffs = valid_debuffs

    var valid_ailments = []
    for a in active_ailments:
        if a.duration > 0:
            valid_ailments.append(a)
    active_ailments = valid_ailments

func print_active_debuffs():
    for debuff in active_debuffs:
        print("[디버프]", debuff.name, "레벨:", debuff.level, "남은 시간:", debuff.duration)

func print_active_ailments():
    for ailment in active_ailments:
        print("[상태이상]", ailment.name, "남은 시간:", ailment.duration)

func get_debuff_list():
    return [
        "공격력감소", "마법공격력감소", "피해량감소", "방어력감소",
        "마법저항력감소", "받는피해량증가", "명중률감소", "회피율감소",
        "속도감소"
    ]

func get_ailment_list():
    return [
        "빙결", "중독", "출혈", "혼란", "매혹", "침묵",
        "회복불가", "버프불가", "기절", "수면",
        "도발", "공포", "속박"
    ]
