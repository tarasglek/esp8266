--[[
pingonpower = require "pingonpower";pingonpower.ping("/mail")
file.open("init.lua","w");file.write("");file.close();
tmr.stop(0)
./nodemcu-uploader.py --port /dev/ttyAMA0 upload pingonpower.lua init.lua && python at.py 'node.restart()'

]]

local pingonpower = {}

gTag = nil
gHost = nil
gCount = 0;
conn = nil

function handleResponse(conn, payload)
    print("payload:" ..  payload)
    print("conn:" .. tostring(conn))
    tmr.stop(0);
end

function handleError(one,two)
    print("handleError "..one)
    print("handleError "..two)
end
    
function doGet()
    if conn ~= nil then
	print("closing conn")
	conn:close()
    end
    if gCount > 10 then
	tmr.stop(0)
    elseif gCount == 0 then
	tmr.alarm(0, 1000, 1, doGet )
    end
    gCount = gCount + 1
    wifi_ip = wifi.sta.getip()
    print("ping:" .. gHost .. " " .. gTag .. " wifi:"..tostring(wifi_ip))
    if wifi_ip == nil then
	print ("not connected")
	return;
    end
    conn=net.createConnection(net.TCP, 0) 
    conn:on("receive", handleResponse)
   -- conn:on("connection", handleError)
   -- conn:on("reconnection", handleError)
   -- conn:on("disconnection", handleError)
    
    conn:connect(80,gHost)
    conn:send("GET " .. gTag .. " HTTP/1.1\r\n\r\n");
end

function pingonpower.ping(aHost, aTag)
    gTag = aTag
    gHost = aHost
    -- doGet on repeat until we succeed
    --tmr.alarm(0, 10000, 0, doGet )
    doGet()
end

return pingonpower