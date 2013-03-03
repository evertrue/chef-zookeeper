chef_gem "zookeeper" do
  action :install
end
 
require 'zookeeper'

def get_zk()
  # todo: memoize
  return Zookeeper.new(@new_resource.zk_connection)
end


action :create_if_missing do
  zk = get_zk()
  return if zk.stat(:path => @new_resource.path)[:stat].exists
  zk.create(:path => @new_resource.path, :data => @new_resource.data)
end

action :create do
  zk = get_zk()
  if zk.stat(:path => @new_resource.path)[:stat].exists
    zk.set(:path => @new_resource.path, :data => @new_resource.data)
  else
    zk.create(:path => @new_resource.path, :data => @new_resource.data)
  end
end
 
action :delete do
  zk = get_zk()
  zk.delete(:path => @new_resource.path)
end
