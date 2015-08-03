module ApplicationHelper

  class EventTracker
    def initialize
      @tracker = Mixpanel::Tracker.new("") #1b32058342e0f05fc3421a7aae5cbdab
    end

    def track(user, action, email_id, email_reference)
      @tracker.track(user, action,
                     {"email_id" => email_id, "email_reference" => email_reference, "user" => user})
      Event.create(user: user, action: action, email_id: email_id, email_reference: email_reference)
    end

  end

end
