local module = {}
state = 0 -- 0 = on, 1 = off
time = 0
time_max = 20
readPort = 2
ledPort = 3
local function relay_start()
    gpio.mode(readPort, gpio.INPUT)
    gpio.mode(ledPort, gpio.OUTPUT)
    gpio.write(ledPort, gpio.LOW)
    tmr.create():alarm(1000, tmr.ALARM_AUTO, app.checkButton)
end
function module.notifyWiFiConnect()
    gpio.write(ledPort, gpio.HIGH)
    tmr.delay(100000)
    gpio.write(ledPort, gpio.LOW)
    tmr.delay(100000)
    gpio.write(ledPort, gpio.HIGH)
    tmr.delay(100000)
    gpio.write(ledPort, gpio.LOW)
    tmr.delay(100000)
    gpio.write(ledPort, gpio.HIGH)
    tmr.delay(100000)
    gpio.write(ledPort, gpio.LOW)
    tmr.delay(100000)
end

function module.checkButton()
 
    press = gpio.read(readPort)
    print(press)
    if (press == 1) then
        gpio.write(ledPort, gpio.HIGH)
        time = 1
        app.notifyMotion()
    else
        if (time > 0) then
            time = time + 1
            gpio.write(ledPort, gpio.HIGH)
        end

        if (time == time_max) then
            app.notifyClear()
            gpio.write(ledPort, gpio.LOW)
            time = 0
        end
    end    
    print(string.format(" -- Last Read Data-- %s %s", press, time))
end

function module.notifyMotion()
    if (state == 0) then
        http.get('http://192.168.0.205:300/api/counter/stateon',
            nil,
            function(code, data)
                if (code < 0) then
                    print("HTTP request failed")
                else
                    print(code, data)
                    state = 1
                end
        end)
    end
end

function module.notifyClear()
    http.get('http://192.168.0.205:300/api/counter/stateoff',
        nil,
        function(code, data)
            if (code < 0) then
                print("HTTP request failed")
            else
                print(code, data)
                state = 0
            end
    end)
end

function module.StartBuzzService()
    sv = net.createServer(net.TCP, 30)
    
    if sv then
      sv:listen(80, function(conn)
        conn:on("receive", receiver)
        conn:send("Buzzing")
        print("Buzzing!")
      end)
    end
end

function receiver(sck, data)
    print(data)
    module.Buzz()
    sck:close()
end
    
function module.Buzz()    
    gpio.mode(config.buzzPin, gpio.OUTPUT)
    gpio.write(config.buzzPin, gpio.HIGH)
    tmr.create():alarm(config.buzzTime, tmr.ALARM_SINGLE, function()
            gpio.write(config.buzzPin, gpio.LOW);
    end)
end


function module.start() 
    print("Starting up app...")
    app.notifyWiFiConnect();
    relay_start()
end

return module
