require "minitest/autorun"
require_relative "../../../app/domain/entities/user"

module Domain
  module Entities
    class UserTest < Minitest::Test
      def test_user_can_be_created
        user = User.new(
          id: 1,
          name: "Taro",
          age: 20,
          email: "taro@example.com"
        )

        assert_equal 1, user.id
        assert_equal "Taro", user.name
        assert_equal 20, user.age
        assert_equal "taro@example.com", user.email
      end
    end
  end
end
