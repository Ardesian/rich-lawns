module Moddable
  extend ActiveSupport::Concern

  included do
    enum role: {
      customer: 0,
      admin:    100
    }

    self.defined_enums["role"].each do |initial_enum_str_val, initial_enum_int_val|
      define_singleton_method initial_enum_str_val do
        where("users.role >= ?", initial_enum_int_val || 0)
      end
      define_singleton_method "only_#{initial_enum_str_val}" do
        where("users.role = ?", initial_enum_int_val || 0)
      end
      define_method("only_#{initial_enum_str_val}?") do
        user_role_val = self.class.roles[self.role] || 0

        user_role_val == initial_enum_int_val
      end
      define_method("#{initial_enum_str_val}?") do
        user_role_val = self.class.roles[self.role] || 0

        user_role_val >= initial_enum_int_val
      end
    end
  end

  def become!(new_role); update(role: self.class.roles[new_role]); end
end
