class NotifierJob < Struct.new(:wexception)
  def perform
    Weirdy.notify_exception(wexception)
  end
end
