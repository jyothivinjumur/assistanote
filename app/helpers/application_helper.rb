module ApplicationHelper

  class EventTracker
    def initialize
      @tracker = Mixpanel::Tracker.new("52ea6d03703dfe892e0cb9e8eaf16cfb")
    end

    def track(user, action, email_id, email_reference)
      @tracker.track(user, action,
                     {"email_id" => email_id, "email_reference" => email_reference, "user" => user})
      Event.create(user: user, action: action, email_id: email_id, email_reference: email_reference)
    end

  end

end
