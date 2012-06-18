require "spec_helper"
require "appshot"
require "appshot/volume"
require "appshot/volume/ebs_volume"

# the ebs class should be able to:
# list all volumes
# snapshot a volume
# delete a snapshot

describe EBSVolume do
  def create_server(zone = "us-east-1" + %w(a b c d).sample)
    delay = Fog::Mock.delay
    puts "Mock delay = #{delay}"
    Fog::Mock.delay = 0
    current_server_count = fog_compute.servers.all.count
    new_server = fog_compute.servers.create
    new_server.reload.id
    Fog::Mock.delay = delay
  end

  before do
    Fog::Compute::AWS::Mock.reset
    Fog.mock!
  end

  let(:fog_compute) do
    Fog::Compute.new(:provider => 'AWS',
                     :region => region,
                     :aws_access_key_id => aws_access_key_id,
                     :aws_secret_access_key => aws_secret_access_key,
                    )
  end
  let(:ebs) { described_class.new(fog_compute) }
  let(:region) { "us-east-1" }
  let(:aws_access_key_id) { "access_key_shhh" }
  let(:aws_secret_access_key) { "secret_key_shhh" }

  describe "basics" do
    it "should be a class" do
      described_class.should be_a_kind_of Class
    end
  end


  describe "manipulating EBS volumes" do
    context "Mock.delay == 3" do
      Fog::Mock.delay = 3

      it "must not return until the volume is available" do
        create_server
        ebs.servers.count.should == 1
      end
    end

    context "Mock.delay == 0" do
      Fog::Mock.delay = 0

      it "should create three servers" do
        3.times { create_server }
        ebs.servers.count.should == 3
      end
    end
  end
end
