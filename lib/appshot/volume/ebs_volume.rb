require_relative "../volume"
require 'fog'
require 'awesome_print'

class EBSVolume < Volume
  include Fog

  def initialize(fog_compute)
    @fog = fog_compute
  end

  def volumes
    @fog.volumes.all
  end

  def servers
    @fog.servers.all
  end

  def mocking?
    Fog.mocking?
  end

  def mock_reset
    @fog.reset
  end
end
