local FaceInfo = {mFaceCount = 0, mFacePointCount = 0, mPoints = nil}

--faceCount 脸的个数
--eachFacePoint 每张脸有几个点
--points 每张脸的表，points[1] 第0张脸的表
function FaceInfo.setFaceInfo(self, faceCount, facePointCount, points)
    self.mFaceCount = faceCount
    self.mFacePointCount = facePointCount
    self.mPoints = points

    local event = cc.EventCustom:new(self.getFaceInfoChangedEventName())
    cc.Director:getInstance():getEventDispatcher():dispatchEvent(event)
end

function FaceInfo.getFaceCount(self)
    return self.mFaceCount
end

function FaceInfo.getCenter(self, faceIndex)
    --lua 数组从1开始所以加1
    local centerIndex = 46 * 2 + 1
    local points = self.mPoints[faceIndex]
    return points[centerIndex], points[centerIndex + 1]
end

function FaceInfo.getPoint(self, faceIndex, pointIndex)
    local index = pointIndex * 2 + 1
    local points = self.mPoints[faceIndex]
    return points[index], points[index + 1]
end

function FaceInfo.getFaceInfoChangedEventName()
    return "face_info_changed"
end

return FaceInfo