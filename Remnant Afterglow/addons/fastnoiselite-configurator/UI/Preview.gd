extends TextureRect


	
func drawFromSettings(settings: Settings):
	var noise = FastNoiseLite.new()
	var noise_parameters = settings.get_noise_parameters()
	Save(noise_parameters,settings.noise.size)##保存数据
	for key in noise_parameters: noise.set(key, noise_parameters[key])
	texture = NoiseTexture2D.new()
	texture.height = settings.noise.size.y
	texture.width = settings.noise.size.x
	texture.noise = noise
	await texture.changed

func Save(noise_parameters,Size):
	var config = ConfigFile.new()
	# 迭代所有小节。
	for key in noise_parameters:
		# 获取每个小节的数据。
		config.set_value("Setting", key, noise_parameters[key])
	config.set_value("Param", "SizeX", Size.x)
	config.set_value("Param", "SizeY", Size.y)
	
	config.save("./data/tool_noise_setting.cfg")





	
	
