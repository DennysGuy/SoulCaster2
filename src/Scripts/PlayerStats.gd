extends Node

var player_stats : Dictionary = {
	"Level": 1.0,
	"Current XP": 0.0,
	"Needed XP": 50.0,
	"Attack Speed": 1.0, # influences the speed of weapon firing animation
	"Attack Damage": 7.0,
	"Movement Speed": 5.0, #speed at which the camera shifts to a new side
	"Crit Chance": 0.0,
	"Crit Damage": 1.5,
	"Starting Timer": 45,
	"Defense": 0.0, #reduces the time taken off when taking damage
	"Ore Spawn Time": 7,
	"Reload Speed": 1.0, # influences the speed of reload animation
	"Ability Points": 0.0,
	"Currency": 0.0,
	"Ore": 0.0,
	"Progress Speed": 0.0,
	"Life Steal": 1.0,
	"AP Amount": 1.0,
	"XP Bonus": 1.0
}

var stat_levels : Dictionary = {
	"Attack Damage": {"Level": 0, "Max Level": 10, "Interval": 3, "Cost":1}, 
	"Attack Speed": {"Level": 0, "Max Level": 10, "Interval": 0.1, "Cost":1},
	"Movement Speed": {"Level": 0, "Max Level": 5, "Interval": 1.0, "Cost":1},
	"Crit Chance": {"Level": 0, "Max Level": 15, "Interval": 0.12, "Cost":1},
	"Crit Damage": {"Level": 0, "Max Level": 15, "Interval": 0.5, "Cost":1},
	"Starting Timer": {"Level": 0, "Max Level": 5, "Interval": 10, "Cost":1},
	"Defense": {"Level": 0, "Max Level": 5, "Interval": 0.1, "Cost":1},
	"Ore Spawn Time": {"Level": 0, "Max Level": 3, "Interval": 0.1, "Cost":1},
	"Reload Speed": {"Level": 0, "Max Level": 5, "Interval": 0.2, "Cost":1},
	"Progress Speed" : {"Level": 0, "Max Level": 3, "Interval": 1, "Cost":1},
	"AP Amount" : {"Level": 0, "Max Level": 2, "Interval": 1, "Cost":1},
	"XP Bonus":  {"Level": 0, "Max Level": 3, "Interval": 0.5, "Cost":1},
	"Life Steal":  {"Level": 0, "Max Level": 2, "Interval": 1.0, "Cost":1},
}
