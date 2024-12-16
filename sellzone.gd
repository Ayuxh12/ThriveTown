extends StaticBody2D



func _on_Area2D_body_entered(body: Node2D) -> void:
	if body.has_method("player_sell_method"):
		print("selling...")
