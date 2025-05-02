# EnemyData.gd
# 이 파일은 게임 내 등장하는 적(몬스터)들의 데이터를 저장하는 곳입니다.
# 각 적은 고유한 외형, 설명, 전투 방식, 특수 효과를 지니며 세계관과 연계됩니다.

var EnemyData = {
    # ■ 적 이름: 잔재된 감정 (Residual Wraith)
    # 설명: 봉인된 구역에 남아 있던 감정—슬픔, 분노, 집착—이 육체화된 존재.
    # 외형: 얼굴이 여러 개 뒤틀려 붙어 있는 흐릿한 검은 형체. 비명을 지르듯 진동함.
    # 전투 타입: 단일 대상 마법 공격, 낮은 속도, 중간 수준 피해량.
    "잔재된 감정": {
        "hp": 400,  # 체력 (낮음, 튜토리얼 전용)
        "physical_attack": 72,  # 물리 공격력 (보조용)
        "magical_attack": 108,  # 마법 공격력 (주력 피해)
        "defense": 25,  # 방어력 (낮음)
        "magic_resistance": 20,  # 마법 저항 (낮음)
        "speed": 40,  # 속도 (매우 느림)
        "skills": [
            {
                "name": "뒤틀린 울음",  # 스킬 이름
                "type": "active",  # 액티브 스킬
                "description": "적 하나에게 정신적 충격을 주는 음파 공격",  # 설명
                "cooldown": 3  # 3턴 간격으로 발동
            }
        ]
    }

"감염된 늑대": {
    "base_stats": {
        "hp": 600, "physical_attack": 80, "magical_attack": 20,
        "defense": 30, "magic_resistance": 20, "speed": 130,
        "critical_rate": 10, "critical_damage": 150
    },
    "skills": ["출혈 물기"],
    "drops": ["동물가죽", "쇠붙이 조각"]
},
"망가진 방어병": {
    "base_stats": {
        "hp": 900, "physical_attack": 50, "magical_attack": 0,
        "defense": 100, "magic_resistance": 50, "speed": 60,
        "critical_rate": 0, "critical_damage": 100
    },
    "skills": ["둔중한 타격"],
    "drops": ["고철", "방어 파편"]
},
"약탈자": {
    "base_stats": {
        "hp": 700, "physical_attack": 100, "magical_attack": 0,
        "defense": 40, "magic_resistance": 30, "speed": 100,
        "critical_rate": 15, "critical_damage": 160
    },
    "skills": ["맹공", "중독 찌르기"],
    "drops": ["낡은 칼", "상처 약초"]
},
"돌연변이 광부": {
    "base_stats": {
        "hp": 800, "physical_attack": 90, "magical_attack": 0,
        "defense": 60, "magic_resistance": 40, "speed": 80,
        "critical_rate": 5, "critical_damage": 140
    },
    "skills": ["흙먼지 던지기", "곤봉 내리찍기"],
    "drops": ["삽날", "흙먼지 속 주머니"]
},
"감염된 조류": {
    "base_stats": {
        "hp": 400, "physical_attack": 60, "magical_attack": 0,
        "defense": 10, "magic_resistance": 20, "speed": 150,
        "critical_rate": 20, "critical_damage": 150
    },
    "skills": ["날개 베기", "빠른 돌진"],
    "drops": ["깃털", "날개뼈"]
},
"붉은 진균괴": {
    "base_stats": {
        "hp": 750, "physical_attack": 30, "magical_attack": 80,
        "defense": 35, "magic_resistance": 70, "speed": 90,
        "critical_rate": 0, "critical_damage": 100
    },
    "skills": ["진균 포자", "혼란의 포효"],
    "drops": ["점액", "진균 핵"]
}

}