extends Control
@onready var msg : String
@onready var texteditor = $CanvasLayer/TextEditorHolder/LineEdit
@onready var msgholder = $CanvasLayer/MessagesHolder/ScrollContainer/PanelContainer/VBoxContainer
@onready var genchat = $CanvasLayer/ChannelHolder/VBoxContainer/GenChat
@onready var lb = $CanvasLayer/ChannelHolder/Leaderboard
@onready var announcements = $CanvasLayer/ChannelHolder/Announcements
@onready var chatfox = $CanvasLayer/DmsHolder/ExpFox
@onready var endermail = $CanvasLayer/DmsHolder/EnderMail
@onready var lvl10chat = $"CanvasLayer/ChannelHolder/VBoxContainer/10Chat"
@onready var lvl50chat = $"CanvasLayer/ChannelHolder/VBoxContainer/50Chat"
@onready var cyclopstrader = $CanvasLayer/DmsHolder/CyclopsTrader
@onready var channel_info = $CanvasLayer/MessagesHolder/ChannelInfo/RichTextLabel
@onready var settingsmenu = $CanvasLayer/ChannelHolder/Settings
var current_text :String
var cursor_line
var cursor_column
var exp_mult = 1
var fox_notif = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DisplayServer.window_set_size(Vector2i(1960,1080))
	genchat.pressed.connect(button_pressed)
	lb.pressed.connect(button_pressed)
	announcements.pressed.connect(button_pressed)
	lvl10chat.pressed.connect(button_pressed)
	lvl50chat.pressed.connect(button_pressed)
	Global.current_channel = 'general'
	load_channel(Global.general,genchat,Global.pkey['username'])
	$CanvasLayer/ChannelHolder/VBoxContainer/GenChat.set_pressed_no_signal(true)
	$CanvasLayer/TextEditorHolder/LineEdit.max_length = Global.pkey['char_limit']
	check_level_req()
	Global.leaderboard_sort()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Global.exp_req = 200 * Global.pkey['level']
	$CanvasLayer/WordCount.text = str(texteditor.text.length()) + '/' + str(Global.pkey['char_limit'])
	$CanvasLayer/MessagesHolder/Cyclopstrader/RichTextLabel.text = '[b]Emeralds:[/b]  ' + str(Global.pkey['emeralds'])
	if Global.pkey['exp'] >= Global.exp_req:
		level_up()
	
func level_up():
	Global.pkey['level'] += 1
	$CanvasLayer/DmsHolder/ExpFox/Notif.visible = true
	fox_notif += 1
	$CanvasLayer/DmsHolder/ExpFox/Notif.text = str(fox_notif)
	Global.exp_req = 200 * Global.pkey['level']
	check_level_req()
	
func check_level_req():
	if Global.pkey['level'] >= 10:
		lvl10chat.visible = true
		if Global.pkey['level'] >= 50: 
			lvl50chat.visible = true
		else:
			lvl50chat.visible = false
	else:
		lvl10chat.visible = false
		lvl50chat.visible = false
func _on_send_pressed() -> void:
	msg = texteditor.text
	if msg == '':
		$AnimationPlayer.play("MessageEmpty")
	else:
		if Global.pkey['username'] != '':
			Global.new_message(msg,Global.pkey['username'],msgholder,true,exp_mult)
		else:
			settingsmenu.button_pressed = true
			settings_open()
		texteditor.clear()
	if Global.pkey['exp'] >= Global.exp_req:
		level_up()
	#Global.lb_update()
	pass # Replace with function body.


func _on_text_edit_text_changed(_new_text:String) -> void:
	if texteditor.text.length() > Global.char_limit:
		texteditor.text = current_text
		# when replacing the text, the cursor will get moved to the beginning of the
		# text, so move it back to where it was 
		texteditor.set_caret_line(cursor_line)
		texteditor.set_caret_column(cursor_column)
		print('limit reached')
	current_text = texteditor.text
	# save current position of cursor for when we have reached the limit
	cursor_line = texteditor.get_caret_line()
	cursor_column = texteditor.get_caret_column()
	pass # Replace with function body.
	
func load_channel(ChannelMsgs:Array,Channel:Button,User:String):
	texteditor.max_length = Global.pkey['char_limit']
	if Channel.can_type == false:
		$CanvasLayer/TextEditorHolder.visible = false
		$CanvasLayer/SendButton.visible = false
		$CanvasLayer/WordCount.visible = false
	else:
		$CanvasLayer/TextEditorHolder.visible = true
		$CanvasLayer/SendButton.visible = true
		$CanvasLayer/WordCount.visible = true
	
	$CanvasLayer/MessagesHolder/Chatterfox.visible = false
	$CanvasLayer/MessagesHolder/Endermail.visible = false
	$CanvasLayer/MessagesHolder/Cyclopstrader.visible = false
	$CanvasLayer/MessagesHolder/Settings.visible = false
	var old_msgs: Array = msgholder.get_children()
	Global.set_channeldesc(channel_info,Channel)
	$CanvasLayer/MessagesHolder/ChannelInfo.visible = true
	for i in range(old_msgs.size()):
		old_msgs[i].queue_free()
	for i in range(ChannelMsgs.size()):
		Global.new_message(ChannelMsgs[i],User,msgholder,false,1)
	pass
func button_pressed():
	Global.leaderboard_sort()
	if Global.current_channel == 'general':
		exp_mult = 1
		load_channel(Global.general,genchat,Global.pkey['username'])
		lb.set_pressed_no_signal(false)
		announcements.set_pressed_no_signal(false)
		chatfox.set_pressed_no_signal(false)
		endermail.set_pressed_no_signal(false)
		cyclopstrader.set_pressed_no_signal(false)
		lvl10chat.set_pressed_no_signal(false)
		lvl50chat.set_pressed_no_signal(false)
		settingsmenu.set_pressed_no_signal(false)
	if Global.current_channel == 'leaderboard' :
		load_channel(Global.leaderboard,lb,'ChatterFox')
		genchat.set_pressed_no_signal(false)
		announcements.set_pressed_no_signal(false)
		chatfox.set_pressed_no_signal(false)
		endermail.set_pressed_no_signal(false)
		cyclopstrader.set_pressed_no_signal(false)
		lvl10chat.set_pressed_no_signal(false)
		lvl50chat.set_pressed_no_signal(false)
		settingsmenu.set_pressed_no_signal(false)
	if Global.current_channel =='announcements' :
		load_channel(Global.announcement,announcements,'Larpusk')
		genchat.set_pressed_no_signal(false)
		lb.set_pressed_no_signal(false)
		chatfox.set_pressed_no_signal(false)
		endermail.set_pressed_no_signal(false)
		cyclopstrader.set_pressed_no_signal(false)
		lvl10chat.set_pressed_no_signal(false)
		lvl50chat.set_pressed_no_signal(false)
		settingsmenu.set_pressed_no_signal(false)
	if Global.current_channel == 'endermail' :
		genchat.set_pressed_no_signal(false)
		lb.set_pressed_no_signal(false)
		announcements.set_pressed_no_signal(false)
		chatfox.set_pressed_no_signal(false)
		cyclopstrader.set_pressed_no_signal(false)
		lvl10chat.set_pressed_no_signal(false)
		lvl50chat.set_pressed_no_signal(false)
		settingsmenu.set_pressed_no_signal(false)
		endermaildms()
	if Global.current_channel == 'chatterfox':
		genchat.set_pressed_no_signal(false)
		lb.set_pressed_no_signal(false)
		announcements.set_pressed_no_signal(false)
		endermail.set_pressed_no_signal(false)
		cyclopstrader.set_pressed_no_signal(false)
		lvl10chat.set_pressed_no_signal(false)
		lvl50chat.set_pressed_no_signal(false)
		settingsmenu.set_pressed_no_signal(false)
		chatterfoxdms()
		pass
	if Global.current_channel == 'lvl10':
		genchat.set_pressed_no_signal(false)
		lb.set_pressed_no_signal(false)
		announcements.set_pressed_no_signal(false)
		endermail.set_pressed_no_signal(false)
		cyclopstrader.set_pressed_no_signal(false)
		chatfox.set_pressed_no_signal(false)
		lvl50chat.set_pressed_no_signal(false)
		settingsmenu.set_pressed_no_signal(false)
		exp_mult = 2
		load_channel(Global.lvl10,lvl10chat,Global.pkey['username'])
	if Global.current_channel == 'lvl50':
		genchat.set_pressed_no_signal(false)
		lb.set_pressed_no_signal(false)
		announcements.set_pressed_no_signal(false)
		endermail.set_pressed_no_signal(false)
		cyclopstrader.set_pressed_no_signal(false)
		chatfox.set_pressed_no_signal(false)
		lvl10chat.set_pressed_no_signal(false)
		settingsmenu.set_pressed_no_signal(false)
		exp_mult = 5
		load_channel(Global.lvl50,lvl50chat,Global.pkey['username'])
	if Global.current_channel == 'cyclopstrader':
		genchat.set_pressed_no_signal(false)
		lb.set_pressed_no_signal(false)
		announcements.set_pressed_no_signal(false)
		endermail.set_pressed_no_signal(false)
		cyclopstrader.set_pressed_no_signal(false)
		chatfox.set_pressed_no_signal(false)
		lvl10chat.set_pressed_no_signal(false)
		lvl50chat.set_pressed_no_signal(false)
		settingsmenu.set_pressed_no_signal(false)
		cyclopsdms()
	if Global.current_channel == 'settings':
		genchat.set_pressed_no_signal(false)
		lb.set_pressed_no_signal(false)
		announcements.set_pressed_no_signal(false)
		endermail.set_pressed_no_signal(false)
		cyclopstrader.set_pressed_no_signal(false)
		chatfox.set_pressed_no_signal(false)
		lvl10chat.set_pressed_no_signal(false)
		lvl50chat.set_pressed_no_signal(false)
		cyclopstrader.set_pressed_no_signal(false)
		settings_open()
func empty_channel():
	var old_msgs: Array = msgholder.get_children()
	$CanvasLayer/MessagesHolder/Chatterfox.visible = false
	$CanvasLayer/MessagesHolder/Endermail.visible = false
	$CanvasLayer/MessagesHolder/Cyclopstrader.visible = false
	$CanvasLayer/MessagesHolder/ChannelInfo.visible = false
	$CanvasLayer/WordCount.visible = false
	for i in range(old_msgs.size()):
		old_msgs[i].queue_free()
func _on_button_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.
func endermaildms():
	$CanvasLayer/TextEditorHolder.visible = false
	$CanvasLayer/SendButton.visible = false
	$CanvasLayer/MessagesHolder/Endermail/RichTextLabel.text = '[b]TOTAL WARNINGS:[/b]	' + str(Global.pkey['warnings'])
	empty_channel()
	$CanvasLayer/MessagesHolder/Endermail.visible = true
func chatterfoxdms():
	$CanvasLayer/TextEditorHolder.visible = false
	$CanvasLayer/SendButton.visible = false
	$CanvasLayer/MessagesHolder/Chatterfox/RichTextLabel.text = '[b]Level:[/b] ' + str(Global.pkey['level']) +'\n[b]Experience:[/b]	' + str(Global.pkey['exp'])  + ' / ' + str(Global.exp_req)
	$CanvasLayer/MessagesHolder/Chatterfox/TextureProgressBar.max_value = Global.exp_req
	$CanvasLayer/MessagesHolder/Chatterfox/TextureProgressBar.value = Global.pkey['exp']
	empty_channel()
	$CanvasLayer/DmsHolder/ExpFox/Notif.visible = false
	fox_notif = 0
	$CanvasLayer/DmsHolder/ExpFox/Notif.text = str(fox_notif)
	$CanvasLayer/MessagesHolder/Chatterfox.visible = true
func cyclopsdms():
	$CanvasLayer/TextEditorHolder.visible = false
	$CanvasLayer/SendButton.visible = false
	empty_channel()
	if Global.on_leaderboard() == true:
		$CanvasLayer/MessagesHolder/Cyclopstrader/VBoxContainer/UpgradeButton4.visible = true
	else:
		$CanvasLayer/MessagesHolder/Cyclopstrader/VBoxContainer/UpgradeButton4.visible = false
	$CanvasLayer/MessagesHolder/Cyclopstrader/RichTextLabel.text = '[b]Emeralds:[/b]  ' + str(Global.pkey['emeralds'])
	$CanvasLayer/MessagesHolder/Cyclopstrader.visible = true
func settings_open():
	$CanvasLayer/TextEditorHolder.visible = false
	$CanvasLayer/SendButton.visible = false
	empty_channel()
	$CanvasLayer/MessagesHolder/Settings.visible = true
func _on_save_pressed() -> void:
	Global._save()
	pass # Replace with function body.


func _on_timer_timeout() -> void:
	Global._save()
	Global.leaderboard_sort()
	
	pass # Replace with function body.


func _on_timer_2_timeout() -> void:
	Global.pkey['username'] = Global.username
	pass # Replace with function body.


func _on_username_entered() -> void:
	if $CanvasLayer/MessagesHolder/Settings/LineEdit.text == '':
		pass
	else:
		Global.pkey['username'] = $CanvasLayer/MessagesHolder/Settings/LineEdit.text
		Global._save()
	$CanvasLayer/MessagesHolder/Settings/LineEdit.clear()
	pass # Replace with function body.
