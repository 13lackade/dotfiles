local M = {}

M.severity = {
    ERROR = vim.diagnostic.severity.ERROR,
    WARN = vim.diagnostic.severity.WARN,
    INFO = vim.diagnostic.severity.INFO,
    HINT = vim.diagnostic.severity.HINT,
}

M.ICON = {
    [M.severity.ERROR] = "E",
    [M.severity.WARN] = "W",
    [M.severity.INFO] = "I",
    [M.severity.HINT] = "H",
}

M.get_count = function(severity)
    local diagnostic = vim.diagnostic.get(nil ,{ severity = severity })
    local count = 0
    for _ in pairs(diagnostic) do count = count + 1 end
    return count
end

return M;
