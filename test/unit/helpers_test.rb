require File.dirname(__FILE__) + '/../test_helper.rb'

class HelpersTest < ActiveSupport::TestCase
  class HelpersContext
    def form_authenticity_token
      'foo'
    end

    def u(something)
      something
    end

    include AuthlogicRpx::Helper
  end

  must "generate a return url with an authenticity token" do
    assert_true HelpersContext.new.send(:build_token_url!, :return_url => '/').include?('/?authenticity_token=')
  end

  must "not repeat ? when params exist" do
    assert_equal 1, HelpersContext.new.send(:build_token_url!, :return_url => '/?myparam=bar').count('?')
  end
end
