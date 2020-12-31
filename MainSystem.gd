extends Spatial


const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db
var db_name = "res://DataStore/database"

# Called when the node enters the scene tree for the first time.
func _ready():
	db = SQLite.new()
	db.path = db_name
	var itemResult = getItemsByUserID(1)
	pass # Replace with function body.

func commitDataToDB():
	db.open_db()
	var tableName = "PlayerInfo"
	var dict : Dictionary = Dictionary()
	dict["Name"] = "this is a test user"
	dict["Score"] = 5000
	
	db.insert_row(tableName,dict)

func readFromDB():	
	db.open_db()
	var tableName = "PlayerInfo"
	db.query("select * from " + tableName + ";")
	for i in range(0, db.query_result.size()):
		print("Qurey results ", db.query_result[i]["Name"], db.query_result[i]["Score"])

func getItemsByUserID(id):
	db.open_db()
	db.query("select playerinfo.name as pname, iteminventory.name as iname from playerinfo left join ItemInventory on playerinfo.ID = ItemInventory.PlayerID where playerinfo.id = " + str(id))
	for i in range(0, db.query_result.size()):
		print("Qurey results ", db.query_result[i]["pname"], db.query_result[i]["iname"])
	return db.query_result
