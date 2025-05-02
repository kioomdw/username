extends Node

class_name GameDataManager

# 저장할 데이터
var inventory_data: Array = []
var ally_data: Array = []
var player_gold: int = 0

# 저장 경로
const SAVE_PATH := "user://save_data.cfg"

var player_name: String = "이름없음"

func save_game():
    var config = ConfigFile.new()
    config.set_value("player", "inventory", inventory_data)
    config.set_value("player", "allies", ally_data)
    config.set_value("player", "gold", player_gold)
   config.set_value("player", "name", player_name)
    var err = config.save(SAVE_PATH)
    if err != OK:
        print("🔴 저장 실패:", err)
    else:
        print("✅ 저장 완료")

func load_game():
    var config = ConfigFile.new()
    var err = config.load(SAVE_PATH)
    if err != OK:
        print("⚠️ 저장 파일 없음. 기본값 사용")
        return

    inventory_data = config.get_value("player", "inventory", [])
    ally_data = config.get_value("player", "allies", [])
    player_gold = config.get_value("player", "gold", 0)
   player_name = config.get_value("player", "name", "이름없음")
    print("📂 저장된 데이터 불러오기 완료")

func reset_data():
    inventory_data = []
    ally_data = []
    player_gold = 0
    save_game()


