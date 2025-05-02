# StorySystem.gd
extends Node

var current_chapter = 1
var chapter_objectives = {}
var chapter_completed = {}

signal chapter_cleared(chapter_number)

func _ready():
    setup_chapters()
    start_chapter(current_chapter)

func setup_chapters():
    chapter_objectives = {
        1: ["마을 사람과 대화하기", "필드에서 첫 번째 포탈 찾기"],
        2: ["신전 유적 조사하기", "숨겨진 동료 발견하기"],
        3: ["피의 숲 생존자 구출하기", "숨겨진 보스 처치하기"],
        4: ["검은 심연 진입", "최종 보스 처치"]
    }
    for key in chapter_objectives.keys():
        chapter_completed[key] = []

func start_chapter(chapter_num):
    print("Chapter ", chapter_num, " 시작!")
    show_objectives()

func show_objectives():
    for obj in chapter_objectives[current_chapter]:
        print("목표:", obj)

func complete_objective(objective):
    if objective in chapter_objectives[current_chapter]:
        if objective not in chapter_completed[current_chapter]:
            chapter_completed[current_chapter].append(objective)
            print("목표 완료:", objective)
            check_chapter_clear()

func check_chapter_clear():
    if chapter_completed[current_chapter].size() == chapter_objectives[current_chapter].size():
        emit_signal("chapter_cleared", current_chapter)
        print("Chapter ", current_chapter, " 클리어!")
        current_chapter += 1
        if current_chapter <= 4:
            start_chapter(current_chapter)
        else:
            print("게임 전체 클리어!")

# 예시 함수들 (다른 스크립트에서 호출)
func on_npc_talked():
    if current_chapter == 1:
        complete_objective("마을 사람과 대화하기")

func on_first_portal_found():
    if current_chapter == 1:
        complete_objective("필드에서 첫 번째 포탈 찾기")

func on_ruins_investigated():
    if current_chapter == 2:
        complete_objective("신전 유적 조사하기")

func on_secret_ally_found():
    if current_chapter == 2:
        complete_objective("숨겨진 동료 발견하기")

func on_survivor_saved():
    if current_chapter == 3:
        complete_objective("피의 숲 생존자 구출하기")

func on_hidden_boss_defeated():
    if current_chapter == 3:
        complete_objective("숨겨진 보스 처치하기")

func on_final_area_entered():
    if current_chapter == 4:
        complete_objective("검은 심연 진입")

func on_final_boss_defeated():
    if current_chapter == 4:
        complete_objective("최종 보스 처치")