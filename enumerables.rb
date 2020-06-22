# frozen_string_literal: true
module Enumerable
  def my_each
    return enum_for unless block_given?

    arr = to_a
    arr.length.times { |i| arr[i].is_a?(Array) ? yield(arr[i][0], arr[i][1]) : yield(arr[i]) }
    self
  end

  def my_each_with_index
    return to_enum unless block_given?

    arr = to_a
    (0...arr.length).each do |i|
      yield(arr[i], i)
    end
    self
  end

  def my_map
    return to_enum unless block_given?

    my_arr = []
    each do |i|
      my_arr << yield(i) if block_given?
    end
    my_arr
  end

  def my_select
    return to_enum unless block_given?
    my_arr = []
    each do |i|
      my_arr << i if yield(i)
    end
    my_arr
  end

  def my_all?(*args)
    is_true = true
    if block_given?
      is_a?(Hash) ? to.a.my_each do |k, v|
                      is_true = false unless yield(k, v)
                    end : my_each do |x|
                            is_true = false unless yield(x)
                          end
    else
      if args[0].is_a?(Integer)
          my_each { |x| is_true = false unless args[0] == x }
      elsif args[0].nil?
          my_each { |x| is_true = false if x == false || x.nil? }
      elsif args[0].is_a?(Regexp)
          my_each { |x| is_true = false if x.match(args[0]).nil? }
      else
          my_each{ |x| is_true = false unless x.is_a?args[0]}
      end
    end
    is_true
  end

  def my_count(num = 0)
    sum = 0
    length.times { |x| sum += 1 if self[x] == num } if num != 0
    sum = max if !block_given? && num == 0
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
      my_each {|i|  none = false if yield(i)}
    else 
       if obj.nil?
         my_each {|i| none = false  if i }
       elsif obj.is_a?(Regexp)
         my_each {|i| none = false if i =~ obj}
       else
         my_each {|i| none = false if i.is_a?(obj)}
       end
    end 
    none
  end

  def my_any?(*args)
    any = false
    if block_given?
      my_each {|x| any = true if yield(x)}
    else 
      if args[0].nil?
        my_each {|x| any = true  if x }
      elsif args[0].is_a?(Regexp)
        my_each {|x| any = true  if x =~ args[0] }
      else 
        my_each {|x| any = true  if x.is_a?(args[0])}
      end
    end
    any
  end

  # def my_inject(i = 0)
  #   i = to_a[0].is_a?(String) ? to_a[0] : i
  #   my_each do |j| 
  #     i = yield(i,j) 
  #   end
  #   i
  # end

  def my_inject(i = nil)
    memo = i.nil? ? to_a[0] : i
    my_each {|j| memo = yield(memo, j)}
    memo
  end

end

def multiply_els(arr)
  arr = [1, 2, 4, 6]
  arr.my_inject { |mul, n| mul * n}
end
# p multiply_els([2,4,5])

hash = { name: 'kedir', last: 'Abdu' }
# arr = [1, 2, 4, 6]
# hash.my_each { |k, v| puts "key: #{k} v value: #{v}" }
# # arr.my_each
# arr.my_each { |x| puts x }
# (1..5).my_each { |y| puts y }
# my_hash = Hash.new

# %w(cat dog wombat).my_each_with_index {|item, index| my_hash[item] = index}

# p my_hash

# friends = ["Sharon", "Leo", "Leila", "Brian", "Arun"]
# friends.my_select { |friend| friend != "Brian" }

# arr.my_map do |i|
#   puts i * 3
# end

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

# 4. my_none? (example test cases)
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

# 4. my_any? (example test cases)
# puts 'my_any?'
# p %w[ant bear cat].my_any? { |word| word.length >= 3 } #=> true
# p %w[ant bear cat].my_any? { |word| word.length >= 4 } #=> true
# p %w[ant bear cat].my_any?(/d/)                        #=> false
# p [nil, true, 99].my_any?(Integer)                     #=> true
# p [nil, true, 99].my_any?                              #=> true
# p [].my_any?                                           #=> false

# p (5..10).my_inject { |sum, n| sum + n }
# p (5..10).my_inject(1) { |product, n| product * n }
# longest = %w{ cat sheep bear }.my_inject do |memo, word|
#   memo.length > word.length ? memo : word
# end
# p longest 
