require 'appshot/filesystem/dm'

describe Appshot::DM do
  subject {
    Appshot::DM.any_instance.stub(validate_mount_point: true)
    Appshot::DM.new(mount_point: "/")
  }

  it { should be_a_kind_of Appshot::DM }
  it { subject.respond_to?(:call).should be_true }

  describe "#call" do
    it "should invoke #call on the next object in the call_chain" do
      Appshot::DM.any_instance.stub(:freeze).and_return(true)
      Appshot::DM.any_instance.stub(:unfreeze).and_return(true)
      items = [double(:appshot1), double(:appshot2)]
      items.first.should_receive(:call).with(items).and_return(true)
      subject.call(items)
    end

    it "should run #freeze and #unfreeze around a call being invoked" do
      Appshot::DM.any_instance.stub(validate_mount_point: true)
      first_dm = Appshot::DM.new(mount_point: "/tmp/fake_mount")
      first_dm.stub(:freeze).and_return(true)
      first_dm.stub(:unfreeze).and_return(true)
      items = [double(:appshot_dm)]
      items.first.should_receive(:call).with([]).and_return(true)
      first_dm.call(items)
    end

    it "should not allow root paths" do
      lambda{ Appshot::DM.new(mount_point: "/") }.should raise_error "We cannot currently unfreeze the root filesystem, leaving your system unusable. Aborting."
    end

    it "should verify that the given mount point exists and is actually a mount point" do
      lambda{ Appshot::DM.new(mount_point: "/tmp/fake_mount_for_appshot_testing") }.should raise_error "Your mount point: '/tmp/fake_mount_for_appshot_testing' is not a mount point!"
    end
  end
end
