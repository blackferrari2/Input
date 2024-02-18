local ContextActionService = game:GetService("ContextActionService")

local Action = require(script.Parent.Action)

local Input = {}
Input.__index = Input

----------------------

type self = {
    actions: {Action.Action},
    bindedActionJunk: {[string]: string | RBXScriptConnection},
}

export type Input = typeof(setmetatable({} :: self, Input))

----------------------

local ERROR_ACTION_ALREADY_BINDED = "attempted to add action thats already binded. %s"
local ERROR_ACTION_NOT_BINDED = "attempted to modify action thats not binded. %s"
local ERROR_ACTION_MISSING_HANDLER = "action %s is missing a handler. please add one with action:setHandler()"
local ERROR_ACTION_MISSING_TRIGGER = "action %s is missing its trigger. please add one with action:setTrigger()"

----------------------

function Input.new(): Input
    local self = {
        actions = {},
        bindedActionJunk = {},
    }

    setmetatable(self, Input)

    return self
end

function Input.add(self: Input, action: Action.Action, ...: any)
    if self:isActionBinded(action) then
        error(string.format(ERROR_ACTION_ALREADY_BINDED, action.name))
    end

    if not action.trigger then
        error(string.format(ERROR_ACTION_MISSING_TRIGGER, action.name))
    end

    if not action.handler then
        error(string.format(ERROR_ACTION_MISSING_HANDLER, action.name))
    end

	local args = {...}

    if action.triggerType == Action.TriggerTypes.Keys then
		local function callHandler(actionName: string, inputState: Enum.UserInputState, inputObject: InputObject)
			return action.handler(actionName, inputState, inputObject, table.unpack(args))
		end

        ContextActionService:BindActionAtPriority(
            action.name,
            callHandler, 
            action.buttonInfo and true or false, 
            action.priority, 
            table.unpack(action.trigger)
        )

        self.bindedActionJunk[action.name] = action.name

        if action.buttonInfo then
            if action.buttonInfo.image then
                ContextActionService:SetImage(action.name, action.buttonInfo.image)
            end
    
            if action.buttonInfo.position then
                ContextActionService:SetPosition(action.name, action.buttonInfo.position)
            end
    
            if action.buttonInfo.title then
                ContextActionService:SetTitle(action.name, action.buttonInfo.title)
            end 
        end
    end

    if action.triggerType == Action.TriggerTypes.Signal then
        assert(typeof(action.trigger) == "RBXScriptSignal")

        local connection = action.trigger:Connect(function()
			local emptyInputObject: any = nil

            action.handler(action.Name, Enum.UserInputState.Begin, emptyInputObject, table.unpack(args))
        end)

        self.bindedActionJunk[action.name] = connection
    end

    table.insert(self.actions, action)
end

function Input.rebind(self: Input, action: Action.Action, newTrigger: Action.Trigger)
    if not self:isActionBinded(action) then
        error(string.format(ERROR_ACTION_NOT_BINDED, action.name))
    end

    action:setTrigger(newTrigger)

    self:remove(action)
    self:add(action)
end

function Input.remove(self: Input, action: Action.Action)
    if not self:isActionBinded(action) then
        error(string.format(ERROR_ACTION_NOT_BINDED, action.name))
    end

    local thingToCleanup =  self.bindedActionJunk[action.name]

    if action.triggerType == Action.TriggerTypes.Keys then
        ContextActionService:UnbindAction(thingToCleanup)
    end

    if action.triggerType == Action.TriggerTypes.Signal then
        thingToCleanup:Disconnect()
    end

    self.bindedActionJunk[action.name] = nil
    table.remove(self.actions, table.find(self.actions, action))
end

function Input.destroy(self: Input)
    for _, action in pairs(self.actions) do
        self:remove(action)
    end

    local setmetatable: any = setmetatable
    setmetatable(self, nil)
end

function Input.isActionBinded(self: Input, action: Action.Action): boolean
    return self.bindedActionJunk[action.name] ~= nil
end

----------------------

return Input