<<<<<<< HEAD
# this regex rejects any path component that is a / or a NUL
type Stdlib::Unixpath = Pattern[/^\/([^\/\0]+(\/)?)+$/]
=======
# this regex rejects any path component that does not start with "/" or is NUL
type Stdlib::Unixpath = Pattern[/^\/([^\/\0]+\/*)*$/]
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
