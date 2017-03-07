module Spree
  class CurrencyController < StoreController
    def set
      @currency = supported_currencies.find { |currency| currency.iso_code == params[:currency] }
      # Make sure that we update the current order, so the currency change is reflected.
      if current_order
        update_order(current_order)
      end
      session[:currency] = params[:currency] if Spree::Config[:allow_currency_change]
      respond_to do |format|
        format.json { render json: !@currency.nil? }
        format.html do
          # We want to go back to where we came from!
          redirect_back_or_default(root_path)
        end
      end
    end

    private

    def update_order(order)
      order.update_attributes!(currency: @currency.iso_code)
      order.updater.update_shipments
      order.updater.update_totals
      order.save!
    end
  end
end
