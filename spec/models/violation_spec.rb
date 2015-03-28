require 'rails_helper'

RSpec.describe Violation, type: :model do
  describe '.from_policial' do
    it 'returns a set of violations for every message in the given violation' do
      policial_violation = double(
        filename: 'my/file.rb',
        line_number: 42,
        messages: ['single quotes, please', 'wrong indentation']
      )

      violation1, violation2 = Violation.from_policial(policial_violation)

      expect(violation1.filename).to eq('my/file.rb')
      expect(violation1.line_number).to eq(42)
      expect(violation1.message).to eq('single quotes, please')

      expect(violation2.filename).to eq('my/file.rb')
      expect(violation2.line_number).to eq(42)
      expect(violation2.message).to eq('wrong indentation')
    end
  end
end
