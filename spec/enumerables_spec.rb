require './enumerables.rb'

describe 'Enumerable' do
  let(:num_array) { [2, 3, 4, 5, 6, 7, 8, 5, 5] }
  let(:empty_array) { [] }
  let(:word_array) { %w[Sharon Lea Leila Brian Arun] }
  let(:name_hash) { { name: 'kedir', last: 'Abdu' } }

  describe '#my_each' do
    context 'If block is not given' do
      it 'returns an enumerator' do
        expect(num_array.my_each.is_a?(Enumerable)).to_not be false
      end
    end

    context 'If a block is given' do
      it 'it squares each number in the array' do
        custom_array = []
        test_array = []
        num_array.my_each { |i| custom_array << i**2 }
        num_array.each { |i| test_array << i**2 }
        expect(test_array).to eql(custom_array)
      end

      it 'it prints the contents of the hash' do
        custom_hash = []
        test_hash = []

        name_hash.my_each { |k, v| custom_hash << [k.to_s, v.upcase] }
        name_hash.each { |k, v| test_hash << [k.to_s, v.upcase] }
        expect(test_hash).to eql(custom_hash)
      end
    end
  end

  describe '#my_each_with_index' do
    let(:arr) { %w[cat dog wombat] }

    it 'should behave as each_with_index' do
      hash_b = {}
      hash_a = {}
      arr.each_with_index do |item, index|
        hash_b[item] = index
      end
      arr.my_each_with_index do |item, index|
        hash_a[item] = index
      end
      expect(hash_b).to eql(hash_a)
    end
    
    it "it's indexes sould not differ from the original each_with_index" do
      h = Hash.new(0)
      arr.my_each_with_index{|item, index| h[item] = index }
      expect(h["cat"]).to_not be 1
    end

    context 'If block is not given' do
      it 'returns an enumerator' do
        expect(num_array.my_each_with_index.is_a?(Enumerable)).to_not be false
      end
    end
  end

  describe '#my_map' do
    context 'If block is not given' do
      it 'returns an enumerator' do
        expect(num_array.my_map.is_a?(Enumerable)).to_not be false
      end
    end

    context 'If a block is given' do
      it 'rises to the powe of two' do
        custom_array = []
        test_array = []
        num_array.my_map { |i| custom_array << i**2 }
        num_array.map { |i| test_array << i**2 }
        expect(test_array).to eql(custom_array)
      end

      it 'should not be the same as the initial array' do
        test_array = num_array.my_map { |i| i**2 }
        expect(test_array).to_not be_eql(num_array)
      end

      it 'it prints the contents of the hash' do
        custom_hash = []
        test_hash = []

        name_hash.my_map { |k, v| custom_hash << [k.to_s, v.upcase] }
        name_hash.map { |k, v| test_hash << [k.to_s, v.upcase] }
        expect(test_hash).to eql(custom_hash)
      end
    end
  end

  describe '#my_select' do
    context 'If block is given' do
      it 'select all but brian' do
        test_array = word_array.my_select { |friend| friend != 'Brian' }
        custom_array = word_array.reject { |friend| friend == 'Brian' }
        expect(test_array).to eql(custom_array)
      end
      it 'drops all odd numbers' do
        test_array = num_array.my_select(&:even?)
        custom_array = num_array.select(&:even?)
        expect(test_array).to eql(custom_array)
      end
      it 'selects abdu' do
        test_array = name_hash.my_select { |_k, v| v == 'Abdu' }
        custom_array = name_hash.select { |_k, v| v == 'Abdu' }
        expect(test_array).to eql(custom_array)
      end
    end

    context 'If block is not given' do
      it 'returns an enumerator' do
        expect(word_array.my_select.is_a?(Enumerable)).not_to be false
      end
    end
  end

  describe '#my_all?' do
    context 'If no block and no argument given  ' do
      it 'returns all true if all element in the array are truthy' do
        test_array = num_array.my_all?
        custom_array = num_array.all?
        expect(test_array).to eql(custom_array)
      end
    end
    context 'If no block given with an argument  ' do
      it 'return true if all elements are of same class as the argument' do
        test_array = num_array.my_all?(Integer)
        custom_array = num_array.all?(Integer)
        expect(test_array).to eql(custom_array)
      end
      it 'returns true if the every element in the array has the letter a in it' do
        test_array = word_array.my_all?(/a/)
        custom_array = word_array.all?(/a/)
        expect(test_array).to eql(custom_array)
      end
    end

    context 'If block is given' do
      it 'Runs every element through the block returns true if all elemets are true ' do
        test_array = num_array.my_all? { |el| el < 1 }
        custom_array = num_array.all? { |el| el < 1 }
        expect(test_array).to eql(custom_array)
      end
    end

    describe '#my_any?' do
      context 'If no block and no argument given  ' do
        it 'returns all true if all element in the array are truthy' do
          test_array = num_array.my_any?
          custom_array = num_array.any?
          expect(test_array).to eql(custom_array)
        end
      end
      context 'If no block given with an argument  ' do
        it 'return true if all elements are of same class as the argument' do
          test_array = num_array.my_any?(Integer)
          custom_array = num_array.any?(Integer)
          expect(test_array).to eql(custom_array)
        end
        it 'returns true if the every element in the array has the letter a in it' do
          test_array = word_array.my_any?(/a/)
          custom_array = word_array.any?(/a/)
          expect(test_array).to eql(custom_array)
        end
        it 'should return false if none of the elements are present in the array' do
          expect([1, 2, 3].my_any?(4)).to_not be true
        end
      end

      context 'If block is given' do
        it 'Runs every element through the block returns true if all elemets are true ' do
          test_array = num_array.my_any? { |el| el > 1 }
          custom_array = num_array.any? { |el| el > 1 }
          expect(test_array).to eql(custom_array)
        end
      end
    end
  end

  describe '#my_any?' do
    context 'If no block and no argument given  ' do
      it 'returns all true if all element in the array are truthy' do
        test_array = num_array.my_any?
        custom_array = num_array.any?
        expect(test_array).to eql(custom_array)
      end
    end
    context 'If no block given with an argument  ' do
      it 'return true if all elements are of same class as the argument' do
        test_array = num_array.my_any?(Integer)
        custom_array = num_array.any?(Integer)
        expect(test_array).to eql(custom_array)
      end
      it 'returns true if the every element in the array has the letter a in it' do
        test_array = word_array.my_any?(/a/)
        custom_array = word_array.any?(/a/)
        expect(test_array).to eql(custom_array)
      end
    end

    context 'If block is given' do
      it 'Runs every element through the block returns true if all elemets are true ' do
        test_array = num_array.my_any? { |el| el > 1 }
        custom_array = num_array.any? { |el| el > 1 }
        expect(test_array).to eql(custom_array)
      end
    end
  end

  describe '#my_none?' do
    context 'If no block and no argument given  ' do
      it 'returns all true if all element in the array are truthy' do
        test_array = num_array.my_none?
        custom_array = num_array.none?
        expect(test_array).to eql(custom_array)
      end
    end
    context 'If no block given with an argument  ' do
      it 'return true if all elements are of same class as the argument' do
        test_array = num_array.my_none?(Integer)
        custom_array = num_array.none?(Integer)
        expect(test_array).to eql(custom_array)
      end
      it 'returns true if the every element in the array has the letter a in it' do
        test_array = word_array.my_none?(/a/)
        custom_array = word_array.none?(/a/)
        expect(test_array).to eql(custom_array)
      end
    end

    context 'If block is given' do
      it 'Runs every element through the block returns true if all elemets are true ' do
        test_array = num_array.my_none? { |el| el < 1 }
        custom_array = num_array.none? { |el| el < 1 }
        expect(test_array).to eql(custom_array)
      end
    end
  end

  describe '#my_count' do
    context 'if no block is given' do
      it 'Count all the elements in the given array' do
        test_array = num_array.my_count
        custom_array = num_array.count
        expect(test_array).to eql(custom_array)
      end
      it 'counts the elements in the array that are equal to the argument' do
        test_array = num_array.my_count(5)
        custom_array = num_array.count(5)
        expect(test_array).to eql(custom_array)
      end

      it 'expects the count to not be equal to five' do
        expect(num_array.my_count).to_not be(5)
      end

      it 'expects the array size to be 9' do
        expect(num_array.my_count).to eql(9)
      end
    end
    context 'if block is given' do
      it 'Count all the elements in the array that return true in the block' do
        test_array = word_array.my_count { |s| s == s.upcase }
        custom_array = word_array.count { |s| s == s.upcase }
        expect(test_array).to eql(custom_array)
      end
      it 'Count all the elements in the array that return true in the block' do
        test_array = num_array.my_count(&:even?)
        custom_array = num_array.count(&:even?)
        expect(test_array).to eql(custom_array)
      end
    end
  end

  describe '#my_inject' do
    context 'if no block is given' do
      it 'Return cumulative' do
        test_array = num_array.my_inject { |accum, elem| accum + elem }
        custom_array = num_array.inject { |accum, elem| accum + elem }
        expect(test_array).to eql(custom_array)
      end
      it 'sum the numbers in the array' do
        test_array = num_array.my_inject('+')
        custom_array = num_array.inject('+')
        expect(test_array).to eql(custom_array)
      end
    end
  end
end
