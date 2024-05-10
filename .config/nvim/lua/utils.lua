local M = {}

-- this section is from NormalNvim 
--- Add syntax matching rules for highlighting URLs/URIs.
function M.set_url_effect()
  --- regex used for matching a valid URL/URI string
  local url_matcher =
    "\\v\\c%(%(h?ttps?|ftp|file|ssh|git)://|[a-z]+[@][a-z]+[.][a-z]+:)" ..
    "%([&:#*@~%_\\-=?!+;/0-9a-z]+%(%([.;/?]|[.][.]+)" ..
    "[&:#*@~%_\\-=?!+/0-9a-z]+|:\\d+|,%(%(%(h?ttps?|ftp|file|ssh|git)://|" ..
    "[a-z]+[@][a-z]+[.][a-z]+:)@![0-9a-z]+))*|\\([&:#*@~%_\\-=?!+;/.0-9a-z]*\\)" ..
    "|\\[[&:#*@~%_\\-=?!+;/.0-9a-z]*\\]|\\{%([&:#*@~%_\\-=?!+;/.0-9a-z]*" ..
    "|\\{[&:#*@~%_\\-=?!+;/.0-9a-z]*})\\})+"

  M.delete_url_effect()
  if vim.g.url_effect_enabled then
    vim.fn.matchadd("HighlightURL", url_matcher, 15)
  end
end

--- Delete the syntax matching rules for URLs/URIs if set.
function M.delete_url_effect()
  for _, match in ipairs(vim.fn.getmatches()) do
    if match.group == "HighlightURL" then vim.fn.matchdelete(match.id) end
  end
end

--- Open a URL under the cursor with the current operating system.
---@param path string The path of the file to open with the system opener.
function M.system_open(path)
  if vim.ui.open then return vim.ui.open(path) end
  local cmd
  if vim.fn.has "mac" == 1 then
    cmd = { "open" }
  elseif vim.fn.has "win32" == 1 then
    if vim.fn.executable "rundll32" then
      cmd = { "rundll32", "url.dll,FileProtocolHandler" }
    else
      cmd = { "cmd.exe", "/K", "explorer" }
    end
  elseif vim.fn.has "unix" == 1 then
    if vim.fn.executable "explorer.exe" == 1 then -- available in WSL
      cmd = { "explorer.exe" }
    elseif vim.fn.executable "xdg-open" == 1 then
      cmd = { "xdg-open" }
    end
  end
  if not cmd then M.notify("Available system opening tool not found!", vim.log.levels.ERROR) end
  if not path then
    path = vim.fn.expand "<cfile>"
  elseif not path:match "%w+:" then
    path = vim.fn.expand(path)
  end
  vim.fn.jobstart(vim.list_extend(cmd, { path }), { detach = true })
end

--- Serve a notification with a title of Neovim.
--- Same as using vim.notify, but it saves us typing the title every time.
---@param msg string The notification body.
---@param type number|nil The type of the notification (:help vim.log.levels).
---@param opts? table The nvim-notify options to use (:help notify-options).
function M.notify(msg, type, opts)
  vim.schedule(function() vim.notify(
    msg, type, M.extend_tbl({ title = "Neovim" }, opts)) end)
end

return M
