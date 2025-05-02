extends Node
var active_effects = {}

func add_timed_buff(user, stat, value, duration):
    if not active_effects.has(user.id):
        active_effects[user.id] = []
    active_effects[user.id].append({
        "stat": stat,
        "value": value,
        "duration": duration
    })

func process_effects():
    for id in active_effects.keys():
        for effect in active_effects[id]:
            if effect.duration == 0:
                continue
            user = get_user_by_id(id)
            user.modify_stat(effect.stat, effect.value)
            if effect.duration > 0:
                effect.duration -= 1