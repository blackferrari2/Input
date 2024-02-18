local ButtonInfo = require(script.ButtonInfo)

local Action = {
    TriggerTypes = {
        Keys = "Keys",
        Signal = "Signal",
    },

	Index = 0,
}

Action.__index = Action

----------------------

type Handler = (string, Enum.UserInputState, InputObject, ...any) -> (Enum.ContextActionResult)

type self = {
    name: string,
    key: string,
    priority: number,

    buttonInfo: ButtonInfo.ButtonInfo?,
    handler: Handler?,
    trigger: Trigger?,
    triggerType: TriggerType?,
}

export type Trigger = {Enum.KeyCode} | RBXScriptSignal
export type TriggerType = "Keys" | "Signal"
export type Action = typeof(setmetatable({} :: self, Action))

----------------------

-- key: so i wanna be able to bind actions with the same name
-- thats the keys purpose. generate an unique name for contextactionservice everytime this function is called
-- its really just a counter thats appended to the `name`
function Action.new(name: string, priority: number?): Action
    local self = {
        name = name,
		key = name .. Action.Index,
        priority = priority or Enum.ContextActionPriority.High.Value,
    }

    setmetatable(self, Action)

	Action.Index += 1

    return self
end

function Action.setTrigger(self: Action, to: Trigger)
	if not to then
		self.trigger = nil
		self.triggerType = nil
		return
	end

    self.trigger = to
    self.triggerType = Action.TriggerTypes.Keys

    if typeof(to) == "RBXScriptSignal" then
        self.triggerType = Action.TriggerTypes.Signal
    end
end

function Action.setHandler(self: Action, to: Handler?)
    self.handler = to
end

function Action.setButtonInfo(self: Action, to: ButtonInfo.ButtonInfo?)
    self.buttonInfo = to
end

----------------------

return Action