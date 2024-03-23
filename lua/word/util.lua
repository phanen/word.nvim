local M = {}

M.read_file = function(path)
  path = vim.fs.normalize(path)
  local fd = assert(io.open(path, 'r'))
  if fd == nil then
    vim.notify('fail to open file', vim.log.levels.ERROR, { title = 'word.nvim' })
    return
  end
  ---@type string
  local data = fd:read('*a')
  fd:close()
  return data
end

M.write_file = function(path, data)
  path = vim.fs.normalize(path)
  local fd = assert(io.open(path, 'w'))
  if fd == nil then
    vim.notify('fail to open file', vim.log.levels.ERROR, { title = 'word.nvim' })
    return
  end
  fd:write(data)
  fd:close()
end
return M
