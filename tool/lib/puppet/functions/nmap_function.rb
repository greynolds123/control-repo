Puppet::Function.create_function('tool::nmap') do

  dispatch :nmap do

    parma 'String', :filename

    return_type 'String'

   end



   def nmap(filename)

     File.nmap(filename)

   end

   function Puppet::Util::Execution::ProcessOutput('nmap') do

    command('puppet apply nmap')

   end


  function Puppet::Util::ExectionFailure('nmap') do

    command('exit 0')

   end
