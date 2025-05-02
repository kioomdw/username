extends Node

func apply_skill(user, skill_name, skill_entry):
    if skill_entry.has("icon_path"):
        UIManager.show_skill_icon(skill_entry.icon_path)
    CooldownManager.start_cooldown(user, skill_name, skill_entry.cooldown)
    if skill_entry.has("effects"):
        for effect in skill_entry.effects:
            match effect.mode:
                "percent":
                    var base = user.get_stat(effect.stat)
                    var delta = base * (effect.value / 100.0)
                    StatusEffectManager.add_timed_buff(user, effect.stat, delta, effect.duration)
                "flat":
                    StatusEffectManager.add_timed_buff(user, effect.stat, effect.value, effect.duration)
    if has_method("_on_%s" % skill_name):
        call("_on_%s" % skill_name, user)