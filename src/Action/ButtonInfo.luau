local ButtonInfo = {}
ButtonInfo.__index = ButtonInfo

----------------------

type self = {
    position: UDim2,
    title: string,
    image: string,
}

export type ButtonInfo = typeof(setmetatable({} :: self, ButtonInfo))

----------------------

function ButtonInfo.new(position: UDim2, title: string, image: string): ButtonInfo
    local self = {
        position = position,
        title = title,
        image = image,
    }

    setmetatable(self, ButtonInfo)

    return self
end

----------------------

return ButtonInfo