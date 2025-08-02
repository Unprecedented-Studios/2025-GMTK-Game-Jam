extends PauseMenu

func _on_confirm_main_menu_confirmed() -> void:
	Looper.reset_music();
	super()
