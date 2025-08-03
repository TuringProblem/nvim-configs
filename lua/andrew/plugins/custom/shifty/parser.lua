local M = {}
local utils = require("andrew.plugins.custom.shifty.utils")

-- Extract code block at cursor position
function M.extract_code_block_at_cursor(lines, cursor_line)
	local start_line, end_line = M.find_code_block_bounds(lines, cursor_line)

	if not start_line or not end_line then
		return nil
	end

	local block_lines = {}
	local language = nil

	local opening_line = lines[start_line]
	language = M.parse_opening_line(opening_line)

	-- Extract code content
	for i = start_line + 1, end_line - 1 do
		table.insert(block_lines, lines[i])
	end

	local code = table.concat(block_lines, "\n")

	return {
		code = code,
		language = language,
		start_line = start_line,
		end_line = end_line,
	}
end

-- Find the bounds of a code block around the cursor
function M.find_code_block_bounds(lines, cursor_line)
	local start_line = nil
	local end_line = nil

	-- Search backward for opening ```
	for i = cursor_line, 1, -1 do
		if lines[i] and lines[i]:match("^```") then
			start_line = i
			break
		end
	end

	if not start_line then
		return nil, nil
	end

	-- Search forward for closing ```
	for i = start_line + 1, #lines do
		if lines[i] and lines[i]:match("^```%s*$") then
			end_line = i
			break
		end
	end

	if not end_line then
		return nil, nil
	end

	return start_line, end_line
end

-- Parse the opening line of a code block
function M.parse_opening_line(line)
	if not line then
		return nil, nil
	end

	-- Standard markdown code fence: ```language
	local language = line:match("^```%s*(%w+)")

	if language then
		return language:lower(), nil
	end

	-- Plain ``` without language - assume lua for backward compatibility
	if line:match("^```%s*$") then
		return "lua", nil
	end

	return nil, nil -- Not a valid code block
end

-- Find all code blocks in buffer
function M.find_all_code_blocks(lines)
	local blocks = {}
	local i = 1

	while i <= #lines do
		if lines[i] and lines[i]:match("^```") then
			local start_line = i
			local language, name = M.parse_opening_line(lines[i])

			-- Find closing ```
			local end_line = nil
			for j = i + 1, #lines do
				if lines[j] and lines[j]:match("^```%s*$") then
					end_line = j
					break
				end
			end

			if end_line then
				local block_lines = {}
				for k = start_line + 1, end_line - 1 do
					table.insert(block_lines, lines[k])
				end

				table.insert(blocks, {
					code = table.concat(block_lines, "\n"),
					language = language,
					name = name,
					start_line = start_line,
					end_line = end_line,
				})

				i = end_line + 1
			else
				i = i + 1
			end
		else
			i = i + 1
		end
	end

	return blocks
end

return M
