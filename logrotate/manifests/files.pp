# Class logrotate::files
# is used for creating many files when needed.
# Example 
# include logrotate
# Class{logrotate::files:
#      fileshash      => {
#            file1    => {
#             path    => '',
#             options =>  [compress, daily, 'rotate 5']},
#            file2    => {}
#        }
#      }
class logrotate::files( $fileshash = {} )
{

  create_resources(::logrotate::file, $fileshash)
}
