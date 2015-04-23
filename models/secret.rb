class Secret
  include Virtus.model
  KEY_PREFIX = "#{RUNTIME_ENV}_SEEKRIT"
  SECRET_KEY = "#{KEY_PREFIX}_secrets"

  attribute :name
  attribute :value

  def self.all
    $redis.hgetall(SECRET_KEY)
  end

  def self.get(key)
    $redis.hmget(SECRET_KEY, key).first
  end

  def save
    if valid?
      return $redis.hmset(SECRET_KEY, name, value)
    end
    return false
  end

  def self.destroy(n)
    return $redis.hdel(SECRET_KEY, n)
  end

private

  def valid?
    name.length > 0 && value.length > 0
  end

end
