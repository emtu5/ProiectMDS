extends ProgressBar

var parent_node

func _ready():
	parent_node = get_parent()
	update_health_bar()


func update_health_bar():
	var health_percentage = parent_node.health / parent_node.MAX_HEALTH
	set_value(health_percentage * 100)
