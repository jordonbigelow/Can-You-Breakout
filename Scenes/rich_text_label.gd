extends RichTextLabel

var high_score_string: String

func _ready() -> void:
	high_score_string = "HIGH SCORE: " + str(Global.player_high_score)
	text = high_score_string
