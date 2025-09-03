extends CheckBox



func _on_toggled(toggled_on:bool) -> void:
    if toggled_on == true:
        GlobalData.save["performance_mode"] = true
    else:
        GlobalData.save["performance_mode"] = false