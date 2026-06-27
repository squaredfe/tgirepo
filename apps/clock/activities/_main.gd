extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Fix ttitlebnar margins
	$TitleBar.position.y += SystemUIManager.StatusBarMargins
	$SmoothScrollContainer/Panel/MarginContainer.add_theme_constant_override("margin_top", SystemUIManager.StatusBarMargins + $TitleBar.size.y)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
