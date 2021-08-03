extends Node

const CastleDB = preload("res://addons/thejustinwalsh.castledb/castledb_types.gd")

class Buildings:

	const lumberjack_house := "lumberjack_house"
	const mineworker_house := "mineworker_house"

	class BuildingsRow:
		var id := ""
		var scene := ""
		var image := ""
		var size_x := 0
		var size_y := 0
		var unit := ""
		
		func _init(id = "", scene = "", image = "", size_x = 0, size_y = 0, unit = ""):
			self.id = id
			self.scene = scene
			self.image = image
			self.size_x = size_x
			self.size_y = size_y
			self.unit = unit
	
	var all = [BuildingsRow.new(lumberjack_house, "Buildings/Deploy Buildings/Worker Buildings/WorkerBuilding.tscn", "Art/Buildings/Lumberjack House.pxo", 3, 1, "Characters/Workers/Lumberjack/Lumberjack.tscn"), BuildingsRow.new(mineworker_house, "Buildings/Deploy Buildings/Worker Buildings/WorkerBuilding.tscn", "Art/Buildings/Mineworker House.pxo", 2, 1, "Characters/Workers/Mineworker/Mineworker.tscn")]
	var index = {lumberjack_house: 0, mineworker_house: 1}
	
	func get(id:String) -> BuildingsRow:
		if index.has(id):
			return all[index[id]]
		return null

	func get_index(idx:int) -> BuildingsRow:
		if idx < all.size():
			return all[idx]
		return null

var buildings := Buildings.new()
