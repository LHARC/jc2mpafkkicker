-- * Anti AFK 0.2 * --
-- * Written by Lucas H. (Stoppered) Special thanks to jmaz * --
-- * Contact-me at webmaster@whispers.com.br --*/
-- * http://www.cshpforum.com * --


-- Conigure here
 
local players = {}
local oldtime = os.time()

-- Configure Here
 
MaxTime = 300 -- Put the seconds to player get alert and be kicked from the server

-- End the configuration


ApproachingKick =  math.floor(80/100*MaxTime)
message = (" was kicked for inactivity [AFK]") -- Console message and server Message
messagemove = ("[SERVER] Move or will be kicked for inactivity in ") -- Message sended to a player about [AFK]
 
local mainLoop = function()
 
        if os.time() - oldtime >= 1 then
 
                for k,v in pairs(players) do
                        local plr = Player.GetById(k)
 
                        if plr ~= nil then
                                --print(Player.GetById(k):GetName()..": "..v.idletime) -- For see in realtime counting player position AFK on console
                        end
                end
 
                for player in Server:GetPlayers() do
                        if players[player:GetId()] ~= nil then
                                if (players[player:GetId()].pos - player:GetPosition()):Length() < 0.1 then
                                        players[player:GetId()].idletime = players[player:GetId()].idletime + 1
                                else
                                        players[player:GetId()].idletime = 0
                                end
 
                                players[player:GetId()].pos = player:GetPosition()
                        end
                end
 
                for k,v in pairs(players) do
                        local plr = Player.GetById(k)
 
                        if plr ~= nil then
                                CountDown = MaxTime - v.idletime
 
                                if v.idletime >= ApproachingKick then
                                        Chat:Send(Player.GetById(k), messagemove ..CountDown.. " seconds", Color(255, 0, 4))
                                end
 
                                if CountDown <= 0 then
								        Chat:Broadcast("[SERVER] " ..Player.GetById(k):GetName().. message, Color(255, 0, 4))
										print(Player.GetById(k):GetName().. " Player was kicked [afk]")
                                       Player.GetById(k):Kick(message)
                                end
                        end
                end
 
 
        end
 
 
        oldtime = os.time()
 
end
 
function plrquit(args)
        table.remove(players, args.player:GetId())
end
function plrjoin(args)
        players[args.player:GetId()] = { pos = args.player:GetPosition(), idletime = 0 }
end
 
Events:Subscribe("PostTick", mainLoop)
Events:Subscribe("PlayerQuit", plrquit)
Events:Subscribe("PlayerJoin", plrjoin)
