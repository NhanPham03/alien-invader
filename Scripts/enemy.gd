extends Area2D


## Signals
signal died


## Global variables
@onready var screensize: Vector2 = get_viewport_rect().size


## References
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var move_timer: Timer = $MoveTimer
@onready var shoot_timer: Timer = $ShootTimer

var bullet: PackedScene = preload("res://Scenes/enemy_bullet.tscn")


## Variables
var start_pos: Vector2 = Vector2.ZERO
var speed: int = 0


## Built-in functions
func _process(delta: float) -> void:
	position.y += speed * delta
	if position.y > screensize.y + 32:
		start(start_pos)


## User-defined functions
func start(pos: Vector2) -> void:
	speed = 0
	position = Vector2(pos.x, -pos.y)
	start_pos = pos
	
	await get_tree().create_timer(randf_range(0.25, 0.55)).timeout
	
	var tween: Tween = create_tween().set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "position:y", start_pos.y, 1.4)
	await tween.finished
	
	move_timer.wait_time = randf_range(5, 20)
	move_timer.start()
	
	shoot_timer.wait_time = randf_range(4, 20)
	shoot_timer.start()

func explode() -> void:
	speed = 0
	animation_player.play("explode")
	set_deferred("monitoring", false)
	died.emit(5)
	await animation_player.animation_finished
	queue_free()


## Signal-related functions
func _on_move_timer_timeout() -> void:
	speed = randi_range(75, 100)

func _on_shoot_timer_timeout() -> void:
	var new_bullet = bullet.instantiate()
	get_tree().root.add_child(new_bullet)
	new_bullet.start(position)
	
	shoot_timer.wait_time = randf_range(4, 20)
	shoot_timer.start()
