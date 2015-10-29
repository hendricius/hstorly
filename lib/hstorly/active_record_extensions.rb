module Hstorly
  module ActiveRecordExtensions

    module ClassMethods

      def hstore_translate(*args)


        args.each do |attribute|

          # read the attribute from the hstore attribute and return it.
          #
          # returns the attribute or an empty string if the attribute is nil
          define_method attribute do
            (self[attribute] || {})[I18n.locale.to_s] || ""
          end

          # set the attribute on the model on the hstore hash
          #
          # returns the new value
          define_method "#{attribute}=" do |value|
            if self[attribute].present?
              write_attribute attribute, send(attribute).merge({I18n.locale => value })
              value
            else
              write_attribute attribute, {I18n.locale => value }
              value
            end
          end

          # returns the raw hstore directly
          define_method "#{attribute}_before_type_cast" do
            self[attribute] || {}
          end

          module_eval do
            serialize "#{attribute}", ActiveRecord::Coders::Hstore
          end if defined?(ActiveRecord::Coders::Hstore)


          # for each locale add a getter and setter method in the type of
          # title_de or title_en
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
