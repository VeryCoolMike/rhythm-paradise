extends Button

func _on_pressed() -> void:
    JavaScriptBridge.eval("window.open('https://github.com/VeryCoolMike/rhythm-paradise/releases/download/build/rhythm_paradise.zip', '_blank');")
