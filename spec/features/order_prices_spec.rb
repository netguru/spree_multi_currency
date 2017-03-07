RSpec.feature 'Order', :js do
  given!(:product) { create(:product) }
  let(:shipment) { create(:shipment, cost: 500.00) }
  let(:order) { create(:order_with_totals) }

  background do
    reset_spree_preferences do |config|
      config.supported_currencies   = 'USD,EUR,GBP'
      config.allow_currency_change  = true
      config.show_currency_selector = true
    end
    create(:price, variant: product.master, currency: 'EUR', amount: 16.00)
    create(:price, variant: product.master, currency: 'GBP', amount: 23.00)
  end

  context 'when existing in the cart' do
    scenario 'changes its currency, if user switches the currency.' do
      visit spree.product_path(product)
      click_button 'Add To Cart'
      expect(page).to have_text '$19.99'
      select 'EUR', from: 'currency'
      expect(page).to have_text '€16.00'
    end
  end

  context 'when contains shipment' do
    xit 'changes its currency, if user switches the currency.' do
      calc = create(:shipping_calculator_with_currency, currency: "USD")
      calc2 = create(:shipping_calculator_with_currency, amount: 5.00, currency: "EUR")
      shipment.shipping_methods << create(:shipping_method, calculator: calc)
      shipment.shipping_methods << create(:shipping_method, calculator: calc2)
      order.shipments << shipment
      order.update_column(:state, "payment")
      allow_any_instance_of(Spree::OrdersController).to receive_messages current_order: order
      visit cart_path
      select 'EUR', from: 'currency'
      expect(page).to have_text '€5.00'
    end
  end
end
