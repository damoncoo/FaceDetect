cc.FileUtils:getInstance():setPopupNotify(false)

require "GlobalFunc"
--require "protobuf"

collectgarbage("setpause", 100) 
collectgarbage("setstepmul", 5000)

GMainScene = nil
GFaceInfo = require("FaceInfo")

function switchScene(sceneModulePath)
   local mainSceneModule = require(sceneModulePath)
   local status, msg = xpcall(mainSceneModule.createScene, __G__TRACKBACK__)
   if not status then
        FuLogE(msg)
        GMainScene = nil
   else
        GMainScene = msg
        cc.Director:getInstance():replaceScene(GMainScene)
   end
  
   collectgarbage("collect")
end

function closeGameScene()
    GMainScene = cc.Scene:create()
    cc.Director:getInstance():replaceScene(GMainScene)
    collectgarbage("collect")
end

function setFaceInfo(facePoints, faceCount, facePointCount)
    GFaceInfo:setFaceInfo(faceCount, facePointCount, facePoints)
end

function pushCustomerEvent(eventId, argTable)
    local event = cc.EventCustom:new(eventId)
    event._usedata = argTable
    cc.Director:getInstance():getEventDispatcher():dispatchEvent(event)
end