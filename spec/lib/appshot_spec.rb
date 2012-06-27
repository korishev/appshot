require "appshot"

describe Appshot do

  let(:app) { Appshot.new }

  it "is a class" do
    described_class.should be_a_kind_of Class
  end

  it "#appshot" do
   app.respond_to?(:appshot).should be_true
  end

	describe "command line arguments"
end
