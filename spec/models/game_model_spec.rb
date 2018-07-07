RSpec.describe Codebreaker::GameModel do
  describe 'validation game model' do
    it 'there are exceptions when saving' do
      expect { subject.save_score(nil, 4) }.to \
        raise_error(ArgumentError).with_message("Name can't be empty")
      expect { subject.save_score('test name', nil) }.to \
        raise_error(ArgumentError).with_message("Attempts can't be empty")
    end

    it 'there are no exceptions when saving' do
      expect { subject.save_score('test name', 4) }.not_to raise_error
    end

    it 'saved successfully' do
      subject.save_score('test name', 4)
      users = subject.load_score
      user = users['test name']
      
      expect(user[:name]).to eq 'test name'
      expect(user[:score]).to eq 4
    end

    it 'clear all' do
      subject.save_score('test name', 4)
      expect(subject.load_score).not_to be_empty
      subject.clear
      expect(subject.load_score).to be_empty
    end
  end
end