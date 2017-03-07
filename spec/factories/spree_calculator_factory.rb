FactoryGirl.define do
  factory :shipping_calculator_with_currency, class: Spree::Calculator::Shipping::FlatRate do
    ignore do
      amount 10.0
      currency "USD"
    end

    after(:create) do |c, evaluator|
      c.set_preference(:amount, evaluator.amount)
      c.set_preference(:currency, evaluator.currency)
    end
  end
end
