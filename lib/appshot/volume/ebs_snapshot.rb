require_relative "ebs_volume"

class Appshot
  class EBS_Snapshot
    def initialize(opts={})
      @volume_id             = opts[:volume_id] || ""
      @region                = opts[:region] unless opts[:region].nil?
      @aws_secret_access_key = opts[:aws_secret_access_key] || ""
      @aws_access_key_id     = opts[:aws_access_key_id] || ""
      @description           = opts[:description] || "Standard Snapshot #{Time.now.utc}"
    end

    def call(call_chain=[])
      next_action = call_chain.shift
      ebs_volume.snap(@volume_id, @description)
      next_action.call(call_chain) unless next_action.nil?
    end

    def validate
      raise ArgumentError.new "volume_id must be specified for an ebs_snapshot" if @volume_id.empty?
      raise ArgumentError.new "aws_access_key_id must be specified for an ebs_snapshot" if @aws_access_key_id.empty?
      raise ArgumentError.new "aws_secret_access_key must be specified for an ebs_snapshot" if @aws_secret_access_key.empty?
    end

private

    def ebs_volume
      options = { aws_access_key_id: @aws_access_key_id, aws_secret_access_key: @aws_secret_access_key }
      options.update( { region: @region } ) if @region
      Appshot::EBS_Volume.new(options)
    end
  end
end
