extends Node2D

func secret_unlocked_check() -> bool:
    if GlobalData.level_1_rank == 0 and GlobalData.level_2_rank == 0:
        return true
    else:
        return false

func accuracy_to_rank(accuracy: int) -> String:
    match accuracy:
        0:
            return "[P]"
        1:
            return "[S]"
        2:
            return "[A]"
        3:
            return "[B]"
        4:
            return "[C]"
        5:
            return "[D]"
        _:
            return "[-]"

func _ready() -> void:
    if secret_unlocked_check():
        GlobalData.secret_level_unlocked = true
    else:
        GlobalData.secret_level_unlocked = false
    
    if GlobalData.secret_level_unlocked == true:
        $Button3.text = "secret level\n(unlocked)"
    else:
        $Button3.text = "secret level\n(locked)"

    $level_1.text = accuracy_to_rank(GlobalData.level_1_rank)
    $level_2.text = accuracy_to_rank(GlobalData.level_2_rank)
    $secret_level.text = accuracy_to_rank(GlobalData.secret_level_rank)