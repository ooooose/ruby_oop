module Domain
  module Entities
    class User
      attr_reader :id, :name, :age, :email

      def initialize(id:, name:, age:, email:)
        @id = id
        @name = name
        @age = age
        @email = email
      end
    end
  end
end
