require 'fog'

class Appshot
  class EBS_Volume
    include Fog

    attr_accessor :volume_id, :region
    attr_writer   :aws_access_key_id, :aws_secret_access_key
    attr_reader   :provider


    def initialize(opts = {})
      @provider = opts[:provider] || 'AWS'
      @region = opts[:region] || "us-east-1"
      @aws_access_key_id = opts[:aws_access_key_id] unless opts[:aws_access_key_id].nil?
      @aws_secret_access_key = opts[:aws_secret_access_key] unless opts[:aws_secret_access_key].nil?

      @fog = Fog::Compute.new(:provider => @provider,
                              :region => @region,
                              :aws_access_key_id => @aws_access_key_id,
                              :aws_secret_access_key => @aws_secret_access_key,
                             )
    end

    def volumes
      @fog.volumes.all
    end

    def snap(volume_id, description = "", options = {})
      @fog.snapshots.create({:volume_id => volume_id, :description => description}.merge(options))
    end

    def snapshots_for(volume_id)
      # for more info on Amazon EC2 filters (like "volume-id" below) please
      # refer to http://docs.amazonwebservices.com/AWSEC2/latest/APIReference/ApiReference-query-DescribeVolumes.html
      @fog.snapshots.all("volume-id" => volume_id)
    end

    #def prune_snapshots(volume_id, snapshots_to_keep, not_after_time = Time.now)
    def prune_snapshots(volume_id, options = {})
      snapshots_to_keep  = options[:snapshots_to_keep] || 3
      not_after_time     = options[:not_after_time] || Time.now
      snapshots          = snapshots_for(volume_id)

      (snapshots.count - snapshots_to_keep).times do
        snapshots.first.destroy if snapshots.first.created_at < not_after_time
        snapshots.reload
      end
    end

    def day_offset(days)
      return days if days.nil?
      Time.now - (days * 86400)
    end
    def days_to_seconds(days)
      days * 86400
    end
  end
end
