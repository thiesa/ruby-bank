FactoryGirl.define do
  factory :transaction do
    status %w(approved rejected pending).sample
  end

end
