FactoryGirl.define do
  factory :goal do
    title "Learn to code"
    description "Be 10x engineer"
    user_id 1
    target_date { Date.today + rand(1...50).days }
    public_goal { [true, false].sample }
  end
end
