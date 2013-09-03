module Weirdy
  class Wexception < ActiveRecord::Base
    has_many :occurrences, class_name: "WexceptionOccurrence", order: "happened_at DESC"
    
    attr_accessible :kind, 
                    :last_message, 
                    :occurrences_count, 
                    :state, 
                    :first_happened_at, 
                    :last_happened_at, 
                    :occurrences, 
                    :raised_in
  
    STATE = {closed: 0, opened: 1, ignored: 2}
    
    def self.wcreate(exception, data={})
      raise ArgumentError, "data argument should be a Hash" if !data.is_a? Hash
      existing_wexception = self.where(kind: exception.class.name, raised_in: self.raised_in(exception.backtrace)).first
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
          raised_in: self.raised_in(exception.backtrace),
        )
        wexception.occurrences.build(exception_occurrence_hash(exception, data))
        wexception.save!
      end
      Weirdy::Config.mail_sending_proc.call(Notifier.exception(wexception), wexception) if send_mail && Weirdy::Config.mail_recipients.present?
      return wexception
    end
    
    def self.exception_occurrence_hash(exception, data)
      {
        message: exception.message,
        backtrace: exception.backtrace,
        happened_at: Time.zone.now,
        data: data
      }
    end
    
    def self.state(state)
      where(state: STATE[state.to_sym])
    end
    
    def self.raised_in(backtrace)
      return nil if backtrace.blank? || Weirdy::Config.app_directories.blank?
      last_line = nil
      backtrace.each do |line|
        if self.application_line?(line)
          last_line = line
          break
        end
      end
      return nil if last_line.nil?
      raised_in = last_line.gsub(/:\d+:in\s+`/, "#").gsub("'", "")
      match_directory = nil
      Weirdy::Config.app_directories.to_a.each do |directory| 
        if raised_in.include? directory
          match_directory = directory
          break
        end
      end
      return raised_in if match_directory.nil?
      raised_in[raised_in.index(match_directory)..-1]
    end
    
    def self.application_line?(line)
      return false if Weirdy::Config.app_directories.blank?
      includes = false
      Weirdy::Config.app_directories.to_a.each do |directory|
        if line.include? directory
          includes = true
          break
        end
      end
      return includes
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
