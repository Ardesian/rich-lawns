module Dollarable
  extend ActiveSupport::Concern

  included do
    def self.dollarable(penny_column, dollar_column)
      define_method(dollar_column) do
        pennies_to_dollars(send(penny_column))
      end

      define_method("#{dollar_column}=") do |new_dollars|
        send("#{penny_column}=", (new_dollars.to_f * 100))
      end
    end

    def self.pennies_to_dollars(pennies)
      return unless pennies.present?
      dollars = (pennies.to_i / 100.to_f).round(2)
      dollars == dollars.to_i ? dollars.round : dollars
    end

    delegate :pennies_to_dollars, to: :class
  end

end
