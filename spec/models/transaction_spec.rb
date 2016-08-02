require 'rails_helper'

RSpec.describe Transaction, type: :model do
  let(:transaction) { create(:transaction) }

  it { should validate_inclusion_of(:status).in_array(
      ['approved', 'rejected', 'pending']
    )
  }

  describe 'valid Model' do
    it 'should be an instance of User Model' do
      expect(transaction).to be_an_instance_of(Transaction)
    end
  end

  describe '#process_pain' do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }

    it 'must pass at least three elements' do
      expect(
        transaction.process_pain("", "1")
      ).to include("payments.ProcessPAIN: Not all data is present. Less than three datum passed.")
    end

    it 'fails when we do not get the pain_type' do
      expect(
        transaction.process_pain("token", "pain", "not a number")
      ).to include("payments.ProcessPAIN: PAIN type: 0 is not a valid.")
    end

    context 'case pain_type 1' do
      it 'there must be at least 9 elements' do
        expect(
          transaction.process_pain("token", "pain", "1")
        ).to include("payments.ProcessPAIN: Not all data is present.")
      end

      describe '#pain_credit_transfer_initiation' do
        it 'does something' do
          # token, "pain", "1", senderDetails, recipientDetails, amount, lat, lon, desc
          transaction.process_pain(
            "token",
            "pain",
            "1",
            user1.email,
            user2.email,
            "1100.01",
            "37.792",
            "-122.393",
            "desc text"
          )
        end
      end
    end

    context 'case pain_type 1000' do
      it 'there must be at least 8 elements' do
        # token~pain~type~amount~lat~lon~desc
        expect(
          transaction.process_pain("token", "pain", "1000", 1100.01, 37.792, -122.393)
        ).to include("payments.ProcessPAIN: Not all data is present.")
      end
    end

    context 'case pain_type 1001' do
      it 'there must be at least 5 elements' do
        # token~pain~type~page~perpage
        expect(
          transaction.process_pain("token", "pain", "1001", 1)
        ).to include("payments.ProcessPAIN: Not all data is present.")
      end
    end
  end

end
