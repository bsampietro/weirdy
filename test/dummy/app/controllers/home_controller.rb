class HomeController < ApplicationController
  def index
    #User.first.admin?
    methods = (1..10).to_a.map {|i| "met#{i}"}
    methods.each do |met|
      #self.class.send(:define_method, met) {raise "#{met} is wrong!"}
      User.send(:define_method, met) {raise "#{met} is wrong!"}
    end
    1.upto(10) do |i|
      #self.send(methods.sample)
      User.new.send(methods.sample)
    end
  end
end
