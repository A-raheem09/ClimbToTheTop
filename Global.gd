extends Node
var current_channel : String
var settings_button 
var username : String
var online_mods : int
var exp_req = 100
var pkey = {
	'level':1,
	'exp':0,
	'warnings':0,
	'emeralds':0,
	'username':'',
	'usernumber':0,
	'char_limit':300,
	'vip_mult':1
}
var shopupg = [
	0,
	0,
	0,
	0,
	0,
]
var general = [
	
]
var endermail = [
	
]
var usernames = [
	'Iforgor09',
	'Anonymous'
]
var leaderboard = [
	'1. dino_.d\n2. subtocizzel \n3. spidergabofficial\n4. eokpoke' 
]
var announcement = [
	'We have decided to stop developing the warden bot and the automod due to budget cuts','I am proud to announce that the top 5 players will receive the ability to purchase different tiers of VIP using emeralds!'
]
var lvl10 = [
	
]
var lvl50 = [
	
]
var Explb = [
	100000,50000,10000,5000,1000,0
]
var ExpUser = [
	'dino_.d','subtocizzel','spidergabofficial','eokpoke','forevereclyptical','Me'
]
const FILE_PATH = "user://MKSaveFile.json"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_load()
	pass # Replace with function body.
func new_message(Content:String,User:String, Parent:VBoxContainer,New:bool,XpMult:float):
	var msg = preload("res://message.tscn").instantiate()
	msg.message = Content
	msg.vip_color(pkey['vip_mult'])
	msg.user = User
	var username = pkey['username']
	match User:
		'Larpusk': msg.update_texture(load("res://Assets/Textures/User.png"))
		'ChatterFox': msg.update_texture(load("res://Assets/Textures/Fox.png"))
		username : msg.update_texture(load("res://Assets/Textures/User.png"))
	Parent.add_child(msg)
	if New == true:
		pkey['exp'] += 10 *	XpMult * pkey['vip_mult']
		pkey['emeralds'] += Content.length()
		leaderboard_sort()
		match current_channel:
			'general': general.append(Content)
			'leaderboard': leaderboard.append(Content)
			'announcements': announcement.append(Content)
			'lvl10' : lvl10.append(Content)
			'lvl50' : lvl50.append(Content)
func sort_members(Online:VBoxContainer,Offline:VBoxContainer):
	var online_members = Online.get_children()
	var offline_members = Offline.get_children()
	for i in range(online_members.size()):
		if online_members[i].online == false:
			Online.remove_child(online_members[i])
			Offline.add_child(online_members[i])
			print('online')
	for i in range(offline_members.size()):
		if offline_members[i].online == true:
			print('offline')
			if online_members[i].get_parent():
				Offline.remove_child(online_members[i])
			Online.add_child(offline_members[i])
	pass
func _save():
	var file : FileAccess = FileAccess.open(FILE_PATH, FileAccess.WRITE)
	file.store_var(pkey)
	file.store_var(shopupg)
	file.close()
func _load():
	if FileAccess.file_exists(FILE_PATH):
		var file : FileAccess = FileAccess.open(FILE_PATH, FileAccess.READ)
		var pkeys = file.get_var()
		for i in pkeys:
			pkey[i] = pkeys[i]
		var upg = file.get_var()
		for i in upg:
			shopupg[i] = upg[i]
		file.close()
func set_channeldesc(DescriptionHolder:RichTextLabel,Channel:Button):
	DescriptionHolder.text = '[b]Description:[/b]\n' + Channel.channel_description
func anon_mode(timer:Timer):
	timer.start(30)
	username = pkey['username']
	pkey['username'] = 'Anon'
func leaderboard_sort():
	var n = Explb.size()
	var playerindex = find_player()
	Explb[playerindex] = Global.pkey['exp']
	for i in range(n):
		for j in range(0,n-i-1):
			if Explb[j] < Explb[j+1]:
				var temp = Explb[j]
				var name_temp = ExpUser[j]
				Explb[j] = Explb[j+1]
				ExpUser[j] = ExpUser[j+1]
				Explb[j+1] = temp
				ExpUser[j+1] = name_temp
	leaderboard[0] = '1. '+ ExpUser[0] +' : '+str(int(Explb[0])) + ' experience points'+'\n2. ' + ExpUser[1] +' : '+str(int(Explb[1])) +' experience points'+ '\n3. ' + ExpUser[2] +' : '+str(int(Explb[2])) +' experience points'+'\n4. ' + ExpUser[3] + ' : '+str(int(Explb[3])) +' experience points'+'\n5. ' + ExpUser[4] + ' : '+str(int(Explb[4])) + ' experience points'
	pass
func find_player():
	var playerindex
	for i in range(ExpUser.size()):
		if ExpUser[i] == 'Me':
			playerindex = i
	return playerindex
func on_leaderboard():
	var pindex = find_player()
	if pindex <= 4:
		return true
	else:
		return false
