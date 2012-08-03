class Appshot
  class EBS_Prune
    def initialize(opts={})
      @volume_id = opts[:volume_id] || ""
      @snapshots_to_keep = opts[:snapshots_to_keep] || 5
      @minimum_retention_days = opts[:minimum_retention_days] || 3
      @region                = opts[:region] unless opts[:region].nil?
      @aws_secret_access_key = opts[:aws_secret_access_key] || ""
      @aws_access_key_id     = opts[:aws_access_key_id] || ""
    end

    def call(call_chain=[])
      next_action = call_chain.shift
      prune_snapshots if valid?
      next_action.call(call_chain) unless next_action.nil?
    end

    def valid?
      raise ArgumentError.new "volume_id must be specified for an ebs_prune" if @volume_id.empty?
      raise ArgumentError.new "aws_access_key_id must be specified for an ebs_prune" if @aws_access_key_id.empty?
      raise ArgumentError.new "aws_secret_access_key must be specified for an ebs_prune" if @aws_secret_access_key.empty?
      true
    end

    private

    def ebs_volume
      options = { aws_access_key_id: @aws_access_key_id, aws_secret_access_key: @aws_secret_access_key }
      options.update( { region: @region } ) if @region
      Appshot::EBS_Volume.new(options)
    end

    def prune_snapshots
      not_after_time = Time.now - (@minimum_retention_days * 86400)
      ebs_volume.prune_snapshots(@volume_id, snapshots_to_keep: @snapshots_to_keep, not_after_time: not_after_time )
    end
  end
end
