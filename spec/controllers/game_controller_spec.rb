require_relative '../../lib/codebreaker/controllers/game_controller.rb'
require 'spec_helper'

module Codebreaker
  RSpec.describe Codebreaker::Game do

    describe 'validation secret code' do
      let(:secret_code) { subject.instance_variable_get(:@secret_code) }
      before { subject.send(:generate_secret_code) }

      it 'generates secret code' do
        expect(secret_code).not_to be_empty
      end

      it 'saves 4 numbers secret code' do
        expect(secret_code.length).to eq LENGTH_OF_CODE
      end

      it 'secret code with numbers from 1 to 6' do
        secret_code.length { |char| expect(char.to_i).to match(/[1-6]+/) } 
      end
    end

    describe 'validation input secret code' do
      it 'input secret code' do
        expect(subject.send(:valid_secret_code?, "1344")).to eq true
        expect(subject.send(:valid_secret_code?, "12345")).to eq false
        expect(subject.send(:valid_secret_code?, "123")).to eq false
        expect(subject.send(:valid_secret_code?, "")).to eq false
      end
    end

    describe 'check a hint' do
      it 'show a hint' do
        expect(subject.send(:hint_result, 1, 2)).to eq("+--")
        expect(subject.send(:hint_result, 1, 1)).to eq("+-")
        expect(subject.send(:hint_result, 0, 2)).to eq("--")
        expect(subject.send(:hint_result, 3, 0)).to eq("+++")
      end
    end
    
  end
end