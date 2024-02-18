local ButtonInfo = require(script.ButtonInfo)

local Action = {
    TriggerTypes = {
        Keys = "Keys",
        Signal = "Signal",
    },
}

Action.__index = Action

----------------------

type Handler = (string, Enum.UserInputState, InputObject, ...any) -> (Enum.ContextActionResult)

type self = {
    name: string,
    priority: Enum.ContextActionPriority,

    buttonInfo: ButtonInfo.ButtonInfo?,
    handler: Handler?,
    trigger: Trigger?,
    triggerType: TriggerType?,
}

export type Trigger = {Enum.KeyCode} | RBXScriptSignal
export type TriggerType = "Keys" | "Signal"
export type Action = typeof(setmetatable({} :: self, Action))

----------------------

function Action.new(name: string, priority: Enum.ContextActionPriority): Action
    local self = {
        name = name,
        priority = priority or Enum.ContextActionPriority.High.Value,
    }

    setmetatable(self, Action)

    return self
end

function Action.clone(self: Action): Action
	local clone = Action.new(self.name, self.priority)

	clone:setTrigger(self.trigger)
	clone:setHandler(self.handler)
	clone:setButtonInfo(self.buttonInfo)

	return clone
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