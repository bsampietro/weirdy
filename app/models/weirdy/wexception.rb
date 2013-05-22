module Weirdy
  class Wexception < ActiveRecord::Base
    has_many :occurrences, class_name: "WexceptionOccurrence", order: "happened_at DESC"
    
    attr_accessible :kind, :message, :occurrences_count, :state, :first_happened_at, :last_happened_at, :occurrences
  
    STATE = {closed: 0, opened: 1, ignored: 2}
    
    def self.wcreate(exception, data={})
      existing_wexception = self.where(kind: exception.class.name, message: exception.message).first
      send_mail = true
      if existing_wexception
        existing_wexception.occurrences_count += 1
        existing_wexception.last_happened_at = Time.zone.now
        if existing_wexception.state?(:closed)
          existing_wexception.state = STATE[:opened]
        else
          send_mail = false
        end
        existing_wexception.occurrences.build(exception_occurrence_hash(exception, data))
        existing_wexception.save!
        wexception = existing_wexception
      else
        wexception = self.new(
          kind: exception.class.name,
          message: exception.message,
          occurrences_count: 1,
          state: STATE[:opened],
          first_happened_at: Time.zone.now,
          last_happened_at: Time.zone.now
        )
        wexception.occurrences.build(exception_occurrence_hash(exception, data))
        wexception.save!
      end
      Notifier.exception(wexception).deliver if send_mail && Weirdy::Config.mail_recipients.present?
      return wexception
    end
    
    def self.exception_occurrence_hash(exception, data)
      {
        backtrace: exception.backtrace,
        backtrace_hash: Digest::MD5.hexdigest(exception.backtrace.join('')),
        happened_at: Time.zone.now,
        data: data
      }
    end
    
    def state?(state)
      self.state == STATE[state]
    end
    
    def change_state(state)
      state = state.to_sym
      return unless state.in?(STATE.keys)
      self.update_attribute(:state, STATE[state])
    end
  end
end
