def env_stub(key, value)
  prev = ENV[key]
  ENV[key] = value
  returned_value = yield
  ENV[key] = prev
  returned_value
end
