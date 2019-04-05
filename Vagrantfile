# -*- mode: ruby -*-
# vi: set ft=ruby :

###########################################################
## 各自の環境にあわせて、設定してください
# 仮想環境で動作させたいプログラムのパス
# SAMPLE_REPOSITORY_PATH = "/Users/sog/workspace/sample"
SAMPLE_REPOSITORY_PATH = "../../workspace/sample"
###########################################################

vb_memory = 2048
vb_cpus = 2

Vagrant.require_version ">= 2.2.0"

# Make sure the vagrant-vbguest plugin is installed
required_plugins = %w(vagrant-vbguest vagrant-hostsupdater)

plugins_to_install = required_plugins.select { |plugin| not Vagrant.has_plugin? plugin }
if not plugins_to_install.empty?
  puts "Installing plugins: #{plugins_to_install.join(' ')}"
  if system "vagrant plugin install #{plugins_to_install.join(' ')}"
    exec "vagrant #{ARGV.join(' ')}"
  else
    abort "Installation of one or more plugins has failed. Aborting."
  end
end

# 設定情報確認
if not Dir.exist?(SAMPLE_REPOSITORY_PATH)
  abort "SAMPLE_REPOSITORY_PATH が存在しません。設定を確認してください。"
end

Vagrant.configure("2") do |config|
  config.vm.box = "bento/centos-7.6"

  config.vm.define "sample" do |sample|
    sample.vm.network "private_network", ip: "192.168.40.22"
    sample.hostsupdater.aliases = ["sample-local7.dev.jp","dummy-login.dev.jp"]
    sample.vm.synced_folder '.', '/vagrant', owner: "root", group: "root", mount_options: ['dmode=777','fmode=777']

    # 21_sample
    sample.vm.synced_folder SAMPLE_REPOSITORY_PATH, "/home/www/sample.dev.jp",
      mount_options: ['dmode=777','fmode=777']

    # 91_devTools 参考にするため残しとく
    # sample.vm.synced_folder SAMPLE_REPOSITORY_PATH+"/devTools", "/home/devTools",
    #   mount_options: ['dmode=777','fmode=777']

    sample.vm.provider "virtualbox" do |vb|
      vb.name = "sample-local7"
      vb.memory = vb_memory
      vb.cpus = vb_cpus
      vb.customize ["modifyvm", :id, "--ioapic", "on"]
      vb.customize ['modifyvm', :id, '--cableconnected1', 'on']
      vb.customize ["setextradata", :id, "VBoxInternal/Devices/VMMDev/0/Config/GetHostTimeDisabled", 0]
      vb.customize ["guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 1000]
    end

    sample.vm.provision "shell", privileged: true, path: "provision.sh"
    sample.vm.provision "shell", privileged: true, run: "always", path: "provision_always.sh"
  end
end
