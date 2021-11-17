--file name: config.lua
local module = {}
module.SSID = {}
module.SSID["NSA_Spynet"] = "ironman578247"
module.HOST = "2WayIoTHub.azure-devices.net"
module.PORT = 8883
module.USERNAME = "FlowerPot"
module.PASSWORD = "SharedAccessSignature sr=2WayIoTHub.azure-devices.net%2Fdevices%2FFlowerPot&sig=SEh5%2FrI%2BCdWy9Vcfi4xUUsBILL5%2B4VJGYCv18S14yTc%3D&se=1528156014"
module.ID = "FlowerPot"
module.ENDPOINT = "devices/FlowerPot/messages"
module.playPin = 1
module.sensorPin = 0
module.relayPin = 4
module.relayButton = 3
module.buzzPin = 6
module.buzzTime = 300
module.dhtPin = 7
module.tempHold = 23

return module
