require 'active_support/core_ext/class/inheritable_attributes'

require 'authlogic'
require "authlogic_rpx/version"
require "authlogic_rpx/acts_as_authentic"
require "authlogic_rpx/session"
require "authlogic_rpx/session/validation"
require "authlogic_rpx/helper"
require "authlogic_rpx/rpx_identifier"

ActiveRecord::Base.send(:include, AuthlogicRpx::ActsAsAuthentic)
Authlogic::Session::Base.class_eval do
  include AuthlogicRpx::Session::Validation
  include AuthlogicRpx::Session
end
ActionController::Base.helper AuthlogicRpx::Helper
