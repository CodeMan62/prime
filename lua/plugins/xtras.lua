-- Dynamic extra plugins loader
local extras = vim.g.extra_plugins or {}
local specs = {}

for _, extra in ipairs(extras) do
  local ok, spec = pcall(require, extra)
  if ok then
    if type(spec) == "table" then
      vim.list_extend(specs, spec)
    end
  end
end

return specs
