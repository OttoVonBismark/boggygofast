require 'test_helper'

class UserTest < ActiveSupport::TestCase
    def setup
        @user = User.new(name: "Example User", email: "user@example.com", password: 'foobar', password_confirmation: "foobar")
    end
    
    test "user should be valid" do
        assert @user.valid?
    end
    
    test "name should be present in user" do
        @user.name = ""
        refute @user.valid?
    end
    
    test "email should be present in user" do
        @user.email = ""
        refute @user.valid?
    end
    
    test "user name should not be too long" do
        @user.name = "a" * 51
        refute @user.valid?
    end 
    
    test "user email should not be too long" do
        @user.email = "a" * 244 + "@example.com"
        refute @user.valid?
    end
    
    test "user email validation should accept valid addresses" do
        valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
        valid_addresses.each do |valid_address|
            @user.email = valid_address
            assert @user.valid?, "#{valid_address.inspect} should be valid"
        end
    end
    
    test "user email validation should reject invalid addresses" do
        invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
        invalid_addresses.each do |invalid_address|
            @user.email = invalid_address
            refute @user.valid?, "#{invalid_address.inspect} should be invalid"
        end
    end
    
    test "user email addresses should be unique" do
        duplicate_user = @user.dup
        duplicate_user.email = @user.email.upcase
        @user.save
        refute duplicate_user.valid?
    end
    
    test "user email addresses should be saved as lower-case" do
        mixed_case_email = "Foo@ExAMPle.CoM"
        @user.email = mixed_case_email
        @user.save
        assert_equal mixed_case_email.downcase, @user.reload.email
    end
    
    test "user passwords should be present (non-blank)" do
        @user.password = @user.password_confirmation = " " * 6
        refute @user.valid?
    end
      
    test "user password should have a minimum length" do
        @user.password = @user.password_confirmation = "a" * 5
        refute @user.valid?
    end
    
    # Dude's logged in on two browsers, logs out on one, but not the other. User closes other browser and reopens. App thinks they're logged in, but
    # the remember_digest is nil from the first logout. Mass confusion. Let's simulate it! (Multi-session bug #2)
    test "user 'authenticated?' method should return false for a user with nil digest" do
        refute @user.authenticated?(:remember, '')
    end
end
