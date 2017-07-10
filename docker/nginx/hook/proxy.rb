class MySQLProxy
  def initialize(host, user, password, database)
    @host = host
    @user = user
    @password = password
    @database = database
  end

  def find_proxy_url(endpoint_id)
    row = find_by_id(endpoint_id)
    return 'http://127.0.0.1' if row.nil?

    "http://#{row[1]}:#{row[2]}"
  end

  def close
    db.close
  end

  private
  def db
    @db ||= MySQL::Database.new(@host, @user, @password, @database)
  end

  def find_by_id(endpoint_id)
    rows = []
    db.execute("SELECT * FROM endpoints WHERE id = ?", endpoint_id) { |row, fields| rows << row }
    rows.first
  end
end

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
endpoint_id = request.var.endpoint_id

proxymap = ProxyMap.new('sample')
url = proxymap.fetch_url(endpoint_id)

if url.nil?
  proxy = MySQLProxy.new('db', 'root', '', 'revieee_development')
  url = proxy.find_proxy_url(endpoint_id)
  Nginx.echo("MySQL Access: endpoint_id => #{endpoint_id} url=>#{url}")
  proxymap.set_url(endpoint_id, url)
  proxy.close
end

url
