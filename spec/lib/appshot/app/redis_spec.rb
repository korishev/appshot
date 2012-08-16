require 'appshot/app/redis'

describe Appshot::Redis do
  it { should be_a_kind_of Appshot::Redis }
  it { should respond_to(:call) }

  let(:redis) { Appshot::Redis.new }

  describe "#call" do
    before do
      Appshot::Redis.any_instance.stub(:invoke_save).and_return(true)
    end
    let(:callable1) { Appshot::Redis.new }
    let(:callable2) { Appshot::Redis.new }
    let(:items) { [ callable1, callable2 ] }


    it "should require an argument to #call" do
      lambda { redis.call }.should raise_error(ArgumentError)
    end

    it "should invoke #call on the next object in the call_chain" do
      redis.should_receive(:call).with(items).and_return(true)
      redis.call(items)
    end

    describe "with save_before_snapshot" do
      context "set to false" do
        it "should not run #invoke_save" do
          redis.should_not_receive(:invoke_save)
          redis.call(items)
        end
      end
      context "set to true" do
        let(:redis) { Appshot::Redis.new(save_before_snapshot: true) }
        it "should run #invoke_save" do
          redis.should_receive(:invoke_save)
          redis.call(items)
        end
      end
    end
  end
end
