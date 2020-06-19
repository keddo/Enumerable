module Enumerable

  def my_each
    return enum_for unless block_given?
    arr = to_a
    arr.length.times { |i| arr[i].is_a?(Array) ? yield(arr[i][0], arr[i][1]) : yield(arr[i]) }
    self
  end

  def my_each_with_index
    
  end
end

hash = { name: "kedir", last: "Abdu"}
arr = [1, 2, 4, 6]
hash.my_each { |k, v| puts "key: #{k} v value: #{v}" }
arr.my_each

arr.my_each { |x| puts x }

(1..5).my_each { |y| puts y }