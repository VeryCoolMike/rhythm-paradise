extends Node2D

var save = {
    "rank_1_1" = 99,
    "rank_1_2" = 99,
    "rank_1_3" = 99,
    "rank_1_4" = 99,
    "unlocked_1" = false,
    "rank_2_1" = 99,
    "rank_2_2" = 99,
    "rank_2_3" = 99,
    "rank_2_4" = 99,
    "unlocked_2" = false,
    "rank_3_1" = 99,
    "rank_3_2" = 99,
    "rank_3_3" = 99,
    "rank_3_4" = 99,
    "unlocked_3" = false,

    "scroll_speed" = 800,
    "performance_mode" = false
}

var original_save = {
    "rank_1_1" = 99,
    "rank_1_2" = 99,
    "rank_1_3" = 99,
    "rank_1_4" = 99,
    "unlocked_1" = false,
    "rank_2_1" = 99,
    "rank_2_2" = 99,
    "rank_2_3" = 99,
    "rank_2_4" = 99,
    "unlocked_2" = false,
    "rank_3_1" = 99,
    "rank_3_2" = 99,
    "rank_3_3" = 99,
    "rank_3_4" = 99,
    "unlocked_3" = false,

    "scroll_speed" = 800,
    "performance_mode" = false,
}

var cheat = false
var latest_rank = -1
var latest_accuracy = -1.00

var level_editing = false

var latest_json_raw
var latest_song