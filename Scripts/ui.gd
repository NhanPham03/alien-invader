extends MarginContainer


## References
@onready var shield_bar: TextureProgressBar = $HBoxContainer/ShieldBar
@onready var score_counter: HBoxContainer = $HBoxContainer/ScoreCounter


## User-defined functions
func update_score(value: float) -> void:
	score_counter.display_digits(value)

func update_shield(max_value: float, value: float) -> void:
	shield_bar.max_value = max_value
	shield_bar.value = value
