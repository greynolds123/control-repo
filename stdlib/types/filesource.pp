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
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
  ],
]
