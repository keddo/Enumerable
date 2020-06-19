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
    for i in 0...arr.length
       yield(arr[i], i)
    end
    self
  end

  def my_map
    return to_enum unless block_given?
    my_arr = []
    for i in self
      my_arr << yield(i) if block_given?
    end
    my_arr
  end
end

hash = { name: "kedir", last: "Abdu"}
arr = [1, 2, 4, 6]
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
