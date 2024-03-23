local Popup = require('nui.popup')
local event = require('nui.utils.autocmd').event
local Layout = require('nui.layout')
local NuiLine = require('nui.line')

local Util = require('word.util')

local cet6_json_path = '~/cet.json'
local bookmark_json_path = '~/cet-bookmark.json'

local dict = vim.json.decode(Util.read_file(cet6_json_path))
local words = vim.tbl_keys(dict)
table.sort(words, function(a, b)
  return a:lower() < b:lower()
end)

local popup = Popup({
  enter = true,
  focusable = true,
  border = { style = 'rounded' },
  position = '50%',
  size = { width = '50%', height = '60%' },
})

local layout = Layout(
  {
    position = '50%',
    size = { width = '50%', height = '60%' },
  },
  Layout.Box({
    Layout.Box(popup, { size = '100%' }),
  }, { dir = 'row' })
)

local toggle_ed = {}

local buf_update = function(bufnr, line_nr)
  for i = 1, #words do
    local word = words[i]
    local line = NuiLine()

    local sig = toggle_ed[i] and 'x' or ' '
    if line_nr == i then
      line:append(('[%s]\t'):format(sig), 'Error')
    else
      line:append(('[%s]\t'):format(sig), 'Error')
    end
    line:append(('%-16s'):format(word), 'Function')
    line:append('\t')
    line:append(('%s'):format(dict[word]), 'String')
    line:render(bufnr, -1, i)
  end
end

local keymap_setup = function()
  popup:map('n', 'm', function()
    local line_nr = vim.fn.line '.'
    if toggle_ed[line_nr] then
      toggle_ed[line_nr] = nil
    else
      toggle_ed[line_nr] = true
    end
    buf_update(popup.bufnr, line_nr)
  end)
  -- update bookmark
  popup:map('n', 'w', function()
    local save = {}
    for i in pairs(toggle_ed) do
      table.insert(save, words[i])
    end
    local data = vim.json.encode(save)
    Util.write_file(bookmark_json_path, data)
  end)
  -- show words' detail
  -- popup:map('n', 'o', show_detail())
end

local launch = function()
  layout:mount()
  popup:on(event.BufLeave, function()
    popup:unmount()
  end)
  keymap_setup()
  buf_update(popup.bufnr)
end

launch()

return {
  launch = launch,
}
