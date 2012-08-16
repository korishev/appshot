require 'appshot/app/mysql'
require 'mysql2'

describe Appshot::Mysql do
  it { should be_a_kind_of Appshot::Mysql }
  it { should respond_to(:call) }

  let(:mysql) { Appshot::Mysql.new }

  describe "#call" do
    before do
      Mysql2::Client.stub(:new).and_return(mysql)
      Appshot::Mysql.any_instance.stub(:lock).and_return(true)
      Appshot::Mysql.any_instance.stub(:unlock).and_return(true)
    end

    let(:callable1) { Appshot::Mysql.new }
    let(:callable2) { Appshot::Mysql.new }
    let(:items) { [ callable1, callable2 ] }

    it "should require an argument to #call" do
      lambda { mysql.call }.should raise_error(ArgumentError)
    end

    it "should invoke #call on the next object in the call_chain" do
      mysql.should_receive(:call).with(items).and_return(true)
      mysql.call(items)
    end

    it "should run #lock before call is invoked" do
      mysql.should_receive(:lock)
      mysql.call(items)
    end

    it "should run #unlock after call is invoked" do
      mysql.should_receive(:unlock)
      mysql.call(items)
    end
  end
end
