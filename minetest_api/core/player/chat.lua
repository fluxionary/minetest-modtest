local state = ...

function core.chat_send_all(message)
	for _, player in ipairs(core.get_connected_players()) do
		player:_receive_chat(message)
	end
end

function core.chat_send_player(name, message)
	local player = core.get_player_by_name(name)
	if player then
		player:_receive_chat(message)
	end
end
