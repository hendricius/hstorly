module Hstorly
  module ActiveRecordExtensions

    module ClassMethods

      def hstore_translate(*args)


        args.each do |attribute|

          define_method attribute do
            (self[attribute] || {})[I18n.locale.to_s] || ""
          end

          define_method "#{attribute}=" do |value|
            if self[attribute].present?
              write_attribute attribute, send(attribute).merge({I18n.locale => value })
            else
              write_attribute attribute, {I18n.locale => value }
            end
          end

          define_method "#{attribute}_before_type_cast" do
            self[attribute] || {}
          end

          module_eval do
            serialize "#{attribute}", ActiveRecord::Coders::Hstore
          end if defined?(ActiveRecord::Coders::Hstore)


          I18n.available_locales.map(&:to_s).each do |locale|

            define_method "#{attribute}_#{locale}" do
              (self[attribute] || {})[locale] || ""
            end

            define_method "#{attribute}_#{locale}=" do |value|
              if self[attribute].present?
                write_attribute attribute, self[attribute].merge({locale => value })
              else
                write_attribute attribute, {locale => value }
              end
            end

          end
        end
      end


    end

  end
end

ActiveRecord::Base.extend Hstorly::ActiveRecordExtensions::ClassMethods
