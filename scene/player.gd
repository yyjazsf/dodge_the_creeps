extends Area2D

signal hit

@export var speed = 400 # How fast the player will move (pixels/sec).
var level = 1
var screen_size # Size of the game window.
var sprite_size # Size of the player sprite.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	# 获取当前动画帧的纹理尺寸
	var texture = $AnimatedSprite2D.sprite_frames.get_frame_texture("walk", 0)
	sprite_size = texture.get_size()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	position += velocity * delta
	position.x = clamp(position.x, sprite_size.x / 2 - 20, screen_size.x - sprite_size.x / 2 + 20)
	position.y = clamp(position.y, sprite_size.y / 2 - 30, screen_size.y - sprite_size.y / 2 + 30)
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		# 水平翻转
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		# 垂直翻转
		$AnimatedSprite2D.flip_v = velocity.y > 0


func _on_body_entered(body: Node2D) -> void:
	hide()
	hit.emit()
	# 等待可以安全地禁用碰撞
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
