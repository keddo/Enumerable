require './enumerables.rb'

describe 'Enumerable' do

  let(:num_array) { [1,3,4,5,6,7,8,5,5] }
  let(:empty_array) { [] }
  let(:word_array) { ["Sharon", "Leo", "Leila", "Brian", "Arun"] }

  describe '#my_each' do
    
    context 'If block is not given' do
      it 'returns an enumerator' do
        expect(num_array.my_each.is_a?(Enumerable)).not_to be false
      end
    end

    context 'If a block is given' do
      it 'it squares each number in the array' do
        custom_array = []
        test_array = []
        num_array.my_each { |i| custom_array << i ** 2 }
        num_array.each { |i| test_array << i ** 2 }
        expect(test_array).to eql(custom_array)
      end

      it "prints out the contents of the hash" do
      end
    
    end
  end
 
  describe '#my_each_with_index' do
    let(:arr){%w(cat dog wombat)} 
    
   it "should behave as each_with_index" do
        hash_1 = Hash.new
        hash_2 = Hash.new
        arr.each_with_index { |item, index|
          hash_1[item] = index
        }
        arr.my_each_with_index { |item, index|
          hash_2[item] = index
        }
        expect(hash_1).to eql(hash_2)
    end

  end

#  describe '#my_map' do
   
#   context 'If block is not given' do 
#     expect(num_array.my_map.is_a?(Enumerable)).not_to be false
#   end
  
#   context 'If a block is given' do 
#     it do
#     end
#   end

#  end



end
