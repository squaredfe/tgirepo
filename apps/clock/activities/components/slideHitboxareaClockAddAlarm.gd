extends Panel
var is_dragging
var drag_start_position
var lastDelta
var containerAddAlarm
var application
func _ready() -> void:
	containerAddAlarm = get_parent()
	application = get_parent().get_parent().get_parent()
func _gui_input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			is_dragging = true
			drag_start_position = event.position
			print("Toque inicial en: ", drag_start_position)
		else:
			is_dragging = false
			print("El dedo se levantó. Posición final: ", event.position, "pos: ", get_viewport_rect().size.y)
			
			print("Ha sido desbloqueado wuju!!")
			if get_viewport_rect().size.y / 2 <= containerAddAlarm.position.y:
				application.hideAlarmUI()
			else:
				application.showAlarmUI(true)

	elif event is InputEventScreenDrag and is_dragging:
		lastDelta = event.relative.y
		print("Arrastrando en Y. Delta actual: ", event.relative.y)
		if !containerAddAlarm.position.y < get_viewport_rect().size.y - containerAddAlarm.size.y:
			containerAddAlarm.position.y += event.relative.y
