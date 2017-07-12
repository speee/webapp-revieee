class ProxyMap
  def initialize(namespace)
    @namespace = namespace
  end

  def fetch_url(key)
    cache[key.to_s]
  end

  def set_url(key, url)
    cache[key.to_s] = url.to_s
  end

  def delete(key)
    cache.delete(key.to_s)
  end

  private

  def cache
    @cache ||= Cache.new(namespace: @namespace, size_mb: 2)
  end
end

request = Nginx::Request.new
proxymap = ProxyMap.new('revieee_sample')
proxymap.delete(request.var.endpoint_id)
