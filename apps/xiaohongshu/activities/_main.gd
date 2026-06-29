extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Control/TopBar.position.y += SystemUIManager.StatusBarMargins
	$Control/NavBar.position.y -= SystemUIManager.NavigationBarMargins
	
	var momos = DirAccess.open("user://apps/xiaohongshu/res/momos")
	for imagen in momos.get_files():
		if !imagen.ends_with(".import"):
			var imageIns = TextureRect.new()
			imageIns.set_anchors_preset(Control.PRESET_FULL_RECT)
			imageIns.texture = loadImg("user://apps/xiaohongshu/res/momos/" + str(imagen))
			imageIns.expand_mode = TextureRect.EXPAND_FIT_HEIGHT_PROPORTIONAL
			imageIns.size_flags_vertical = TextureRect.SIZE_EXPAND_FILL
			$Control/SmoothScrollContainer/MarginContainer/VBoxContainer.add_child(imageIns)
			
	$SplashScreen.show()
	await get_tree().create_timer(4).timeout
	$SplashScreen.hide()
	
func loadImg(path: String) -> Texture2D:
	var img = Image.new()
	var ic = img.load(path)
	if ic == OK:
		return ImageTexture.create_from_image(img)
	else:
		return null
