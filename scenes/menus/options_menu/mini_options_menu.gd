extends MiniOptionsMenu


func _on_flashing_control_setting_changed(value):
	Config.set_config(&'VideoSettings', 'DISABLE_FLASHING', value);
	Looper.flashy = !value;
