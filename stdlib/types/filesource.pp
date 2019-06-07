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
>>>>>>> f661b3a03526f113b1823084ffd4808cf261cf70
  ],
]
