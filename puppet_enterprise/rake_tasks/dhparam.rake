require 'net/ssh'
require 'open3'
require 'vmfloaty'
require 'yaml'

#Rake task to replace files/console/dhparam_puppetproxy.pem file in puppetlabs-puppet_enterprise repo
#Run 'rake dhparam:generate_dhparam' from commandline to invoke the task
#Following environment variables needs to be set before running the task
#  PE_FAMILY          pe_family of agent to be installed
#  AGENT_VER          Agent version to be installed
#  REMOTE_REPO        Git remote repo where the changes need to be pushed
#  VMPOOLER_URL       pooler url (optional, default: https://vmpooler.delivery.puppetlabs.net/api/v1 )
#  TOKEN              Token string to connect to pooler(optional)
#  PUPPET_COLLECTION  puppet collection (optional, default: 'puppet6')
#VMPOOLER_URL and TOKEN values will be read from #HOME/.vmfloaty file if it is configured with a single service
#Example run:
#PE_FAMILY=2019.0 AGENT_VER=6.0.2 REMOTE_REPO='origin' VMPOOLER_URL='vmpooler url' TOKEN='your vmpooler token' rake dhparam:generate_dhparam
#

def check_env_var(env_var)
  value = ENV["#{env_var}"]
  if value.nil?
    STDERR.puts("#{env_var} is not set. Please set the variable before running the task")
    exit 1
  else
    value
  end
end

def run_cmd(cmd)
  stdout, status = Open3.capture2e(cmd)
  puts stdout
  if status != 0
    puts "Running command '#{cmd}' failed, exiting"
    exit 1
  end
  stdout
end

def get_pooler_conn_info
  url = ENV['VMPOOLER_URL'] || 'https://vmpooler.delivery.puppetlabs.net/api/v1'
  token = ENV['TOKEN']
  if token.nil?
    vmfloaty_config = ("#{Dir.home}/.vmfloaty.yml")
    if File.exists?(vmfloaty_config)
      config_data = YAML.load_file(vmfloaty_config)
      url, token = config_data.values_at("url", "token")
    end
  end
  if token.nil?
    puts "vmpooler token is not set in your environemnet"
    puts "Either set TOKEN value in the environement or create $HOME/.vmfloaty.yml with url, token values"
    exit 1
  end
  return url, token
end

def get_vm(platform, url, token)
  os_type = {platform => 1}
  pooler_output = Pooler.retrieve(nil, os_type, token, url)
  host_hash, domain = pooler_output.values_at(platform, "domain")
  hostname = host_hash["hostname"]
  vmhost = hostname+"."+domain
  vmhost
end

def delete_vm(url, host, token)
  Pooler.delete(nil, url, [host], token)
end

def ssh_exec(ssh, cmd)
  stdout_data = ""
  stderr_data = ""
  exit_code = nil
  puts cmd
  ssh.open_channel do |channel|
    channel.exec(cmd) do |ch, success|
      puts "Failed to execute cmd '#{cmd}" unless success
      channel.on_data do |ch,data|
        stdout_data+=data
      end
      channel.on_extended_data do |ch, type, data|
        stderr_data+=data
      end
      channel.on_request("exit-status") do |ch,data|
        exit_code = data.read_long
      end
    end
  end
  ssh.loop
  puts stdout_data
  puts stderr_data
  return exit_code
end

namespace :release do
  desc 'Generate dhparam_puppetproxy.pem file and create a PR'
  task :generate_dhparam do

    platform = "centos-7-x86_64"
    archive = 'puppet-agent-el-7-x86_64.tar.gz'
    puppet_collection = ENV['PUPPET_COLLECTION'] || 'puppet6'
    archive_path = "repos/el/7/#{puppet_collection}/x86_64"
    openssl_bin = '/opt/puppetlabs/puppet/bin/openssl'
    dh_file = 'dhparam_puppetproxy.pem'
    dh_path = 'files/console'
    pe_family = check_env_var('PE_FAMILY')
    agent_ver = check_env_var('AGENT_VER')
    remote_repo = check_env_var('REMOTE_REPO')
    download_url = "http://agent-downloads.delivery.puppetlabs.net/#{pe_family}/puppet-agent/#{agent_ver}/repos/#{archive}"

    url, token = get_pooler_conn_info
    vmhost = get_vm(platform, url, token)
    puts vmhost

    cmd_1 = "curl -O #{download_url}"
    cmd_2 = "tar xvf #{archive}"
    cmd_3 = "rpm -ivh #{archive_path}/puppet-agent*.rpm"
    cmd_4 = "#{openssl_bin} dhparam -out #{dh_file} 2048"

    puts "Installing agent on #{vmhost}. This may take some time..."

     connection = Net::SSH.start( "#{vmhost}", 'root' )
     [cmd_1, cmd_2, cmd_3, cmd_4].each do |cmd|
       exit_status = ssh_exec(connection, cmd)
       unless exit_status == 0
         puts "Execution failed for: #{cmd}"
         exit 1
       end
     end

     puts "Scping dhparam_puppetproxy.pem file from #{vmhost}"
     run_cmd("scp root@#{vmhost}:/root/#{dh_file} #{dh_path}/#{dh_file}")
     puts "Deleting vm #{vmhost}"
     delete_vm(url, vmhost,token)

     gitstatus =  run_cmd("git status")
     unless gitstatus.include?(dh_file)
       puts "No changes were detetcted for dhparam_puppetproxy.pem file when running 'git status'. Nothing to commit, exiting"
       exit 1
     end
     puts "Add updated file to git"
     run_cmd("git add #{dh_path}/#{dh_file}")
     puts "Commit changes"
     run_cmd("git commit -m 'Update dhparam_puppetproxy.pem file'")
     puts "push changes to remote"
     run_cmd("git push #{remote_repo}")
  end
end
