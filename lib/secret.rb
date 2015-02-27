class Secret
  KEY_PREFIX = "_SEEKRIT_"

  attr_accessor :key_name
  attr_accessor :key_value

  def self.all
    # TODO: Put these redis get/set calls into a single method to be reused
    # TODO: Iterate through the index of keys and fetch those.
    # JSON.parse($redis.get("#{KEY_PREFIX}_secrets"))
  end

  def store
    s = Secret.all # fetch the master key
  end

  def self.allkeys
    # Looks up the index key that we're using to keep track of all
    # the given keys stored with seekrit.
    # TODO: Ensure this key and a value actually exist and make sure that
    # if JSON tries to parse it, it won't freak out
    JSON.parse($redis.get("#{KEY_PREFIX}_index"))
  end
end
