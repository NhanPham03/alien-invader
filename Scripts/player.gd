extends Area2D


## Signals
signal died
signal shield_changed(max_shield, shield)


## Global variables
@onready var screensize: Vector2 = get_viewport_rect().size


## References
@onready var ship: Sprite2D = $Ship
@onready var boosters: AnimatedSprite2D = $Ship/Boosters
@onready var gun_cooldown: Timer = $GunCooldown


## Variables
@export var speed: int = 150
@export var cooldown: float = 0.25
@export var bullet_scene: PackedScene
@export var max_shield: float = 10.0

var can_shoot: bool = true
var shield: float = max_shield:
	set = set_shield


## Built-in functions
func _ready() -> void:
	start()

func _input(_event: InputEvent) -> void:
	if Input.is_action_pressed("shoot"):
		shoot()

func _process(delta: float) -> void:
	# Movement handling
	var input = Input.get_vector("left", "right", "up", "down")
	if input.x > 0:
		ship.frame = 2
		boosters.animation = "right"
	elif input.x < 0:
		ship.frame = 0
		boosters.animation = "left"
	else:
		ship.frame = 1
		boosters.animation = "forward"
	
	# Applying movement
	position += input * speed * delta
	position = position.clamp(Vector2(8, 8), screensize - Vector2(8, 8))


## User-defined functions
func set_shield(value: float) -> void:
	shield = min(max_shield, value)
	shield_changed.emit(max_shield, shield)
	if shield <= 0:
		hide()
		died.emit()

func start() -> void:	# Things to run when player is created
	position = Vector2(screensize.x / 2, screensize.y - 64)
	gun_cooldown.wait_time = cooldown

func shoot() -> void:	# Shoot, duh
	if not can_shoot:
		return
	can_shoot = false
	gun_cooldown.start()
	
	var new_bullet = bullet_scene.instantiate()
	get_tree().root.add_child(new_bullet)
	new_bullet.start(position + Vector2(0, -8))


## Signal-related functions
func _on_gun_cooldown_timeout() -> void:
	can_shoot = true

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemies"):
		area.explode()
		shield -= max_shield / 2
