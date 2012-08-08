require 'appshot/app/mysql'
require 'mysql2'

describe Appshot::Mysql do
  subject { Appshot::Mysql.new }
  it { should be_a_kind_of Appshot::Mysql }
  it { subject.respond_to?(:call).should be_true }

  describe "#call" do
    before do
      Mysql2::Client.stub(:new).and_return(mysql)
    end
    let(:mysql) { double(:mysql2, query: true, close: true) }

    it "should require an argument to #call" do
      lambda { subject.call }.should raise_error(ArgumentError)
    end

    it "should invoke #call on the next object in the call_chain" do
      items = [double(:appshot1), double(:appshot2)]
      items.first.should_receive(:call).with(items).and_return(true)
      subject.call(items)
    end

    it "should run #lock before call is invoked" do
      items = [Appshot::Mysql.new, Appshot::Mysql.new]
      items.first.should_receive(:lock)
      subject.call(items)
    end

    it "should run #unlock after call is invoked" do
      items = [Appshot::Mysql.new, Appshot::Mysql.new]
      items.first.should_receive(:unlock)
      subject.call(items)
    end
  end
end
