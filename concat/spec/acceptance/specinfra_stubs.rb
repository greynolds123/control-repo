<<<<<<< HEAD
=======
# class Specinfra::Command::Windows::Base::File
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
class Specinfra::Command::Windows::Base::File < Specinfra::Command::Windows::Base
  class << self
    def check_is_owned_by(file, owner)
      Backend::PowerShell::Command.new do
        exec "if((Get-Item '#{file}').GetAccessControl().Owner -match '#{owner}'
          -or ((Get-Item '#{file}').GetAccessControl().Owner -match '#{owner}').Length -gt 0){ exit 0 } else { exit 1 }"
      end
    end
  end
end
<<<<<<< HEAD


=======
# class Specinfra::Command::Base::File
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
class Specinfra::Command::Base::File < Specinfra::Command::Base
  class << self
    def get_content(file)
      "cat '#{file}' 2> /dev/null || echo -n"
    end
  end
end
