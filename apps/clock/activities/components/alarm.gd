extends PanelContainer
var enabledAlarm = false
var tween: Tween
var timeAlarm = "00:00"
signal alarmToggled
signal alarmUntoggled
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HBoxContainer/Control/Toggle._toggle.connect(toggleAlarm)
	$HBoxContainer/Control/Toggle._untoggle.connect(untoggleAlarm)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$HBoxContainer/VBoxContainer2/MarginContainer/VBoxContainer2/VBoxContainer/Time.text = timeAlarm
	
func toggleAlarm():
	enabledAlarm = $HBoxContainer/Control/Toggle.toggled 
	alarmToggled.emit()
	if tween: 
		tween.kill()
	tween = self.create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT).set_parallel()
	tween.tween_property(self, "self_modulate:a", 1.0, 0.4)
	$HBoxContainer/VBoxContainer2/MarginContainer/VBoxContainer2/VBoxContainer/State.text = "Sonara en {}"
	tween.tween_property($HBoxContainer/VBoxContainer2/MarginContainer/VBoxContainer2/VBoxContainer, "modulate:a", 1.0, 0.4)
func untoggleAlarm():
	enabledAlarm = $HBoxContainer/Control/Toggle.toggled 
	alarmUntoggled.emit()
	if tween: 
		tween.kill()
	tween = self.create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT).set_parallel()
	tween.tween_property(self, "self_modulate:a", 0.3, 0.4)
	tween.tween_property($HBoxContainer/VBoxContainer2/MarginContainer/VBoxContainer2/VBoxContainer, "modulate:a", 0.7, 0.4)
	$HBoxContainer/VBoxContainer2/MarginContainer/VBoxContainer2/VBoxContainer/State.text = "Desactivado"
