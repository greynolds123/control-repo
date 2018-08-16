<<<<<<< HEAD
# this regex rejects any path component that is a / or a NUL
type Stdlib::Unixpath = Pattern[/^\/([^\/\0]+(\/)?)+$/]
=======
# this regex rejects any path component that does not start with "/" or is NUL
type Stdlib::Unixpath = Pattern[/^\/([^\/\0]+\/*)*$/]
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
