extends Node

var player_stats : Dictionary = {
	"Level": 1.0,
	"Current XP": 0.0,
	"Needed XP": 50.0,
	"Attack Speed": 1.0, # influences the speed of weapon firing animation
	"Attack Damage": 5.0,
	"Movement Speed": 5.0, #speed at which the camera shifts to a new side
	"Crit Chance": 0.0,
	"Crit Damage": 1.5,
	"Starting Timer": 45,
	"Defense": 0.0, #reduces the time taken off when taking damage
	"Ore Spawn Time": 10,
	"Reload Speed": 1.0, # influences the speed of reload animation
	"Ability Points": 0.0,
	"Currency": 0.0,
	"Ore": 0.0
}

var stat_levels : Dictionary = {
	"Attack Damage": {"Level": 0, "Max Level": 20, "Interval": 2}, 
	"Attack Speed": {"Level": 0, "Max Level": 10, "Interval": 0.1},
	"Movement Speed": {"Level": 0, "Max Level": 5, "Interval": 1.0},
	"Crit Chance": {"Level": 0, "Max Level": 15, "Interval": 0.12},
	"Crit Damage": {"Level": 0, "Max Level": 15, "Interval": 0.5},
	"Starting Timer": {"Level": 0, "Max Level": 5, "Interval": 10},
	"Defense": {"Level": 0, "Max Level": 5, "Interval": 0.1},
	"Ore Spawn Time": {"Level": 0, "Max Level": 5, "Interval": 0.1},
	"Reload Speed": {"Level": 0, "Max Level": 10, "Interval": 0.1},
}
