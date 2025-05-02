extends Node
var user_cooldowns = {}

func is_on_cooldown(user, skill_name):
    return user_cooldowns.get(user.id, {}).has(skill_name) and user_cooldowns[user.id][skill_name] > 0

func start_cooldown(user, skill_name, duration):
    if not user_cooldowns.has(user.id):
        user_cooldowns[user.id] = {}
    user_cooldowns[user.id][skill_name] = duration

func tick_cooldowns():
    for id in user_cooldowns.keys():
        for skill in user_cooldowns[id].keys():
            if user_cooldowns[id][skill] > 0:
                user_cooldowns[id][skill] -= 1