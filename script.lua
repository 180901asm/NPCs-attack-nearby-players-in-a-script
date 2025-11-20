-- ServerScriptServiceに配置
local NPCsFolder = workspace:WaitForChild("NPCs")
local Players = game:GetService("Players")

local ATTACK_RANGE = 5      -- 攻撃範囲（スタッド）
local ATTACK_DAMAGE = 20    -- 攻撃ダメージ
local ATTACK_INTERVAL = 1.5 -- 攻撃間隔（秒）
local FOLLOW_RANGE = 50     -- NPCが追尾を開始する距離
local FOLLOW_SPEED = 12     -- NPCの追尾スピード

-- 最も近いプレイヤーを取得
local function getClosestPlayer(npc)
    local closest = nil
    local minDist = math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
            local dist = (npc.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude
            if dist < minDist then
                minDist = dist
                closest = char
            end
        end
    end
    return closest, minDist
end

for _, npc in ipairs(NPCsFolder:GetChildren()) do
    if npc:FindFirstChild("Humanoid") and npc:FindFirstChild("HumanoidRootPart") then
        spawn(function()
            local humanoid = npc.Humanoid
            local lastAttack = tick()
            humanoid.WalkSpeed = FOLLOW_SPEED
            while npc.Parent do
                local target, dist = getClosestPlayer(npc)
                if target then
                    if dist <= FOLLOW_RANGE then
                        -- 追尾
                        humanoid:MoveTo(target.HumanoidRootPart.Position)
                    end
                    if dist <= ATTACK_RANGE and tick() - lastAttack > ATTACK_INTERVAL then
                        -- 攻撃
                        target.Humanoid:TakeDamage(ATTACK_DAMAGE)
                        lastAttack = tick()
                    end
                end
                wait(0.2)
            end
        end)
    end
end
