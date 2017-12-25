require_relative '../../lib/codebreaker/game_controller.rb'

RSpec.describe Codebreaker::Game do
  describe 'validation secret code' do
    let(:secret_code) { subject.instance_variable_get(:@secret_code) }
    before { subject.send(:start) }

    it 'generates secret code when game started' do
      expect(secret_code).not_to be_empty
    end

    it 'saves 4 numbers secret code' do
      expect(secret_code.length).to eq CODE_LENGTH
    end

    it 'secret code with numbers from 1 to 6' do
      secret_code.length { |char| expect(char.to_i).to match(/[1-6]+/) } 
    end

    it 'input secret code' do
      expect(subject.send(:valid_secret_code?, '1344')).to eq true
      expect(subject.send(:valid_secret_code?, '12345')).to eq false
      expect(subject.send(:valid_secret_code?, '123')).to eq false
      expect(subject.send(:valid_secret_code?, '')).to eq false
    end
  end

  describe 'check a hint' do
    it '#aguessed_hint' do
      expect(subject.send(:guessed_hint, '1234', '1325')).to \
        eq(code: '1325', matching: '+--')
      expect(subject.send(:guessed_hint, '1234', '1365')).to \
        eq(code: '1365', matching: '+-')
      expect(subject.send(:guessed_hint, '1234', '6643')).to \
        eq(code: '6643', matching: '--')
      expect(subject.send(:guessed_hint, '1234', '1235')).to \
        eq(code: '1235', matching: '+++')
      expect(subject.send(:guessed_hint, '1234', '5566')).to eq nil
    end
  end
end