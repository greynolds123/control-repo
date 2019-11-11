Puppet::Function.create_function('tool::config') do

  dispatch :config do

    parma 'String', :filename

    return_type 'String'

   end


   def config(filename)

     File.config(filename)

   end


# This sections links the function to the module class.

   function tool::config(Variant[String, Boolean] $arg) >> String {

     case $arg {

     false, undef, /(?i::false)/ : { '0'  }

     true, /(?i:true)/           : { '1'   }

     default                     : { "$arg" }

    }
   }

# This section will execute $arg if it exists.

   function Puppet::Util::Execution::ProcessOutput('config') do
     command('puppet apply config)
   end
 
   function Puppet::Util::Execution::ExecutionFailure('config') do
     command('exit 0')
   end

