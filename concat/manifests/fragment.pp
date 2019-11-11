<<<<<<< HEAD
# == Define: concat::fragment
#
# Creates a concat_fragment in the catalogue
#
# === Options:
#
# [*target*]
#   The file that these fragments belong to
# [*content*]
#   If present puts the content into the file
# [*source*]
#   If content was not specified, use the source
# [*order*]
#   By default all files gets a 10_ prefix in the directory you can set it to
#   anything else using this to influence the order of the content in the file
#
define concat::fragment(
    $target,
    $ensure  = undef,
    $content = undef,
    $source  = undef,
    $order   = '10',
) {
  validate_string($target)

  if $ensure != undef {
    warning('The $ensure parameter to concat::fragment is deprecated and has no effect.')
  }

  validate_string($content)
  if !(is_string($source) or is_array($source)) {
    fail('$source is not a string or an Array.')
  }

  if !(is_string($order) or is_integer($order)) {
    fail('$order is not a string or integer.')
  } elsif (is_string($order) and $order =~ /[:\n\/]/) {
    fail("Order cannot contain '/', ':', or '\n'.")
=======
# @summary
#   Manages a fragment of text to be compiled into a file.
#
# @param content
#   Supplies the content of the fragment. Note: You must supply either a content parameter or a source parameter.
#
# @param order
#   Reorders your fragments within the destination file. Fragments that share the same order number are ordered by name. The string
#   option is recommended.
#
# @param source
#   Specifies a file to read into the content of the fragment. Note: You must supply either a content parameter or a source parameter.
#   Valid options: a string or an array, containing one or more Puppet URLs.
#
# @param target
#   Specifies the destination file of the fragment. Valid options: a string containing the path or title of the parent concat resource.
#
define concat::fragment(
  String                             $target,
  Optional[String]                   $content = undef,
  Optional[Variant[String, Array]]   $source  = undef,
  Variant[String, Integer]           $order   = '10',
) {
  $resource = 'Concat::Fragment'

  if ($order =~ String and $order =~ /[:\n\/]/) {
    fail(translate("%{_resource}['%{_title}']: 'order' cannot contain '/', ':', or '\\n'.", {'_resource' => $resource, '_title' => $title}))
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
  }

  if ! ($content or $source) {
    crit('No content, source or symlink specified')
  } elsif ($content and $source) {
<<<<<<< HEAD
    fail("Can't use 'source' and 'content' at the same time")
  }

  $safe_target_name = regsubst($target, '[/:~\n\s\+\*\(\)]', '_', 'GM')
=======
    fail(translate("%{_resource}['%{_title}']: Can't use 'source' and 'content' at the same time.", {'_resource' => $resource, '_title' => $title}))
  }

  $safe_target_name = regsubst($target, '[\\\\/:~\n\s\+\*\(\)@]', '_', 'GM')
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8

  concat_fragment { $name:
    target  => $target,
    tag     => $safe_target_name,
    order   => $order,
    content => $content,
    source  => $source,
  }
}
