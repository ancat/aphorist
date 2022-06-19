require_relative 'aphorist'

RSpec.describe Aphorist do
  context 'with valid input and an empty environment' do
    it 'evals numeric literals' do
      parser = Aphorist.new
      expect(parser.eval(rule: '1')).to eq 1.0
      expect(parser.eval(rule: '1.0')).to eq 1.0
      expect(parser.eval(rule: '-1.0')).to eq -1.0
    end

    it 'evals string literals' do
      parser = Aphorist.new
      expect(parser.eval(rule: '"HELLO :)"')).to eq "HELLO :)"
    end

    it 'evals range literals' do
      parser = Aphorist.new
      expect(parser.eval(rule: '1..5')).to eq 1..5
    end

    it 'evals boolean literals' do
      parser = Aphorist.new
      expect(parser.eval(rule: 'true')).to eq true
      expect(parser.eval(rule: 'false')).to eq false
    end

    it 'evals null literals' do
      parser = Aphorist.new
      expect(parser.eval(rule: 'nil')).to eq nil
      expect(parser.eval(rule: 'null')).to eq nil
    end

    it 'does arithmetic' do
      parser = Aphorist.new
      expect(parser.eval(rule: '1 + 1')).to eq 2
      expect(parser.eval(rule: '1 - 1')).to eq 0
      expect(parser.eval(rule: '1 - -1')).to eq 2
      expect(parser.eval(rule: '1 + 1 + 1')).to eq 3
    end

    it 'does string comparisons' do
      parser = Aphorist.new
      expect(parser.eval(rule: '"HELLO" == "HELLO"')).to eq true
      expect(parser.eval(rule: '"HELLO" != "BYE"')).to eq true
    end

    it 'does regex comparisons' do
      parser = Aphorist.new
      expect(parser.eval(rule: '"GARBAGE" =~ "G.....E"')).to eq true
      expect(parser.eval(rule: '"GARBAGE" =~ "^G"')).to eq true
      expect(parser.eval(rule: '"127.0.0.1" =~ "[0-9]{1,3}([0-9]\.){3}"')).to eq true
    end
  end

  context 'with valid input and a populated environment' do
    it 'recognizes variables' do
      parser = Aphorist.new(default: {age: 9, name: "Dumpling"})
      expect(parser.eval(rule: '$age')).to eq 9
      expect(parser.eval(rule: '$name')).to eq "Dumpling"
    end

    it 'evals expressions that use variables' do
      parser = Aphorist.new(default: {age: 9, name: "Dumpling"})
      expect(parser.eval(rule: '$age == 9')).to eq true
      expect(parser.eval(rule: '$name == "Dumpling"')).to eq true
    end

    it 'retrieves properties of variables' do
      parser = Aphorist.new(default: {age: 9, name: "Dumpling"})
      expect(parser.eval(rule: '$name.length')).to eq 8
    end

    it 'executes methods' do
      parser = Aphorist.new(default: {age: 9, name: "Dumpling"}, methods: {random: ->() { 4 }})
      expect(parser.eval(rule: 'random() == 4')).to eq true
      expect(parser.eval(rule: 'random()')).to eq 4
    end
  end
end
