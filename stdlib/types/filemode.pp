<<<<<<< HEAD
type Stdlib::Filemode = Pattern[/^[0124]{1}[0-7]{3}$/]
=======
# See `man chmod.1` for the regular expression for symbolic mode
type Stdlib::Filemode = Pattern[/^(([0-7]{1,4})|(([ugoa]*([-+=]([rwxXst]*|[ugo]))+|[-+=][0-7]+)(,([ugoa]*([-+=]([rwxXst]*|[ugo]))+|[-+=][0-7]+))*))$/]
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
