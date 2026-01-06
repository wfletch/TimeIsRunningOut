local runner = require("time_is_running_out.runner")

local M = {}

function M.run(opts)
  opts = opts or {}

  runner.run({
    end_date = opts.end_date or "2070-12-31 23:59:59",
    delta = opts.delta or "days",
    only_once_per_day = opts.only_once_per_day

  })
end

return M
