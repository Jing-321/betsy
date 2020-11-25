require 'simplecov'
SimpleCov.start do
  add_filter 'test/'
  add_filter 'config/'
end


ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require "minitest/rails"
require "minitest/reporters"  # for Colorized output
#  For colorful output!
Minitest::Reporters.use!(
  Minitest::Reporters::SpecReporter.new,
  ENV,
  Minitest.backtrace_filter
)

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  # parallelize(workers: :number_of_processors) # causes out of order output.

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  #
  def setup
    OmniAuth.config.test_mode = true
  end

  def mock_auth_hash(user)
    return {
        provider: user.provider,
        uid:user.uid,
        info: {
            email: user.email,
            nickname: user.username
        }
    }
  end

  def perform_login(user = nil)
    user ||= User.first
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(user))
    get auth_callback_path(:github)

    user = User.find_by(uid: user.uid)
    expect(user).wont_be_nil

    expect(session[:user_id]).must_equal user.id
  end

  def add_first_item_to_cart
    order = Order.first
    product = Product.first
    order_item_data = {
        product_id: product.id, order_id: order.id, quantity: 1,
    }

    post order_items_path, params: order_item_data
    expect(session[:order_id]).must_equal order.id

    return order
  end
end
