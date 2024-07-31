local M = {}

M.move_block = function(direction)
    local v_start_row = vim.fn.line('v')
    local v_end_row = vim.api.nvim_win_get_cursor(0)[1]

    -- always make v_start_row <= v_end_row
    if v_start_row > v_end_row then
        local temp = v_start_row
        v_start_row = v_end_row
        v_end_row = temp
    end

    local command = ':normal! '

    if direction == 'up' then
        -- do nothing on top
        if v_start_row == 1 then return end

        command = command .. 'xkP'
    elseif direction == 'down' then
        -- do nothing on bottom
        if v_end_row == vim.fn.line('$') then return end

        command = command .. 'xp'
    end

    -- how many rows to select
    local height = v_end_row - v_start_row

    command = command .. 'V' .. (height > 0 and height .. 'j' or '') .. '=gv'
    vim.cmd(command)
end

return M
