# This class will provide the group for git.

  class gitprod::group {
  group { 'git':
  gid => 1111,
  uid => 1111,
  }
  }
