-- * Anti AFK 0.1 * --
-- * Written by Lucas H. (Stoppered) Special thanks to jmaz * --
-- * Contact-me at webmaster@whispers.com.br --*/
-- * http://www.cshpforum.com * --


-- Conigure here

MaxTime = 15 -- Max time without move to get afk and be kicked in seconds (300 Seconds = 5 Minutes)


-- End the configure 

players = {}
oldtime = os.time()
ApproachingKick =  math.floor(80/100*MaxTime)
RemainderTime = math.floor(20/100*MaxTime)

message = (" was kicked for inactivity [AFK]")
messagemove = ("[SERVER] Move or will be kicked for inactivity in ")




mainLoop = function()

	if os.time() - oldtime >= 1 then 
		for player in Server:GetPlayers() do
			if players[player:GetId()] == nil then
				players[player:GetId()] = { pos = player:GetPosition(), idletime = 0 }
			else
				if (players[player:GetId()].pos - player:GetPosition()):Length() < 0.1 then
					players[player:GetId()].idletime = players[player:GetId()].idletime + 1
				else
					players[player:GetId()].idletime = 0
				end

				players[player:GetId()].pos = player:GetPosition()
			end
		end

		for k,v in pairs(players) do
			for player in Server:GetPlayers() do
		CountDown = MaxTime - v.idletime
		
		 if v.idletime >= ApproachingKick then
		 Chat:Send(player, messagemove ..CountDown.. " segunds", Color(255, 0, 4))
		 end 
		 
			if v.idletime >= MaxTime then
		    Chat:Broadcast("[Server] " .. player:GetName() .. message, Color(255, 0, 4))
			print(player:GetName() .. message)
			player:Kick(message) 
			players[player:GetId()].idletime = 0

			end
		end
	end
	end

	oldtime = os.time()

end
Events:Subscribe("PostTick", mainLoop)
