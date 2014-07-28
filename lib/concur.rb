module Concur
  @@suite = {}

  def self.add_validation(parent, clazz, validation_class)
    @@suite[parent] ||= {}
    @@suite[parent][clazz] = validation_class
  end

  def self.has_validation?(parent, clazz)
    !!@@suite.has_key?(parent) and @@suite[parent].has_key?(clazz)
  end

  def self.validate_classes(parent)
    classes = []
    if @@suite.has_key?(parent)
      classes = @@suite[parent].keys
    end
    classes
  end

  def self.validate_model(parent, model)
    if has_validation?(parent, model.class)
      validator = @@suite[parent][model.class].new(model)
      return validator.errors if validator.invalid?
    end
    nil
  end

  module ClassMethods
    def validation_for(clazz, &block)
      class_name = "#{name.gsub('::','')}#{clazz.name}Validator"
      validation_class = Object.const_set(class_name, Class.new(ModelValidator))
      validation_class.class_eval(&block)
      Concur.add_validation(self, clazz, validation_class)
    end

    def validate_model(model)
      Concur.validate_model(self, model)
    end

    def has_validation?(clazz)
      Concur.has_validation?(self, clazz)
    end

    def validate_classes
      Concur.validate_classes(self)
    end
  end

  class ModelValidator
    include ActiveModel::Validations

    def initialize(model)
      @model = model
    end

    def method_missing(name, *args, &block)
      path = name.to_s.split('__')
      value = @model
      path.each do |e|
        break unless value
        case value
          when Hash
            if value.has_key?(e) or value.has_key?(e.to_sym)
              value = value[e]||value[e.to_sym]
            else
              value = nil
            end
          when Array
            if value.length > e.to_i
              value = value[e.to_i]
            else
              value = nil
            end
          else
            return super(name, *args, &block) unless value.respond_to?(e)
            value = value.send(e)
        end
      end
      value
    end
  end

  def self.included(base)
    base.extend(ClassMethods)
  end
end
