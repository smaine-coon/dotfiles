local M = {}

function M.merge_tables(tbl1, tbl2)
  for k, v in pairs(tbl2) do
    if type(v) == "table" and type(tbl1[k]) == "table" then
      M.merge_tables(tbl1[k], v)
    else
      tbl1[k] = v
    end
  end

  return tbl1
end

function M.merge_lists(ls1, ls2)
  local re = {}

  for _, v in ipairs(ls1) do
    table.insert(re, v)
  end
  for _, v in ipairs(ls2) do
    table.insert(re, v)
  end

  return re
end

return M