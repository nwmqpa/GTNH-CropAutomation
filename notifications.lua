local config = require('config')
local internet = require('internet')

local function sendNotification(title, content)
    if config.ntfyEnabled then
        internet.request("https://ntfy.sh/" .. config.ntfyChannel, content, { Title = title, Tags = 'shamrock' })
    end
    print(title .. ": " .. content)
end

return {
    sendNotification = sendNotification
}
