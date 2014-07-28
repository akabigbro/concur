require 'test/unit'
require 'concur'

class ConcurTest < Test::Unit::TestCase
  class Person
    attr_accessor :name, :addresses, :birth, :gender

    def initialize(attributes = {})
      attributes.each do |name,value|
        send("#{name}=", value)
      end
    end
  end

  class PersonValidator < Concur::ModelValidator
    validates_presence_of :name__first
    validates_presence_of :name__last
    validates_presence_of :birth
    validates_presence_of :gender
    validates_presence_of :addresses__primary__lines__0
    validates_presence_of :addresses__primary__city
    validates_presence_of :addresses__primary__state
    validates_presence_of :addresses__primary__postal_code
  end

  class Testing
    include Concur

    validation_for Person do
      validates_presence_of :name__first
      validates_presence_of :name__last
      validates_presence_of :birth
      validates_presence_of :gender
      validates_presence_of :addresses__primary__lines__0
      validates_presence_of :addresses__primary__city
      validates_presence_of :addresses__primary__state
      validates_presence_of :addresses__primary__postal_code
    end
  end

  def setup
    @person = Person.new(
        name: {
            first: 'John',
            last: 'Doe'
        },
        addresses: {
            primary: {
                lines: ['123 Main St'],
                city: 'Grants Pass',
                state: 'Oregon',
                postal_code: '97536'
            }
        },
        birth: '1973-05-20',
        gender: 'M'
    )

    @validator = PersonValidator.new(@person)
    assert @validator.valid?
  end

  test 'person first name' do
    @person.name.first = nil
    assert @validator.invalid?
  end

  test 'person last name' do
    @person.name.last = nil
    assert @validator.invalid?
  end

  test 'person address line 0' do
    @person.addresses[:primary].lines = []
    assert @validator.invalid?
  end

  test 'person address' do
    @person.addresses = {}
    assert @validator.invalid?
  end

  test 'person birth' do
    @person.birth = nil
    assert @validator.invalid?
  end

  test 'suite class validators' do
    assert Testing.has_validation?(Person)
    classes = Testing.validate_classes
    assert_kind_of Array, classes
    assert classes.include?(Person), classes.inspect
  end
end
