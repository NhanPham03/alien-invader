extends Area2D


## Variables
@export var speed: int = 250


## Built-in functions
func _process(delta: float) -> void:
	position.y -= speed * delta


## User-defined functions
func start(pos: Vector2) -> void:
	position = pos


## Signal-related functions
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemies"):
		area.explode()
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
