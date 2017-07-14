--[[

Copyright (c) 2011-2015 chukong-incc.com

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

]]

require "cocos.cocos2d.Cocos2d"
require "cocos.cocos2d.Cocos2dConstants"
require "cocos.cocos2d.functions"

__G__TRACKBACK__ = function(msg)
    local msg = debug.traceback(msg, 3)
    print(msg)
    return msg
end

-- opengl
require "cocos.cocos2d.Opengl"
require "cocos.cocos2d.OpenglConstants"

-- audio
if FU_ENABLE_AUDIO then
require "cocos.cocosdenshion.AudioEngine"
end

-- cocosstudio
if nil ~= ccs then
    require "cocos.cocostudio.CocoStudio"
end
-- ui
if nil ~= ccui then
    require "cocos.ui.GuiConstants"
    require "cocos.ui.experimentalUIConstants"
end

-- extensions
if FU_ENABLE_EXTENSION then
require "cocos.extension.ExtensionConstants"
end

-- network
if FU_ENABLE_NETWORK then
require "cocos.network.NetworkConstants"
end

-- Spine
if nil ~= sp then
    require "cocos.spine.SpineConstants"
end

require "cocos.cocos2d.deprecated"
require "cocos.cocos2d.DrawPrimitives"

-- Lua extensions
require "cocos.cocos2d.bitExtend"

-- CCLuaEngine
if FU_ENABLE_DEPRECATED then
require "cocos.cocos2d.DeprecatedCocos2dClass"
require "cocos.cocos2d.DeprecatedCocos2dEnum"
require "cocos.cocos2d.DeprecatedCocos2dFunc"
require "cocos.cocos2d.DeprecatedOpenglEnum"
end

-- register_cocostudio_module
if nil ~= ccs then
    require "cocos.cocostudio.DeprecatedCocoStudioClass"
    require "cocos.cocostudio.DeprecatedCocoStudioFunc"
end


-- register_cocosbuilder_module
if FU_ENABLE_COCOSBUILDER then
require "cocos.cocosbuilder.DeprecatedCocosBuilderClass"
end

-- register_cocosdenshion_module
if FU_ENABLE_COCOSDENSHION then
require "cocos.cocosdenshion.DeprecatedCocosDenshionClass"
require "cocos.cocosdenshion.DeprecatedCocosDenshionFunc"
end

-- register_extension_module
if FU_ENABLE_EXTENSION then
require "cocos.extension.DeprecatedExtensionClass"
require "cocos.extension.DeprecatedExtensionEnum"
require "cocos.extension.DeprecatedExtensionFunc"
end

-- register_network_module
if FU_ENABLE_NETWORK then
require "cocos.network.DeprecatedNetworkClass"
require "cocos.network.DeprecatedNetworkEnum"
require "cocos.network.DeprecatedNetworkFunc"
end

-- register_ui_moudle
if nil ~= ccui then
    require "cocos.ui.DeprecatedUIEnum"
    require "cocos.ui.DeprecatedUIFunc"
end

-- cocosbuilder
if FU_ENABLE_COCOSBUILDER then
require "cocos.cocosbuilder.CCBReaderLoad"
end

-- physics3d
if FU_ENABLE_3d then
require "cocos.physics3d.physics3d-constants"
end

if CC_USE_FRAMEWORK then
    require "cocos.framework.init"
end
