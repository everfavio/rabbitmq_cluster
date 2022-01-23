hosts = [
  {name: 'node01', ip: '192.168.40.10'},
  {name: 'node02', ip: '192.168.40.11'},
  {name: 'node03', ip: '192.168.40.12'}
]
Vagrant.configure('2') do |config|
  hosts.each do |host|
    config.vm.define host[:name] do |node|
      node.ssh.insert_key = false
      node.vm.network :private_network, ip: host[:ip]
      node.vm.box = "bento/ubuntu-20.04"
      node.disksize.size = "20GB"
      node.vm.boot_timeout = 5000
      node.vm.provision :shell, path: "bootstrap.sh"
      node.vm.hostname = host[:name]
      node.vm.provider :virtualbox do |vb|
        vb.gui = false
        vb.customize ["modifyvm", :id, "--memory", "4048"]
        vb.customize ["modifyvm", :id, "--cpus", "2"]
      end
    end
  end
end
