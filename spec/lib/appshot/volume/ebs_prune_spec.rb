require "appshot/volume/ebs_prune"

describe Appshot::EBS_Prune do
  subject { Appshot::EBS_Prune.new }

  it { should be_a_kind_of Appshot::EBS_Prune }
  it { subject.respond_to?(:call).should be_true }

  it "should invoke #call on the next object in the call_chain" do
    next_item = [double(:appshot)]
    subject.should_receive(:call).with(next_item).and_return(true)
    subject.call(next_item)
  end
  describe "validating arguments" do
    let(:opts) { { volume_id: "vol-eba11eee", snapshots_to_keep: 10, minimum_retention_days: 5 } }
    subject { Appshot::EBS_Prune.new(final_opts) }

    context "with no volume_id" do
      let(:final_opts) { opts.delete_if { |k,v| k == :volume_id } }
      it "requires a volume_id argument" do
        lambda { subject.valid? }.should raise_error ArgumentError, "volume_id must be specified for an ebs_prune"
      end
    end
  end
end
