local runner = require("time_is_running_out.runner")

local M = {}

local VALID_LEVELS = {
  [vim.log.levels.TRACE] = false,
  [vim.log.levels.DEBUG] = false,
  [vim.log.levels.INFO]  = true,
  [vim.log.levels.WARN]  = true,
  [vim.log.levels.ERROR] = true,
  [vim.log.levels.OFF]   = false,
}
local function validate_level(level)
  if level == nil then
    return vim.log.levels.WARN
  end

  if type(level) ~= "number" or not VALID_LEVELS[level] then
    error(
      "time_is_running_out: `level` must be one of vim.log.levels.{INFO,WARN,ERROR}",
      2
    )
  end

  return level
end
function M.run(opts)
  opts = opts or {}
    opts.level = validate_level(opts.level)
  runner.run({
    end_date = opts.end_date or "2070-12-31 23:59:59",
    delta = opts.delta or "days",
    only_once_per_day = opts.only_once_per_day,
    title = opts.title or "⏳ Time Is Running Out",
    level = opts.level or vim.log.levels.WARN

  })
end

return M
