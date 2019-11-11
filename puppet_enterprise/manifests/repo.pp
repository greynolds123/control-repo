# DESCRIPTION
# Internal class for Puppet Enterprise to configure package repositories
#
# USAGE
# This class should be include'd by any puppet_enterprise class which requires
# the package repository to be configured. That's likely to be any class that
# ensures packages present. Example usage:
#
#     include puppet_enterprise::repo
#
# USE OF PUPPET STAGE
# Repositories are foundational to package installation and should generally be
# configured prior to anything else. To implement this broad-strokes
# early-stage dependency, a Puppet stage will be used. Stages are generally
# frowned upon, and using them is considered against best practices EXCEPT in a
# narrow set of circumstances. Package repository configuration is one of the
# few accepted use cases for Puppet stages.
#
# TWO-CLASS STAGES PATTERN
# It should be possible to include puppet_enterprise::repo from any class,
# idempotently. However, to use a stage it is necessary to declare a class
# using resource-style syntax, which is not idempotent. Therefore, a two-class
# pattern is used. The first class (this one) serves as the internal API and is
# include-able. This class and ONLY this class then declares, resource-style, a
# private sub-class in a stage.
class puppet_enterprise::repo (
  Boolean $installing = false,
) {
  if !$installing {
    include puppet_enterprise
    contain puppet_enterprise::repo::config
  }
}
