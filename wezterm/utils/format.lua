local M = {}

function M.basename(s)
  return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

return M