extends Control
var tween: Tween
var tab = 0
var alarms = []
var enabledAlarms = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Fix ttitlebnar margins
	$TitleBar/HBoxContainer/MarginRightButton/AddAlarm/hitbox.pressed.connect(showAlarmUI)
	$AddAlarmUI/AlarmAddUI/Close/hitbox.pressed.connect(hideAlarmUI)
	var topMargin = SystemUIManager.StatusBarMargins + $TitleBar.size.y
	$TitleBar.position.y += SystemUIManager.StatusBarMargins
	$AlarmTab/Panel/MarginContainer.add_theme_constant_override("margin_top", topMargin)
	$NavBar.position.y -= SystemUIManager.NavigationBarMargins
	$AddAlarmUI.visible = false
	for alarm in $AlarmTab/Panel/MarginContainer/VBoxContainer.get_children():
		if alarm is PanelContainer:
			alarm.alarmToggled.connect(verifyAlarm)
			alarm.alarmUntoggled.connect(verifyAlarm)
	$AddAlarmUI/AlarmAddUI/Check/hitbox.pressed.connect(createAlarm)
func verifyAlarm():
	var currentTime = Time.get_datetime_dict_from_system()
	for alarm in $AlarmTab/Panel/MarginContainer/VBoxContainer.get_children():
		if alarm is PanelContainer and alarm.enabledAlarm == true:
			var alarmSplitted = alarm.timeAlarm.split(":")
			if alarmSplitted.size() == 2:
				print("Enabled alarm at: " + str(alarm.timeAlarm))
				if !enabledAlarms.has(alarm.timeAlarm):
					enabledAlarms.append(alarm.timeAlarm)
					alarms.erase(alarm.timeAlarm)
		elif alarm is PanelContainer and alarm.enabledAlarm == false:
			if enabledAlarms.has(alarm.timeAlarm):
				enabledAlarms.erase(alarm.timeAlarm)
				alarms.append(alarm.timeAlarm)
func createAlarm():
	if not alarms.has(str($AddAlarmUI/AlarmAddUI/VBoxContainer/Panel/LineEdit.text)) and not enabledAlarms.has(str($AddAlarmUI/AlarmAddUI/VBoxContainer/Panel/LineEdit.text)):
		var alarmTemplate = load("user://apps/clock/activities/components/alarm.tscn")
		if !alarmTemplate:
			#fallback
			alarmTemplate = load("res://apps/clock/activities/components/alarm.tscn")
		var alarmInst = alarmTemplate.instantiate()
		var alarmHour = $AddAlarmUI/AlarmAddUI/VBoxContainer/Panel/LineEdit.text
		alarmInst.alarmToggled.connect(verifyAlarm)
		alarmInst.alarmUntoggled.connect(verifyAlarm)
		alarmInst.timeAlarm = alarmHour
		alarms.append(alarmInst.timeAlarm)
		alarmInst.get_node("HBoxContainer").get_node("Control").get_node("Toggle").toggled = true
		$AlarmTab/Panel/MarginContainer/VBoxContainer.add_child(alarmInst)
		hideAlarmUI()
	else:
		if tween:
			tween.kill()
		tween = self.create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT).set_parallel()
		$AddAlarmUI/AlarmAddUI/VBoxContainer/Panel.pivot_offset = $AddAlarmUI/AlarmAddUI/VBoxContainer/Panel.size / 2
		SystemUIManager.showToast("Esta alarma ya existe.")
		tween.tween_property($AddAlarmUI/AlarmAddUI/VBoxContainer/Panel, "scale", Vector2(1.1,1.1), 0.2)
		tween.tween_property($AddAlarmUI/AlarmAddUI/VBoxContainer/Panel, "scale", Vector2(1.0,1.0), 0.2).set_delay(0.2)
func showAlarmUI(fromSliding:= false):
	var hour = Timedatectl.time.get("hour", 0)
	var minute = Timedatectl.time.get("minute", 0)
	if tween:
		tween.kill()
	tween = self.create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT).set_parallel()
	if !fromSliding:
		$AddAlarmUI.visible = true
		$AddAlarmUI/AlarmAddUI.position.y = get_viewport_rect().size.y
		$AddAlarmUI/bg.modulate.a = 0
		$AddAlarmUI/AlarmAddUI/VBoxContainer/Panel/LineEdit.text = "%02d:%02d" % [hour, minute]

	tween.tween_property($AddAlarmUI/AlarmAddUI, "position:y", get_viewport_rect().size.y - $AddAlarmUI/AlarmAddUI.size.y, 0.5)
	tween.tween_property($AddAlarmUI/bg, "modulate:a", 0.8, 0.5)

func hideAlarmUI():
	if tween:
		tween.kill()
	tween = self.create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT).set_parallel()
	tween.tween_property($AddAlarmUI/AlarmAddUI, "position:y", get_viewport_rect().size.y, 0.5)
	tween.tween_property($AddAlarmUI/bg, "modulate:a", 0.0, 0.5)
	await tween.finished
	$AddAlarmUI.visible = false
