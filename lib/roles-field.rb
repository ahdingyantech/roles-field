# coding: utf-8
module RolesField
  module Base
    extend ActiveSupport::Concern

    included do
      ROLES_FIELD_CONFIG = {}
    end

    module ClassMethods
      def roles_field(field, options={})
        roles = options[:roles]

        class_eval %(
          def roles=(roles)
            self.#{field} = (#{roles} & roles).map { |role| 
              2 ** #{roles}.index(role.to_sym)
            }.sum
          end

          def roles
            #{roles}.reject { |role| 
              ((#{field} || 0) & 2 ** #{roles}.index(role.to_sym)).zero?
            }
          end

          def role?(role)
            roles.include? role.to_sym
          end

          def role
            roles.first
          end

          def role=(role)
            self.roles = (#{roles} & [role.to_sym])
          end

          def set_role(role)
            self.role = role
          end

          scope :with_role, lambda { |role| 
            {
              :conditions => ['#{field} & ? > 0', 2 ** #{roles}.index(role.to_sym)]
            }
          }
        )

        roles.each do |role|
          define_method "is_#{role}?" do
            role? role
          end
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, RolesField::Base