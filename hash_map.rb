class Hashmap
  attr_reader :loadfactor

  def initialize 
    @loadfactor = 0.75
    @capacity = 16
    @size = 0 
    @buckets = Array.new(@capacity) { [] }
  end

  def hash(key)
    hash_code = 0
    prime_number = 31
    key.each_char { |char| hash_code = prime_number * hash_code + char.ord }
    hash_code % @capacity
  end

  def set(key, value)
    index = hash(key)
    bucket = @buckets[index]
    
    # Vérifier si la clé existe déjà dans le bucket
    bucket.each do |entry|
      if entry[:key] == key
        entry[:value] = value #
        return
      end
    end
    
    # Si la clé n'existe pas, on ajoute une nouvelle entrée
    bucket << { key: key, value: value }
    @size += 1
    
    # Vérifie si on doit redimensionner
    resize if @size / @capacity.to_f > @loadfactor
  end

  def get(key)
    index = hash(key)
    bucket = @buckets[index]
    
    # Cherche la clé dans le bucket et retourne la valeur
    bucket.each do |entry|
      return entry[:value] if entry[:key] == key
    end
    
    nil # Retourne nil si la clé n'existe pas
  end

  def has?(key)
    index = hash(key)
    bucket = @buckets[index]
    
    # Vérifie si la clé existe dans le bucket
    bucket.any? { |entry| entry[:key] == key }
  end

  def remove(key)
    index = hash(key)
    bucket = @buckets[index]
    
    # Cherche la clé dans le bucket et la supprime
    bucket.each_with_index do |entry, idx|
      if entry[:key] == key
        bucket.delete_at(idx)
        @size -= 1
        return entry[:value]
      end
    end
    
    nil
  end

  def length
    @buckets.length
  end

  def clear
    @buckets = Array.new(@capacity) { [] }
    @size = 0
  end

  def keys
    @buckets.flat_map { |bucket| bucket.map { |entry| entry[:key] } }
  end

  def values
    @buckets.flat_map { |bucket| bucket.map { |entry| entry[:value] } }
  end

  def entries
    @buckets.flat_map { |bucket| bucket.map { |entry| { entry[:key] => entry[:value] } } }
  end

  def loadfactor
    @size / @capacity.to_f
  end

  private

  def resize
    @capacity *= 2
    new_buckets = Array.new(@capacity) { [] }
    
    @buckets.each do |bucket|
      bucket.each do |entry|
        index = hash(entry[:key])
        new_buckets[index] << entry
      end
    end
    
    @buckets = new_buckets
  end
end

# Test du code
test = Hashmap.new

test.set('apple', 'red')
test.set('banana', 'yellow')
test.set('carrot', 'orange')
test.set('dog', 'brown')
test.set('elephant', 'gray')
test.set('frog', 'green')
test.set('grape', 'purple')
test.set('hat', 'black')
test.set('ice cream', 'white')
test.set('jacket', 'blue')
test.set('kite', 'pink')
test.set('lion', 'golden')

test.remove('apple')

# Affichage des résultats
puts "Keys: #{test.keys}"
puts "Values: #{test.values}"
puts "Entries: #{test.entries}"

p test.loadfactor

test.set('moon', 'silver')
p test.loadfactor
