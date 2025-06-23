extends Node

var actions: Dictionary[String,InputStatus]
@onready var input_action_names: Array[StringName] = InputMap.get_actions()

class InputStatusInfo:
	var strength: float
class InputStatus:
	var devices: Dictionary[int, InputStatusInfo]

func _ready() -> void:
	for i in input_action_names:
		actions[i] = InputStatus.new()
		for j in Input.get_connected_joypads().size() + 2:
			actions[i].devices[j] = InputStatusInfo.new()

func _input(event: InputEvent) -> void:
	for i in input_action_names:
		if event.is_action(i):
			if event is InputEventKey:
				actions[i].devices[0].strength = event.get_action_strength(i)
			else:
				actions[i].devices[event.device + 1].strength = event.get_action_strength(i)

func is_action_pressed(action: String, device: int) -> bool:
	return actions[action].devices[device].strength > 0
func get_axis(negative: String, positive: String, device: int) -> float:
	return actions[positive].devices[device].strength - actions[negative].devices[device].strength
