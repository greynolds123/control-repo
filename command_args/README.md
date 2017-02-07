puppet-command_args
===================

[![Build Status](https://travis-ci.org/pcfens/puppet-command_args.svg?branch=master)](https://travis-ci.org/pcfens/puppet-command_args)

Convert a hash into command line arguments. The first argument is a hash
of arguments that should be passed, along with corresponding value.

Optional (positional) arguments:
1. The flag prefix to use (defaults to '--')
2. The separator to use (defaults to '=')

Example:

```
$arguments = {
  'aString'   => 'words',
  'secure'    => true,
  'insecure'  => false,
  'array'     => ['item1', 'item2'],
}

command_args($arguments)
# => --aString=words --secure --array=item1 --array=item2

command_args($arguments, '-')
# => -aString=words -secure -array=item1 -array=item2

command_args($arguments, '--', ' ')
# => --aString words --secure --array item1 --array item2
```
