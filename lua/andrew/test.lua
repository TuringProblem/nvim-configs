local money = game.Players.LocalPlayer:WaitForChild("leaderstats"):WaitForChild("Credits")

script.Parent.Text = "$" .. money.Value

money.Changed:Connect(function()
	script.Parent.Text = "$" .. money.Value
end)

local abbrev = { "", "K", "M", "B", "T", "Qa", "Qi", "Sx", "Sp", "Oc", "No", "Dc" }
function abbrevNumber(n: number): string
	local digits = math.floor(math.log10(n)) + 1
	local abbrevIndex = math.ceil(digits / 3)
	local numberAbbrev = abbrev[abbrevIndex]

	local leftDigits, rightDigits, reducedNum
	if digits > 3 then
		leftDigits = (digits - 1) % 3 + 1
		reducedNum = n / math.pow(10, digits - leftDigits)
		rightDigits = 3 - leftDigits
	else
		leftDigits = digits
		rightDigits = 0
		reducedNum = n
	end

	local formatString = string.format("%%%d.%df%%s", leftDigits, rightDigits)
	local newNumber = string.format(formatString, reducedNum, numberAbbrev)
	return newNumber
end

for i = 0, 12 do
	print(abbrevNumber(10 ^ i))
end
