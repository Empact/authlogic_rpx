module AuthlogicRpx
  module Session # :nodoc:
    # This is different from mainline Session::Base#valid? in that it does not
    # attempt to save_record on the attempted_record
    #
    # In a world without auto-registration the save, which seems to have been a
    # performance optimization (authlogic SHA: 198521b75d26143c43), would be unlikely
    # to produce show-stopper errors, but as RPX-driven auto-registration is
    # far less likely to generate valid objects (for example, they can easily violate uniqueness
    # constraints/validations), it is important not to save to avoid blowing up in these cases.
    module Validation
      def valid?
        errors.clear
        self.attempted_record = nil
        
        before_validation
        new_session? ? before_validation_on_create : before_validation_on_update
        validate
        ensure_authentication_attempted
                
        if errors.size == 0
          new_session? ? after_validation_on_create : after_validation_on_update
          after_validation
        end

        errors.size == 0
      end
    end
  end
end
