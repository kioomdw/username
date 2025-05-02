extends Node

var all_gauges = [] # 모든 행동게이지를 관리
var action_gauges = {} # 캐릭터별 행동게이지

func _ready():
    print("행동 게이지 시스템 준비 완료.")

# 행동 게이지 등록
func register_actor(actor):
    all_gauges.append(actor)
    action_gauges[actor] = 0

# 행동 게이지 업데이트 (매 프레임 호출)
func update_gauges(delta):
    for actor in all_gauges:
        if actor.base_stats.has("speed"):
            action_gauges[actor] += actor.base_stats["speed"] * delta * 0.1
            if action_gauges[actor] > 100:
                action_gauges[actor] = 100

# 행동 가능한 캐릭터 찾기
func get_ready_actor():
    for actor in all_gauges:
        if action_gauges.get(actor, 0) >= 100:
            return actor
    return null

# 특정 캐릭터 게이지 초기화
func reset_gauge(actor):
    if action_gauges.has(actor):
        action_gauges[actor] = 0

# 아군 전체 게이지 추가 (ex: 버프용)
func add_gauge_to_allies(amount):
    for actor in all_gauges:
        if actor.name.begins_with("ally_"):
            action_gauges[actor] += amount
            if action_gauges[actor] > 100:
                action_gauges[actor] = 100

# 아군 전체 행동게이지 상승
func boost_allies_action_gauge(percent):
    for actor in all_gauges:
        if actor.name.begins_with("ally_") and actor in action_gauges:
            action_gauges[actor] += percent
            if action_gauges[actor] > 100:
                action_gauges[actor] = 100