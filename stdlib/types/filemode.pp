<<<<<<< HEAD
type Stdlib::Filemode = Pattern[/^[0124]{1}[0-7]{3}$/]
=======
# See `man chmod.1` for the regular expression for symbolic mode
type Stdlib::Filemode = Pattern[/^(([0-7]{1,4})|(([ugoa]*([-+=]([rwxXst]*|[ugo]))+|[-+=][0-7]+)(,([ugoa]*([-+=]([rwxXst]*|[ugo]))+|[-+=][0-7]+))*))$/]
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
