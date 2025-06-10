local M = {}

M.print_table = function(t, indent)
  indent = indent or ""
  for k, v in pairs(t) do
    if type(v) == "table" then
      print(indent .. k .. " = {")
      M.print_table(v, indent .. "  ")
      print(indent .. "}")
    else
      print(indent .. k .. " = " .. tostring(v))
    end
  end
end

M.merge_tables = function(t1, t2)
  for k, v in pairs(t2) do
    t1[k] = v
  end
  return t1
end

return M
