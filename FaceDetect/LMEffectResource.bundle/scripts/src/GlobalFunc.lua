--filterID for ios only
local filterID = nil

function setFilterID(id)
    filterID = id
end

function FuLogI(...)
    FuLogInfo(string.format(...))
end

function FuLogE(...)
    FuLogError(string.format(...))    
end

function FuLogW(...)
    FuLogWarn(string.format(...))
end

function switchEffect(effectName)
    callSwitchEffect(filterID, effectName)
end

function closeEffect()
    callCloseEffect()
end

function preLoadBackgroundSound(soundPath)
    callPreLoadBackgoundSound(soundPath)
end

function playBackgroundSound(looping)
    callPlayBackgroundSound(looping)
end

function pauseBackgroundSound()
    callPauseBackgroundSound()
end

function resumeBackgroundSound()
    callResumeBackgroundSound()
end

function releaseBackgroundSound()
    callReleaseBackgroundSound()
end

--float float
function setBackgroundVolume(leftVolume, rightVolume)
    callSetBackgroundVolume(leftVolume, rightVolume)
end

--int
function createSoundEffects(max)
    callCreateSoundEffects(max)
end

function releaseSoundEffects()
    callReleaseSoundEffects()
end

--string
function loadSoundEffect(soundPath)
    callLoadSoundEffect(soundPath)
end

--string
function unloadSoundEffect(soundPath)
    callUnloadSoundEffect(soundPath)
end

--string float float
function setSoundEffectVolume(soundPath, leftVolume, rightVolume)
    callSetSoundEffectVolume(soundPath, leftVolume, rightVolume)
end

--string float
function setSoundEffectRate(soundPath, rate)
    callSetSoundEffectRate(soundPath, rate)
end

--string float float, int, int, float
function playSoundEffect(soundPath, leftVolume, rightVolume, priority, loop, rate)
    callPlaySoundEffect(soundPath, leftVolume, rightVolume, priority, loop, rate)
end

--string
function stopSoundEffect(soundPath)
    callStopSoundEffect(soundPath)
end

--string
function pauseSoundEffect(soundPath)
    callPauseSoundEffect(soundPath)
end

--string
function resumeSoundEffect(soundPath)
    callResumeSoundEffect(soundPath)
end

__G__TRACKBACK__ = function(msg)
    local msg = debug.traceback(msg, 3)
    FuLogE(msg)
    return msg
end