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
    buttonInfo: ButtonInfo.ButtonInfo | false,
    handler: Handler,
    trigger: Trigger,
    triggerType: TriggerType,
}

export type Trigger = {Enum.KeyCode} | RBXScriptSignal
export type TriggerType = "Keys" | "Signal"
export type Action = typeof(setmetatable({} :: self, Action))

----------------------

function Action.new(name: string): Action
    local self = {
        name = name,
        priority = Enum.ContextActionPriority.High.Value,
        buttonInfo = false,
        handler = nil,
        trigger = nil,
        triggerType = nil,
    }

    setmetatable(self, Action)

    return self
end

function Action.setTrigger(self: Action, to: Trigger)
    self.trigger = to
    self.triggerType = Action.TriggerTypes.Keys

    if typeof(to) == "RBXScriptSignal" then
        self.triggerType = Action.TriggerTypes.Signal
    end
end

function Action.setHandler(self: Action, to: Handler)
    self.handler = to
end

function Action.setButtonInfo(self: Action, to: ButtonInfo.ButtonInfo?)
    self.buttonInfo = to or false
end

----------------------

return Action