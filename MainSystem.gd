extends Spatial


const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db
var db_name = "res://DataStore/database"
export(Texture) var texture

# Called when the node enters the scene tree for the first time.
func _ready():
	db = SQLite.new()
	db.path = db_name
	#saveTextureToDB(texture)
	#var itemResult = getItemsByUserID(1)
	#LoadImageFromDB()
	saveImageTo("C:/temp/test.png", texture)
	loadImagePathFromDB()
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

func saveTextureToDB(texture):
	var img = texture.get_data()
	var idata = {"Width": img.get_width(),
	"Height": img.get_height(),
	"Format": img.get_format()}
	var ibytes = img.get_data()
	var bytes = ""
	for i in range(ibytes.size()):
		if(i == 0):
			bytes = str(ibytes[i])
		else:
			bytes = bytes + ',' + str(ibytes[i])
	idata["Data"] = bytes
	
	db.open_db()
	db.insert_row("Images",idata)

func LoadImageFromDB():
	db.open_db()
	db.query("select * from Images")
	for i in range(0, db.query_result.size()):
		var width = db.query_result[i]["Width"]
		var height = db.query_result[i]["Height"]
		var format = db.query_result[i]["Format"]
		var data = db.query_result[i]["Data"]
		var dataArray = Array(data.split(','))
		var pba = PoolByteArray(dataArray)
		
		var img = Image.new()
		img.create_from_data(width, height, false, format, pba)
		var texture = ImageTexture.new()
		texture.create_from_image(img,0)
		get_node("TextureRect").texture = texture

func saveImageTo(path, texture):
	var img = texture.get_data()
	img.save_png(path)
	commitImagePathToDB(path)

func loadImage(path):
	var image = Image.new()
	image.load(path)
	var text = ImageTexture.new()
	text.create_from_image(image,0)
	get_node("TextureRect").texture = text

func commitImagePathToDB(path):
	var idata = {"Data": path}
	db.open_db()
	db.insert_row("Images",idata)

func loadImagePathFromDB():
	db.open_db()
	db.query("select * from Images")
	for i in range(0, db.query_result.size()):
		var width = db.query_result[i]["Width"]
		var height = db.query_result[i]["Height"]
		var format = db.query_result[i]["Format"]
		var data = db.query_result[i]["Data"]
		loadImage(data)	
