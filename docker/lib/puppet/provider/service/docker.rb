require 'json'

Puppet::Type.type(:service).provide(:docker, :parent => :base) do
    desc "Manage Docker"
    #I want to extend puppet service to support docker

    commands :docker => "docker"

    #confine :any => [
        #some code here to see if docker in installed
    #]

    has_feature :enableable
    has_feature :refreshable

    def self.instances
        self.debug 'instances'
        i = []
        output = docker('ps', '-a', '-q').split("\n")
        output.each do |container|
            inspect = JSON.parse(docker('inspect', container))
            n = inspect[0]['Name'].gsub(/\//, '')
            i << new(:name => n)
        end
        return i
    rescue Puppet::ExecutionFailure
        return []
    end

    def status
        self.debug "get status for each container by name"
        cont = Hash.new
        output = docker('ps', '-a', '-q').split("\n")
        output.each do |container|
            inspect = JSON.parse(docker('inspect', container))
            n = inspect[0]['Name'].gsub(/\//, '')
            self.debug "Name is: #{n}"
            self.debug "State => Running : #{inspect[0]['State']['Running']}"
            cont[n] = Hash.new
            cont[n]['status'] = inspect[0]['State']['Running']
            cont[n]['id'] = container
            self.debug "Status is #{cont[n]['status']}"
            self.debug "ID is #{cont[n]['id']}"
        end

        self.debug "Cheking status for #{@resource[:name]}"
        if cont.has_key?(@resource[:name])
            self.debug 'found container'
            #container created
            if cont[@resource[:name]]['status']
                self.debug 'container is running'
                #container is running
                return :running
            else
                self.debug 'container is stopped'
                #container is stopped
                return :stopped
            end
        else
            self.debug 'did not find container'
            #this is disabled, i.e. the container has not been created
            return :disabled
        end
    end

    def enabled?
        self.debug 'enabled?'
        status = self.status

        if status === :disabled
            self.debug 'returned :disabled'
            return :false
        else
            self.debug 'returned :running or stopped'
            return :true
        end
    end

    def enable
        self.debug 'enable'
        #Read in the "manifest" file.
        #I wish docker create/run could just read options from a file.
        #Since it can't we will read a file with the options
        #use --option=value - one per line
        #no spaces
        opts = []
        File.open(resource[:manifest], "r") do |f|
            f.each_line do |line|
                l = line.chomp()
                if l.to_s != ''
                    opts.push(l)
                end
            end
        end
        opts.unshift('create')
        docker(opts)
        self.start
    end

    def disable
        self.debug 'disable'
        docker("rm", @resource[:name])
    end

    def start
        self.debug 'start'
        status = self.status
        if status === :disabled
            self.enable
        end
        docker("start", @resource[:name])
    end

    def stop
        self.debug 'stop'
        docker("stop", @resource[:name])
    end

    def restart
        self.debug 'restart'
        self.stop
        self.disable
        self.enable
        self.start
    end

end
