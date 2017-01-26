module Weirdy
  class Wexception < ActiveRecord::Base
    has_many :occurrences, -> { order("happened_at DESC") }, class_name: "WexceptionOccurrence", dependent: :destroy

    STATE = {closed: 0, opened: 1, ignored: 2}

    scope :state, ->(state) { where(state: STATE[state.to_sym]) }

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
      Weirdy::Config.notifier_proc.call(Notifier.exception(wexception), wexception) if send_mail && Weirdy::Config.mail_recipients.present?
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

    def self.raised_in(backtrace)
      return nil if backtrace.blank?
      last_line = nil
      backtrace.each do |line|
        if self.application_line?(line)
          last_line = line
          break
        end
      end
      return nil if last_line.nil?
      raised_in = last_line.gsub(/:\d+:in\s+`/, "#").gsub("'", "")
      raised_in[(Rails.root.to_s.length + 1)..-1]
    end

    def self.application_line?(line)
      (line.include?(Rails.root.to_s) ||
      (Weirdy::Config.application_path_key.present? && line.include?(Weirdy::Config.application_path_key.to_s))) &&
      !line.include?("#{File::SEPARATOR}vendor#{File::SEPARATOR}")
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
