local M = {}
local util = require("time_is_running_out.util")
-- find plugin root dynamically (works from GitHub installs)
local plugin_root = vim.fn.fnamemodify(
    debug.getinfo(1, "S").source:sub(2),
    ":p:h:h:h"
)

local script = plugin_root .. "/scripts/tiro.py"

local python = vim.g.time_is_running_out_python or "python3"

function M.run(opts)
    -- if read_last_run() ~= today() then
    --     return
    -- end
    local cmd = {
        python,
        script,
        "--end_date", opts.end_date,
        "--delta", opts.delta,
    }

    if opts.only_once_per_day and not util.should_notify_today() then
        return
    end
    vim.fn.jobstart(cmd, {
        stdout_buffered = true,
        stderr_buffered = true,
        on_stdout = function(_, data)
            if data and data[1] ~= "" then
                vim.schedule(function()
                    local output = data[1]
                    local label = util.pluralize(output, opts.delta)
                    util.notify(
                        data[1] .. " " .. label,
                        vim.log.levels.WARN,
                        {
                            title = "⏳ Time Is Running Out",
                            timeout = 5000,
                        }
                    )
                    util.write_last_run()
                end)
            end
        end,

        on_stderr = function(_, err)
            if err and err[1] ~= "" then
                vim.schedule(function()
                    util.notify(
                        table.concat(err, "\n"),
                        vim.log.levels.ERROR,
                        {
                            title = "⏳ Time Is Running Out",
                            timeout = 5000,
                        }
                    )
                end)
            end
        end,
    })
    if opts.only_once_per_day then
        util.write_last_run()
    end
end

return M
