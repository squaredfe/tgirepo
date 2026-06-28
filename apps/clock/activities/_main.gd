extends Control
var tween: Tween
var tab = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Fix ttitlebnar margins
	$TitleBar/HBoxContainer/MarginRightButton/AddAlarm/hitbox.pressed.connect(showAlarmUI)
	$AddAlarmUI/AlarmAddUI/Close/hitbox.pressed.connect(hideAlarmUI)
	var topMargin = SystemUIManager.StatusBarMargins + $TitleBar.size.y
	$TitleBar.position.y += SystemUIManager.StatusBarMargins
	$AlarmTab/Panel/MarginContainer.add_theme_constant_override("margin_top", topMargin)
	$NavBar.position.y -= SystemUIManager.NavigationBarMargins


func showAlarmUI(fromSliding:= false):
	
	if tween:
		tween.kill()
	tween = self.create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT).set_parallel()
	if !fromSliding:
		$AddAlarmUI.visible = true
		$AddAlarmUI/AlarmAddUI.position.y = get_viewport_rect().size.y
		$AddAlarmUI/bg.modulate.a = 0
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
