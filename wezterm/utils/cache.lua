local Cache = {}
Cache.__index = Cache

function Cache.new()
  local self = {
    store = {}
  }
  setmetatable(self, Cache)
  return self
end

function Cache:del(k)
  self.store[k] = nil
end

function Cache:exists(k)
  return self.store[k] ~= nil
end

function Cache:get(k)
  return self.store[k]
end

function Cache:set(k, v)
  self.store[k] = v
end

local instance = Cache.new()
return {
  cache = Cache,
  global_cache = instance,
}