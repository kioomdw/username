extends Control

# 거주지용 슬롯 관리
@onready var building_slots = [$BuildingSlot1, $BuildingSlot2, $BuildingSlot3]
@onready var harvest_button = $HarvestButton
@onready var decorate_slots = [$DecorateSlot]

func _ready():
    for slot in building_slots:
        slot.pressed.connect(func(): on_building_slot_pressed(slot.name))
    for deco in decorate_slots:
        deco.pressed.connect(func(): on_decorate_slot_pressed(deco.name))
    harvest_button.pressed.connect(on_harvest_pressed)

func on_building_slot_pressed(slot_name):
    print("건물 슬롯 선택:", slot_name)
    # 건물 강화 UI 띄우기 예정

func on_decorate_slot_pressed(slot_name):
    print("장식 슬롯 선택:", slot_name)
    # 장식 변경 UI 띄우기 예정

func on_harvest_pressed():
    print("자원 수확 실행")
    # 수확 기능 구현 예정

func apply_button_effect(button):
    var tween = create_tween()
    tween.tween_property(button, "scale", Vector2(1.2, 1.2), 0.1)
    tween.tween_property(button, "scale", Vector2(1, 1), 0.1)
