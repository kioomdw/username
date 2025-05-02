extends Node

func apply_passive(user, skill_name, skill_entry):
    if skill_entry.has("effects"):
        for effect in skill_entry.effects:
            match effect.mode:
                "percent":
                    var base = user.get_stat(effect.stat)
                    var delta = base * (effect.value / 100.0)
                    StatusEffectManager.add_timed_buff(user, effect.stat, delta, -1)
                "flat":
                    StatusEffectManager.add_timed_buff(user, effect.stat, effect.value, -1)