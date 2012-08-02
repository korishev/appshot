require "appshot"
require 'awesome_print'

describe Appshot do

  let(:app) { Appshot.new("") }

  it "is a class" do
    described_class.should be_a_kind_of Class
  end

  it "has a method #appshot" do
    app.respond_to?(:appshot).should be_true
  end

  describe "#appshot" do
    it "should not add an appshot with an empty block" do
      app.appshot_count.should == 0
      app.appshot("my_account")
      app.appshot_count.should == 0
    end

    it "should add an appshot to the store" do
      app.appshot_count.should == 0
      app.appshot("my_account") {}
      app.appshot_count.should == 1
    end

    it "should add an appshot with the right name" do
      app.appshot("my_account") {}
      app.appshot_names.include?("my_account").should be_true
    end

    it "should accept a block" do
      app.appshot("my_account") do
        comment "my_account snapshot run"
      end
      app.appshots["my_account"].should_not be_nil
      app.appshots["my_account"].should be_a_kind_of(Proc)
    end
  end

  describe "#list_appshots" do
    context "with no appshots in config file" do
      it "should give a 'no appshots' message" do
        app.list_appshots.should == "There are no appshots configured"
      end
    end
    context "with one appshot in config file" do
      it "should give a 'one appshot' message" do
        app.appshot("one") {}
        app.list_appshots.should == "There is one appshot configured: one"
      end
    end
  end

  describe "running an appshot" do
    it "should run appshots" do
      app.appshot("my_account") do
        comment "my account snapshot execute"
      end
      app.execute_callables
    end

    it "should attempt to run unknown appshots" do
      app.appshot("my_account") do
        comment "This is a test"
        mysql name: "userdb", port: 1536, user: "pooky"
      end
      app.execute_callables
    end
  end
end
