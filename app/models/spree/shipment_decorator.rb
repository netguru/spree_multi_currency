module Spree
  Shipment.class_eval do
    def refresh_rates(shipping_method_filter = ShippingMethod::DISPLAY_ON_FRONT_END)
      return shipping_rates if shipped?
      return [] unless can_get_rates?

      # StockEstimator.new assigment below will replace the current shipping_method
      original_shipping_method_id = shipping_method.try(:id)

      self.shipping_rates = Stock::Estimator.new(order).
      shipping_rates(to_package, shipping_method_filter)

      if shipping_method
        selected_rate = shipping_rates.detect { |rate|
          rate.shipping_method_id == original_shipping_method_id
        }
        if selected_rate
          self.selected_shipping_rate = selected_rate
          self.selected_shipping_rate_id = selected_rate.id
        else
          self.selected_shipping_rate = shipping_rates.first
          self.selected_shipping_rate_id = shipping_rates.first.id
        end
      end
      shipping_rates
    end
  end
end
