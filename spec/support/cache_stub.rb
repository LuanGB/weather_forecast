def cache_stub(key, value)
  prev = Rails.cache.delete(key)
  Rails.cache.write(key, value)
  yield
  Rails.cache.write(key, prev)
end
