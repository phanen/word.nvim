local M = {}

M.setup = function(opts)
  require('word.config').setup(opts)
end

return setmetatable(M, {
  __index = function(_, k)
    return require('word.commands')[k]
  end,
})
