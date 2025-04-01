require 'rspec'

def add(numbers)
  return 0 if numbers.empty?

  delimiters = [',', "\n", '%']
  if numbers.start_with?("//")
    custom_delimiter = numbers[2]
    delimiters << custom_delimiter
    numbers = numbers.split("\n", 2)[1]
  end
  numbers.split(Regexp.union(delimiters)).map(&:to_i).tap do |nums|
    negatives = nums.select(&:negative?)
    raise "negatives not allowed: #{negatives.join(',')}" unless negatives.empty?
  end.sum
end

describe 'add' do
  it 'returns 0 for an empty string' do
    expect(add("")).to eq(0)
  end

  it 'returns the number for a single number string' do
    expect(add("1")).to eq(1)
    expect(add("10")).to eq(10)
  end

  it 'returns the sum of two comma-separated numbers' do
    expect(add("1,2")).to eq(3)
    expect(add("10,20")).to eq(30)
  end

  it 'returns the sum of multiple comma-separated numbers' do
    expect(add("1,2,3")).to eq(6)
    expect(add("1,2,3,4,5")).to eq(15)
  end

  it 'handles newlines as delimiters' do
    expect(add("1\n2,3")).to eq(6)
  end

  it 'handles custom delimiters' do
    expect(add("//;\n1;2")).to eq(3)
    expect(add("//%\n1%2%3")).to eq(6)
  end

  it 'raises an error for negative numbers' do
    expect { add("1,-2,3") }.to raise_error("negatives not allowed: -2")
    expect { add("-1,-2,-3") }.to raise_error("negatives not allowed: -1,-2,-3")
  end
end