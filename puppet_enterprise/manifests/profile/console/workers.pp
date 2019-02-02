# WARNING: This class is obsolete and will be removed in a future version
# of Puppet Enterprise.  Please remove it from your classification.
#
# Profile for configuring dashboard workers.
#
# @param database_name [String] The name of the dashboard database.
# @param database_user [String] The user account for the dashboard DB.
# @param database_password [String] The password for the user set by
#        dashboard_database_user.
# @param database_host [String] The hostname running PostgreSQL.
# @param database_port [Integer] The port that PostgreSQL is listening on.
# @param delayed_job_workers [Integer] The number of delayed job workers
#        that the system is allowed to allocate.  The Default is 2.
class puppet_enterprise::profile::console::workers(
  $database_password,
  $database_host     = $puppet_enterprise::database_host,
  $database_name     = $puppet_enterprise::dashboard_database_name,
  $database_port     = $puppet_enterprise::database_port,
  $database_user     = $puppet_enterprise::dashboard_database_user,
  $delayed_job_workers   = 2,
) inherits puppet_enterprise {
}
