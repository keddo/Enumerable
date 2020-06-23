module Enumerable
  def my_each
    return enum_for unless block_given?

    arr = is_a?(Array) ? self : to_a
    is_a?(Hash) ? arr.length.times { |i| yield(arr[i][0], arr[i][1]) } : arr.length.times { |i| yield(arr[i]) }
    self
  end

  def my_each_with_index
    return to_enum unless block_given?

    arr = to_a
    (0...arr.length).my_each do |i|
      yield(arr[i], i)
    end
    self
  end

  def my_map(&proc)
    my_arr = []
    hash = {}
    if block_given?
      is_a?(Hash) ? my_each { |k, v| hash[k] = yield(k, v) } : my_each { |x| my_arr << yield(x) }
    else
      my_each { |x| proc.call(x) }
    end
    is_a?(Hash) ? hash : my_arr
  end

  def my_select
    return to_enum unless block_given?

    if is_a?(Array)
      my_arr = []
      my_each do |i|
        my_arr << i if yield(i)
      end
      my_arr
    elsif is_a?(Hash)
      my_hash = {}
      my_each do |i, j|
        my_hash.store(i, j)
      end
    end
  end

  def my_all?(*args)
    is_true = true
    if block_given?
      if is_a?(Hash)
        my_each do |k, v|
          is_true = false unless yield(k, v)
        end
      else my_each { |x| is_true = false unless yield(x) }
      end
    elsif args[0].is_a?(Integer)
      my_each { |x| is_true = false unless args[0] == x }
    elsif args[0].nil?
      my_each { |x| is_true = false if x == false || x.nil? }
    elsif args[0].is_a?(Regexp)
      my_each { |x| is_true = false if x.match(args[0]).nil? }
    else
      my_each { |x| is_true = false unless x.is_a?(args[0]) }
    end
    is_true
  end

  def my_count(num = 0)
    sum = 0
    length.times { |x| sum += 1 if self[x] == num } if num != 0
    sum = max if !block_given? && num.zero?
    if block_given?
      my_each do |i|
        sum += 1 if yield(i)
      end
    end
    sum
  end

  def my_none?(obj = nil)
    none = true
    if block_given?
      my_each { |i| none = false if yield(i) }

    elsif obj.nil?
      my_each { |i| none = false if i }
    elsif obj.is_a?(Regexp)
      my_each { |i| none = false if i =~ obj }
    else
      my_each { |i| none = false if i.is_a?(obj) }
    end

    none
  end

  def my_any?(*args)
    any = false
    if block_given?
      my_each { |x| any = true if yield(x) }
    elsif args[0].is_a?(Integer)
      my_each { |x| any = true if x == args[0] }
    elsif args[0].nil?
      my_each { |x| any = true if x }
    elsif args[0].is_a?(Regexp)
      my_each { |x| any = true if x =~ args[0] }
    else
      my_each { |x| any = true if x.is_a?(args[0]) }
    end
    any
  end

  def my_inject(*args)
    memo = args[0].nil? ? 0 : args[0]
    memo = '' if to_a[0].is_a?(String)
    if args.length > 1
      my_each { |j| memo = memo.send(args[1], j) }
    elsif args[0].is_a?(String)
        memo = 0 if memo.is_a?String
        my_each {|j| memo = memo.send(args[0].to_sym, j)}
    else
      my_each { |j| memo = yield(memo, j) }
    end
    memo
  end
end

def multiply_els(arr)
  arr.my_inject(1) { |mul, n| mul * n }
end
p multiply_els([2,4,5])

# hash = { name: 'kedir', last: 'Abdu' }
# arr = [1, 2, 4, 6]
# 1. my_each (example test cases)
# puts 'my_each'
# puts '-------'
# hash.my_each { |k, v| puts "key: #{k} v value: #{v}" }
# arr.my_each
# arr.my_each { |x| puts x }
# [[2,3], [5,7], [8,10]].my_each {|el| p el}
# (1..5).my_each { |y| puts y }

# 2. my_each_with_index (example test cases)
# puts 'my_each_width_index'
# puts '-------'
# my_hash = Hash.new
# %w(cat dog wombat).my_each_with_index {|item, index| my_hash[item] = index}
# p my_hash

# 3. my_select (example test cases)
# puts 'my_select'
# puts '-------'
# friends = ["Sharon", "Leo", "Leila", "Brian", "Arun"]
# p friends.my_select { |friend| friend != "Brian" }

# arr.my_map do |i|
#   puts i * 3
# end
# hash = { bacon: "protein", apple: "fruit" }

# p hash.my_map { |k,v| [k, v.to_sym] }.to_h
# {:bacon=>:protein, :apple=>:fruit}

# 3. my_select (example test cases)
# puts 'my_select'
# puts '-------'
# friends = ["Sharon", "Leo", "Leila", "Brian", "Arun"]
# p friends.my_select { |friend| friend != "Brian" }
# h = { "a" => 100, "b" => 200, "c" => 300 }
# p h.my_select {|k,v| k > "a"}  #=> {"b" => 200, "c" => 300}
# p h.my_select {|k,v| v < 200}  #=> {"a" => 100}
# arr.my_select do |i|
#   if i % 2 == 0
#     puts i
#   end
# end

# my_count test cases
# arr = [1,3,4,5,6,7,8, 5, 5]
# p arr.my_count {|x| x >= 5} # when block is given
# p arr.my_count(1) # count the number of occurances of a number
# p arr.my_count # return the max number when no block and arg

# 4. my_all? (example test cases)
# puts 'my_all?'
# puts '-------'
# p [1, 2, 3, 4, 5].my_all? # => true
# p [1, 2, 3].my_all?(Integer) # => true
# p [[1,2], [3, 9]].my_all?(Array)
# p %w[dog door rod blade].my_all?(/d/) # => true
# p [1, 1, 1].my_all?(1) # => true
# p [-8, -9, -6].my_all? { |n| n < 0 } # => true
# p [-8, -9, -6, 0].my_all? { |n| n < 0 } # => false
# p(('a'..'z').my_all? { |i| i.is_a? String })
# p [2, 4, 8].my_all?(&:even?)
# even = proc { |x| x.even? }
# p [2, 4, 8].my_all?(&even)
# p [2, 3, 8].my_all?(&:odd?)

# 5. my_any? (example test cases)
# puts 'my_any?'
# puts '-------'
# p [7, 10, 3, 5].my_any?(&:even?) # => true
# p %w[q r s i].my_any? { |char| 'aeiou'.include?(char) } # => true
# p [7, 11, 3, 5].my_any?(&:even?) # => false
# # test cases required by tse reviewer
# p [3, 5, 4, 11].my_any? # => true
# p [1, nil, false].my_any?(1) # => true
# p [1, nil, false].my_any?(Integer) # => true
# p %w[dog door rod blade].my_any?(/z/) # => false
# p [1, 2, 3].my_any?(1) # => true

# 6. my_none? (example test cases)
# puts 'my_none?'
# p %w{ant bear cat}.my_none? { |word| word.length < 0 } # true
# p %w{ant bear cat}.my_none? { |word| word.length > 0 } # false
# p [1,2,3,4,5].my_none? {|n| n <= 5}                   # false
# p %w{ant bear cat}.my_none?(/d/)                        #=> true
# p [1, 3.4, 42].my_none?(Float)                         #=> false
# p [].my_none?                                           #=> true
# p [nil].my_none?                                        #=> true
# p [nil, false].my_none?                                 #=> true
# p [nil, false, true].my_none?                           #=> false

# 7. my_count (example test cases)
# puts 'my_count'
# puts '--------'
# p [1, 4, 3, 8].my_count(&:even?) # => 2
# p %w[DANIEL JIA KRITI dave].my_count { |s| s == s.upcase } # => 3
# p %w[daniel jia kriti dave].my_count { |s| s == s.upcase } # => 0
# # test cases required by tse reviewer
# p [1, 2, 3].my_count # => 3
# p [1, 1, 1, 2, 3].my_count(1) # => 3

# 8. my_map
# puts 'my_map'
# puts '------'
# p [1, 2, 3].my_map { |n| 2 * n } # => [2,4,6]
# p %w[Hey Jude].my_map { |word| word + '?' } # => ["Hey?", "Jude?"]
# p [false, true].my_map(&:!) # => [true, false]
# my_proc = proc { |num| num > 10 }
# p [18, 22, 5, 6].my_map(&my_proc) # => true true false false

# 9. my_inject
# puts 'my_inject'
# puts '---------'
# p [1, 2, 3, 4].my_inject(10) { |accum, elem| accum + elem } # => 20
# p [1, 2, 3, 4].my_inject { |accum, elem| accum + elem } # => 10
# p [5, 1, 2].my_inject('+') # => 8
# p (5..10).my_inject(2, :*) # should return 302400
# p (5..10).my_inject(4) { |prod, n| prod * n } # 
# p (5..10).my_inject { |sum, n| sum + n }
# p (5..10).my_inject(1) { |product, n| product * n }
# longest = %w{ cat sheep bear }.my_inject do |memo, word|
#   memo.length > word.length ? memo : word
# end
# p longest
