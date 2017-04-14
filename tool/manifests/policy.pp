# This is the validation module for tools

 class tool::policy (
  $policies = {},
) {

  validate_hash($::tool)

  create_resources('tool::policy::production', $policies)

}

