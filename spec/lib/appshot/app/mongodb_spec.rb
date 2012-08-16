require 'appshot/app/mongodb'

describe Appshot::MongoDB do
  it { should be_a_kind_of Appshot::MongoDB }
  it { should respond_to(:call) }

  let(:callable1) { Appshot::MongoDB.new }
  let(:callable2) { Appshot::MongoDB.new }
  let(:items) { [ callable1, callable2 ] }
  let(:mongo) { Appshot::MongoDB.new }

  describe "#call" do
    before do
      Appshot::MongoDB.any_instance.stub(:lock).and_return(true)
      Appshot::MongoDB.any_instance.stub(:unlock).and_return(true)
    end
    it "should require an argument to #call" do
      lambda { mongo.call }.should raise_error(ArgumentError)
    end
    it "should invoke #call on the next object in the call_chain" do
      callable1.should_receive(:call).with(items)
      mongo.call(items)
    end

    it "should run #lock before call is invoked" do
      callable1.should_receive(:call).with([callable2])
      mongo.should_receive(:lock)
      mongo.call(items)
    end

    it "should run #unlock after call is invoked" do
      callable1.should_receive(:call).with([callable2])
      mongo.should_receive(:unlock)
      mongo.call(items)
    end
  end
end
