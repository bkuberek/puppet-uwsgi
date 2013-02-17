define uwsgi::app (
  $socket           = undef,
  $module           = undef,
  $ensure           = 'present',
  $workers          = $::processorcount,
  $auto_procname    = false,
  $procname_prefix  = $name,
  $threads          = undef,
  $thread_stacksize = undef,
  $master           = undef,
  $plugins          = ['python26'],
  $postbuffering    = false,
  $uid              = undef,
  $gid              = undef,
  $touchreload      = undef,
  $chdir            = undef,
  $harakiri         = undef,
  $extra_conf       = undef,
  # TODO: cannot be configured at this moment, maybe an addition to .ini?.
  $logdir           = '/var/log/uwsgi/app',
) {
  include uwsgi

  # realize specified plugins
  realize Uwsgi::Plugin[$plugins]

  file { "/etc/uwsgi/apps-available/${name}.ini":
    ensure  => $ensure,
    mode    => '0644',
    content => template('uwsgi/app.ini.erb'),
    require => Package['uwsgi'],
    notify  => Service['uwsgi'],
  }

  $enabled_ensure = $ensure ? {
    'absent' => absent,
    default  => link,
  }

  file { "/etc/uwsgi/apps-enabled/${name}.ini":
    ensure  => $enabled_ensure,
    target  => "../apps-available/${name}.ini",
    require => File["/etc/uwsgi/apps-available/${name}.ini"],
    notify  => Service['uwsgi'],
  }

  file { "/etc/logrotate.d/uwsgi-${name}":
    ensure  => file,
    content => template('uwsgi/app.logrotate.erb')
  }
}
