FactoryGirl.define do
  factory :wexception do
    kind "Exception"
    message "Something is really wrong"
    occurrences_count 0
    state 1 # open
    first_happened_at { Time.now }
    last_happened_at { Time.now }
  end
  
  factory :wexception_test do
    wexception
    backtrace ["/home/bruno/.rbenv/versions/1.9.2-p290/lib/ruby/1.9.1/irb/workspace.rb:80:in `eval'", "/home/bruno/.rbenv/versions/1.9.2-p290/lib/ruby/1.9.1/irb/workspace.rb:80:in `evaluate'"]
    #backtrace_hash "Something is really wrong"
    happened_at { Time.now }
    data {}
  end
end
