require "spec_helper"
require "appshot"
require "appshot/volume"
require "appshot/volume/ebs_volume"
require "timecop"

describe Appshot::EBS_Volume do
  before do
    Fog::Compute::AWS::Mock.reset
    Fog.mock!
  end

  let(:ebs) { described_class.new(:provider => 'AWS',
                                  :region => region,
                                  :aws_access_key_id => aws_access_key_id,
                                  :aws_secret_access_key => aws_secret_access_key,
                                 ) }
  let(:fog_compute) { ebs.instance_variable_get(:@fog)  }
  let(:region) { "us-east-1" }
  let(:aws_access_key_id) { "access_key_shhh" }
  let(:aws_secret_access_key) { "secret_key_shhh" }

  describe "basic setup" do
    it "should be a class" do
      described_class.should be_a_kind_of Class
    end

    it "should have a volume_id" do
      ebs.respond_to?(:volume_id).should be_true
    end
  end

  describe "given a volume_id" do
    let(:snapshot_count) { 2 }
    let(:volume_id)  { volumes.first.id }

    let(:volumes) do
      with_no_mock_delay do
        [ create_volume("us-east-1a"),
          create_volume("us-east-1b"), ]
      end
    end

    let(:snaps) do
      with_no_mock_delay do
        snapshot_count.times do |i|
          ebs.snap(volume_id, "This is test snapshot ##{i}")
        end
        ebs.snapshots_for(volume_id)
      end
    end

    it "should create a snap id with a valid format" do
      snaps.first.id.should =~ /^snap-*/
    end

    it "must finish a snapshot of the volume" do
      snaps.first.state.should == "completed"
    end

    it "should know how many snapshots there are for a given volume" do
      snaps
      ebs.snapshots_for(volumes.first.id).count.should == 2
      ebs.snapshots_for(volumes.last.id).count.should == 0
    end

    describe "pruning snapshots" do
      context "with a minimum age" do
        let(:snapshot_count) { 5 }

        it "should not prune snapshots younger than the minimum age" do
          with_no_mock_delay do
            Timecop.freeze(Time.now - (3 * 86400))
            ebs.snap(volume_id, "This is test snapshot #2")
            Timecop.freeze(Time.now + 86400)
            ebs.snap(volume_id, "This is test snapshot #3")
            Timecop.freeze(Time.now + 86400)
            ebs.snap(volume_id, "This is test snapshot #4")
            Timecop.return
          end
          ebs.snapshots_for(volumes.first.id).count.should == 3
          ebs.prune_snapshots(volumes.first.id, snapshots_to_keep: 1, not_after_time: Time.now - (3 * 86400))
          ebs.snapshots_for(volumes.first.id).count.should == 2
        end
      end

      context "without a minimum age" do
        let(:snapshot_count) { 3 }

        it "should prune snapshots for a given volume to a snapshot count" do
          snaps
          ebs.snapshots_for(volumes.first.id).count.should == 3
          ebs.prune_snapshots(volumes.first.id, snapshots_to_keep: 1)
          ebs.snapshots_for(volumes.first.id).count.should == 1
        end
      end
    end
  end
end

private

def create_server(zone = "us-east-1" + %w(a b c d).sample)
  with_no_mock_delay do
    new_server = fog_compute.servers.create
    new_server.reload.id
  end
end

def create_volume(zone = "us-east-1" + %w(a b c d).sample, size = 20)
  with_no_mock_delay do
    new_volume = fog_compute.volumes.create(:availability_zone => zone, :size => size)
    new_volume.reload
  end
end

def with_no_mock_delay
  delay = Fog::Mock.delay
  Fog::Mock.delay = 0
  return_object = yield
  Fog::Mock.delay = delay
  return_object
end


