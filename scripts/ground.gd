extends Node2D


## 地面滚动速度
@export var scroll_speed: float = 150.0

var _sprite1: Sprite2D
var _sprite2: Sprite2D
var _sprite_width: float


func _ready() -> void:
	_sprite1 = $Sprite1
	_sprite2 = $Sprite2
	_sprite_width = _sprite1.texture.get_width()

	# 初始化拼接：Sprite2 紧贴在 Sprite1 右侧
	_sprite2.position.x = _sprite_width


func _process(delta: float) -> void:
	var offset = scroll_speed * delta

	_sprite1.position.x -= offset
	_sprite2.position.x -= offset

	# 当 Sprite1 完全移出屏幕左侧，重置到右侧
	if _sprite1.position.x <= -_sprite_width:
		_sprite1.position.x += _sprite_width * 2.0

	# 当 Sprite2 完全移出屏幕左侧，重置到右侧
	if _sprite2.position.x <= -_sprite_width:
		_sprite2.position.x += _sprite_width * 2.0
