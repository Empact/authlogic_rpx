# requires test_helper to be loaded first

class BasicAuthenticationAndRegistrationTest < ActiveSupport::TestCase

  must "authenticate valid existing user" do
    test_user = users(:valid_rpx_auth_user_one)
    controller.params[:token] = test_user.login
    session = UserSession.new
    assert_true session.save, "should be a valid session"
    assert_false session.new_registration?, "should not be a new registration"
    assert_true session.registration_complete?, "registration should be complete"
    assert_equal test_user, session.record
  end
 
  must "do not authenticate invalidate non-existent user" do
    controller.params[:token] = ''
    session = UserSession.new
    assert_false session.save, "should not be a valid session"
  end

  must "mark an invalaid auto-registered user as registration_incomplete" do
    # enforce Authlogic settings required for test
    UserSession.auto_register true
    User.account_merge_enabled false
    User.account_mapping_mode :none

    # get response template. set the controller token (used by RPX mock to match mock response)
    test_user = rpxresponses(:unregistered_rpx_auth_user_one)
    controller.params[:token] = test_user.username
    stub.instance_of(User).valid? { false }
    # emulate constraint violation
    stub.instance_of(User).save_without_session_maintenance.with_any_args {|*args|
      raise "Kaboom" unless args.empty? || args.first
    }

    session = UserSession.new
    assert_true session.registration_incomplete?
  end

  must "auto-register an unregistered user" do
    # enforce Authlogic settings required for test
    UserSession.auto_register true
    User.account_merge_enabled false
    User.account_mapping_mode :none
    
    # get response template. set the controller token (used by RPX mock to match mock response)
    test_user = rpxresponses(:unregistered_rpx_auth_user_one)
    controller.params[:token] = test_user.username
    
    session = UserSession.new
    assert_false session.registration_incomplete?
    assert_true session.save, "should be a valid session"
    assert_true session.new_registration?, "should be a new registration"
    assert_true session.registration_complete?, "registration should be complete"
  end

  must "auto-register disabled for an unregistered user" do
    # enforce Authlogic settings required for test
    UserSession.auto_register false
    User.account_merge_enabled false
    User.account_mapping_mode :none
    
    # get response template. set the controller token (used by RPX mock to match mock response)
    test_user = rpxresponses(:unregistered_rpx_auth_user_one)
    controller.params[:token] = test_user.username
    
    session = UserSession.new
    assert_false session.registration_incomplete?
    assert_false session.save, "should not be a valid session"
  end

end