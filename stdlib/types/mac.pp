# A type for a MAC address
<<<<<<< HEAD
type Stdlib::MAC = Pattern[/^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$/]
=======
type Stdlib::MAC = Pattern[
  /^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$/,
  /^([0-9A-Fa-f]{2}[:-]){19}([0-9A-Fa-f]{2})$/
]
>>>>>>> f661b3a03526f113b1823084ffd4808cf261cf70
