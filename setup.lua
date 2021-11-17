local module = {}

local timer = tmr.create()
local function wifi_wait_ip()  
  if wifi.sta.getip()== nil then
    print("IP unavailable, Waiting...")
  else
    timer:stop()
    print("\n====================================")
    print("ESP8266 mode is: " .. wifi.getmode())
    print("MAC address is: " .. wifi.ap.getmac())
    print("IP is "..wifi.sta.getip())
    print("====================================")
    app.start()
  end
end

local function wifi_start(list_aps)
    for k,v in pairs(list_aps) do
        print(k.." : "..v)
    end
    if list_aps then
                wifi.setmode(wifi.STATION);
                station_cfg = {}
                station_cfg.pwd="ironman321@1.2"
                station_cfg.ssid = "SpyNET"
                wifi.sta.config(station_cfg)
                wifi.sta.connect()
                --config.SSID = nil  -- can save memory
                timer:alarm(2500, tmr.ALARM_AUTO, wifi_wait_ip)
    else
        print("Error getting AP list")
    end
end

function module.start()  
  print("Setting MAC to DE:AD:BE:EF:BA:D1")
  print(wifi.sta.setmac("DE:AD:BE:EF:BA:D1"))
  
  print("Configuring Wifi ...")
  wifi.setmode(wifi.STATION);
  wifi.sta.getap(wifi_start)
end

return module  
