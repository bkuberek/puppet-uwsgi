define uwsgi::plugin (
  $package = undef,
) {
  if $package == undef {
    fail("${name}: package must be defined")
  }

  realize Package[$package]
}
