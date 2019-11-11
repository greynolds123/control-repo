# DESCRIPTION
# Declares standard set of stages. This is an analog of stdlib::stages but with
# unused stages omitted.
#
# BEST PRACTICES
# DO NOT declare and use more than two stages besides the default main stage:
# one before main, and one after main. Stages are generally frowned upon and
# using them is considered against best practices except in a narrow set of
# circumstances. Note that stdlib contains more than two additional stages
# vestigially, but in practice only Stage[setup], Stage[main], and
# Stage[deploy] are ever considered for use.
class puppet_enterprise::stages {
  stage { 'pe_setup':
    before => Stage['main'],
  }
}
