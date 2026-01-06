local M = {}
function M.notify(msg, level, opts)
    level = level or vim.log.levels.INFO
    opts = opts or {}

    local ok, n = pcall(require, "notify")
    if ok then
        n(msg, level, opts)
    else
        vim.notify(msg, level)
    end
end
function M.today()
  return os.date("%Y-%m-%d")
end

local state_file = vim.fn.stdpath("state") .. "/time_is_running_out_last_run"

function M.read_last_run()
  local f = io.open(state_file, "r")
  if not f then return nil end
  local date = f:read("*l")
  f:close()
  return date
end

function M.write_last_run()
  local f = io.open(state_file, "w")
  if not f then return end
  f:write(M.today())
  f:close()
end
function M.pluralize(value, unit)
    local n = tonumber(value)
    if not n then
        return unit .. " Left"
    end
    if n == 1 then
        return unit:sub(1, -2) .. " Left"
    end
    return unit .. " Left"
end
function M.should_notify_today()
  return M.read_last_run() ~= M.today()
end
return M
