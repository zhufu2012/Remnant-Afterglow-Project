extends Node


const APP_ID = 3195180

var is_ready = false
var is_online = false
var is_owned = false
var steam_id: int
var steam_username: String


func  _ready() -> void:
	init_steam()


func init_steam():
	if Engine.has_singleton("Steam") and APP_ID > 0:
		var init_response: Dictionary = Steam.steamInitEx(APP_ID, true)
		print("steaminitialization:%s" %init_response)
		if init_response['status']>0:
			print("Failed to initialize Steam, shutting down:%s" % init_response)
			get_tree().quit()
			is_ready = false
			return
		is_online = Steam.loggedOn()
		is_owned = Steam.isSubscribed()
		steam_id = Steam.getSteamID()
		steam_username = Steam.getPersonaName()
		print("Is Steam online:%s" % is_online)
		print("Is game owned:%s" % is_owned)
		print("Steam ID:%s" % steam_id)
		print("Steam Username:%s" % steam_username)
		is_ready = is_online and is_owned
	else:
		steam_id = 0
		is_ready = false
		print("您的电子设备steam没有登陆")
		
func _process(_delta: float)->void:
	if is_ready:
		Steam.run_callbacks()
		
		
		
func copy_file_to_steam(local_file_name: String,steam_file_name: String):
	if is_ready:
		Steam.beginFileWriteBatch()
		if FileAccess.file_exists(local_file_name):
			var data= FileAccess.get_file_as_bytes(local_file_name)
			if Steam.fileWrite(steam_file_name, data, data.size()):
				print("File %s saved to the Steam Cloud." % steam_file_name)
			else:
				print("Unable to write Steam files %s." % steam_file_name)
		else:
			print("Unable to find local file %s." % local_file_name)
		Steam.endFileWriteBatch()


func copy_file_from_steam(steam_file_name:String,local_file_name:String):
	if is_ready:
		if fise_exists(steam_file_name):
			var file_size = Steam.getFileSize(steam_file_name)
			var result =Steam.fileRead(steam_file_name,file_size)
			if result.ret:
				var data= result.buf
				var file =FileAccess.open(local_file_name,FileAccess.WRITE)
				file.store_buffer(data)
				file.close()
			else:
				print("Unable to read Steam file %s."% steam_file_name)
		else:
			print("Unable to find Steam file %s."% steam_file_name)


func fise_exists(Steam_file_name: String):
	return is_ready and Steam.fileExists(Steam_file_name)


func delete_file_from_steam(steam_file_name:String):
	if is_ready and fise_exists(steam_file_name):
		Steam.fileDelete(steam_file_name)
