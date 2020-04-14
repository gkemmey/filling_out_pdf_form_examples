module PDF
  module Layout
    extend ActiveSupport::Concern

    class Table
      attr_accessor :klass, :y, :offset

      def initialize(attributes = {})
        attributes.each { |name, value| send("#{name}=", value) }
      end

      def evaluate(&block)
        instance_eval(&block)
      end

      def define_fill_in_method(type, name, defaults_for_cell = {})
        _offset = defaults_for_cell.delete(:offset) || offset
        _y = defaults_for_cell.delete(:y) || y

        klass.send(:define_method, "fill_in_#{name}") do |value, row:|
          fill_in(value, **self.class.defaults,
                         **send("defaults_for_#{type}"),
                         **defaults_for_cell,
                         y: _y - (row * _offset))
        end
      end

      def method_missing(name, *args, &block)
        # is this a type defined by a call to cell_type? if so, it will have told the klass
        # to define this method.
        if klass.method_defined?("defaults_for_#{name}")
          # a little confusing, name here is the method name. for us, that's a cell_type.
          define_fill_in_method(name, *args)
        else
          super
        end
      end
    end

    included do
      class_attribute :defaults, instance_accessor: false
      self.defaults = {}
    end

    class_methods do
      def default_cell_height(value);    self.defaults[:height]    = value; end
      def default_cell_valign(value);    self.defaults[:valign]    = value; end
      def default_cell_overflow(value);  self.defaults[:overflow]  = value; end
      def default_cell_font_size(value); self.defaults[:font_size] = value; end

      def cell_type(type, type_defaults = {})
        define_method "defaults_for_#{type}" do
          type_defaults.dup
        end

        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def self.#{type}(name, defaults_for_cell = {})
            define_method "fill_in_\#{name}" do |value|
              fill_in(value, **self.class.defaults, **defaults_for_#{type}, **defaults_for_cell)
            end
          end
        RUBY
      end

      def table(y:, offset:, &block)
        Table.new(klass: self, y: y, offset: offset).evaluate(&block)
      end
    end

    def pdf
      raise NotImplementedError,
            "Osha::Pdf::Layout should be mixed in to a class that provides a pdf method"
    end

    def outline_text_boxes?
      true
    end

    def fill_in(value, options = {})
      _options = options.transform_values { |v| v.respond_to?(:call) ? v.call(options) : v }

      _options[:at] = [_options.delete(:x), _options.delete(:y)]
      _options[:size] = _options.delete(:font_size)

      if outline_text_boxes?
        pdf.stroke_color "4299e1" # #4299e1
        pdf.stroke_rectangle(_options[:at], _options[:width], _options[:height])
      end

      pdf.text_box(value.to_s, _options)
    end
  end
end
