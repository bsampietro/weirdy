module Weirdy
  class Wexception < ActiveRecord::Base
    has_many :occurrences, class_name: "WexceptionOccurrence", order: "happened_at DESC"
  
    STATE = {closed: 0, open: 1}
    
    def self.wcreate(exception, data={})
      existing_wexception = self.where(kind: exception.class.name, message: exception.message).first
      if existing_wexception
        existing_wexception.occurrences_count += 1
        existing_wexception.last_happened_at = Time.zone.now
        existing_wexception.state = STATE[:open]
        existing_wexception.occurrences.build(exception_occurrence_hash(exception, data))
        existing_wexception.save!
        existing_wexception
      else
        wexception = self.new(
          kind: exception.class.name,
          message: exception.message,
          occurrences_count: 1,
          state: STATE[:open],
          first_happened_at: Time.zone.now,
          last_happened_at: Time.zone.now
        )
        wexception.occurrences.build(exception_occurrence_hash(exception, data))
        wexception.save!
        wexception
      end
    end
    
    def self.exception_occurrence_hash(exception, data)
      {
        backtrace: exception.backtrace,
        backtrace_hash: Digest::MD5.hexdigest(exception.backtrace.join('')),
        happened_at: Time.zone.now,
        data: data
      }
    end
  end
end
