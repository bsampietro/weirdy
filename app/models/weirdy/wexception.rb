module Weirdy
  class Wexception < ActiveRecord::Base
    serialize :backtrace
    
    has_many :occurrences, class_name: "WexceptionOccurrence", order: "happened_at DESC"
    
    attr_accessible :kind, 
                    :last_message, 
                    :occurrences_count, 
                    :state, 
                    :first_happened_at, 
                    :last_happened_at, 
                    :occurrences, 
                    :backtrace, 
                    :backtrace_hash
  
    STATE = {closed: 0, opened: 1, ignored: 2}
    
    def self.wcreate(exception, data={})
      raise ArgumentError, "data argument should be a Hash" if !data.is_a? Hash
      existing_wexception = self.where(kind: exception.class.name, backtrace_hash: self.backtrace_hash(exception.backtrace)).first
      send_mail = true
      if existing_wexception
        existing_wexception.occurrences_count += 1
        existing_wexception.last_happened_at = Time.zone.now
        existing_wexception.last_message = exception.message
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
          last_message: exception.message,
          occurrences_count: 1,
          state: STATE[:opened],
          first_happened_at: Time.zone.now,
          last_happened_at: Time.zone.now,
          backtrace: exception.backtrace,
          backtrace_hash: self.backtrace_hash(exception.backtrace)
        )
        wexception.occurrences.build(exception_occurrence_hash(exception, data))
        wexception.save!
      end
      Weirdy::Config.mail_sending_proc.call(Notifier.exception(wexception)) if send_mail && Weirdy::Config.mail_recipients.present?
      return wexception
    end
    
    def self.exception_occurrence_hash(exception, data)
      {
        message: exception.message,
        happened_at: Time.zone.now,
        data: data
      }
    end
    
    def self.state(state)
      where(state: STATE[state.to_sym])
    end
    
    def self.backtrace_hash(backtrace)
      return nil if backtrace.blank?
      Digest::MD5.hexdigest(backtrace.join(''))
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
