# Validate the source parameter on file types
type Stdlib::Filesource = Variant[
  Stdlib::Absolutepath,
  Stdlib::HTTPUrl,
  Pattern[
    /^file:\/\/\/([^\/\0]+(\/)?)+$/,
<<<<<<< HEAD
    /^puppet:\/\/(([\w-]+\.?)+)?\/modules\/([^\/\0]+(\/)?)+$/,
=======
    /^puppet:\/\/(([\w-]+\.?)+)?\/([^\/\0]+(\/)?)+$/,
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
  ],
]
