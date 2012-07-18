require 'appshot/app/mysql'
require 'awesome_print'

describe Appshot::Mysql do
  subject { Appshot::Mysql.new }
  it "should be a Mysql object" do
    subject.should be_a_kind_of Appshot::Mysql
  end

  it "should respond to #call" do
    subject.respond_to?(:call).should be_true
  end

  describe "#call method" do
    before do
      Mysql2::Client.stub(:new).and_return(mysql)
    end
    let(:mysql) { double(:mysql2, query: true) }

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

  describe "#lock method" do
    it "should issue the mysql command to 'flush tables with read lock'" do
      items = []
    end
  end

  describe "#unlock method" do
    pending
  end
end
