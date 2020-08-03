timers = {}

function addTimer(time, trigFunc, enabled, isRepeat)
    local timer = {}
    timer.maxTime = time
    timer.time = time
    timer.enabled = enabled
    timer.triggerFunction = trigFunc
    if isRepeat then
        timer.isRepeat = true
    else
        timer.isRepeat = false
    end
    table.insert(timers, timer)
    return timer
end

function updateTimers(dt)
    for k,v in pairs(timers) do
        if v.enabled then
            v.time = v.time - dt
            if v.time <= 0 then
                if v.isRepeat then v.time = v.maxTime
                else
                     v.time = 0
                     v.enabled = false
                end
                if v.triggerFunction then v.triggerFunction() end
            end
        end
    end
end

function setTimerTime(timer,v)
	timer.maxTime = v
	resetTimer(timer)
end

function resetTimer(timer)
    timer.time = timer.maxTime
end

function pauseTimer(timer)
    timer.enabled = false
end

function continueTimer(timer)
    timer.enabled = true
end

function getRemainingTime(timer)
    return timer.time
end

function isTimeUp(timer)
    return timer.time == 0
end

function isTimerEnabled(timer)
    return timer.enabled
end
