class uwsgi (
  $auto_load     = true,
  $master        = true,
  $workers       = 2,
  $no_orphans    = true,
  $chmod_socket  = 660,
  $log_date      = true,
  $uid           = 'www-data',
  $gid           = 'www-data',
  $extra_conf    = undef,
) {
  package { ['uwsgi']:
    ensure => installed
  }

  service { 'uwsgi':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => false,
  }

  # virtual packages, used by plugins.
  @package { [
      'uwsgi-plugin-admin',
      'uwsgi-plugins-all',
      'uwsgi-app-integration-plugins',
      'uwsgi-plugin-cache',
      'uwsgi-plugin-carbon',
      'uwsgi-plugin-cgi',
      'uwsgi-plugin-echo',
      'uwsgi-plugin-erlang',
      'uwsgi-plugin-fastrouter',
      'uwsgi-plugin-fiber',
      'uwsgi-plugin-graylog2',
      'uwsgi-plugin-greenlet-python',
      'uwsgi-plugin-http',
      'uwsgi-infrastructure-plugins',
      'uwsgi-plugin-jvm-openjdk-6',
      'uwsgi-plugin-jwsgi-openjdk-6',
      'uwsgi-plugin-logsocket',
      'uwsgi-plugin-lua5.1',
      'uwsgi-plugin-nagios',
      'uwsgi-plugin-ping',
      'uwsgi-plugin-probeconnect',
      'uwsgi-plugin-probepg',
      'uwsgi-plugin-psgi',
      'uwsgi-plugin-pyerl-python',
      'uwsgi-plugin-pyerl-python3',
      'uwsgi-plugin-python',
      'uwsgi-plugin-python3',
      'uwsgi-plugin-rack-ruby18',
      'uwsgi-plugin-rack-ruby191',
      'uwsgi-plugin-rpc',
      'uwsgi-plugin-rrdtool',
      'uwsgi-plugin-rsyslog',
      'uwsgi-plugin-signal',
      'uwsgi-plugin-symcall',
      'uwsgi-plugin-syslog',
      'uwsgi-plugin-ugreen',
    ]:
    notify => Service['uwsgi'],
  }

  # virtual plugins and how they map to packages.
  # Note: when these plugins are realized, they will in turn trigger the
  #       installation of the dependent package without conflicts.
  @uwsgi::plugin {
    ['admin']               : package => 'uwsgi-plugin-admin';
    ['all']                 : package => 'uwsgi-plugin-all';
    ['integration']         : package => 'uwsgi-app-integration-plugins';
    ['cache']               : package => 'uwsgi-plugin-cache';
    ['carbon']              : package => 'uwsgi-plugin-carbon';
    ['cgi']                 : package => 'uwsgi-plugin-cgi';
    ['echo']                : package => 'uwsgi-plugin-echo';
    ['erlang']              : package => 'uwsgi-plugin-erlang';
    ['fastrouter']          : package => 'uwsgi-plugin-fastrouter';
    ['fiber']               : package => 'uwsgi-plugin-fiber';
    ['graylog2']            : package => 'uwsgi-plugin-graylog2';
    ['greenlet-python']     : package => 'uwsgi-plugin-greenlet-python';
    ['http']                : package => 'uwsgi-plugin-http';
    ['infrastructure']      : package => 'uwsgi-infrastructure-plugins';
    ['jvm-openjdk-6']       : package => 'uwsgi-plugin-jvm-openjdk-6';
    ['jwsgi-openjdk-6']     : package => 'uwsgi-plugin-jwsgi-openjdk-6';
    ['logsocket']           : package => 'uwsgi-plugin-logsocket';
    ['lua5.1']              : package => 'uwsgi-plugin-lua5.1';
    ['nagios']              : package => 'uwsgi-plugin-nagios';
    ['ping']                : package => 'uwsgi-plugin-ping';
    ['probeconnect']        : package => 'uwsgi-plugin-probeconnect';
    ['probepg']             : package => 'uwsgi-plugin-probepg';
    ['psgi']                : package => 'uwsgi-plugin-psgi';
    ['pyerl-python']        : package => 'uwsgi-plugin-pyerl-python';
    ['pyerl-python3']       : package => 'uwsgi-plugin-pyerl-python3';
    ['python26', 'python27']: package => 'uwsgi-plugin-python';
    ['python3']             : package => 'uwsgi-plugin-python3';
    ['rack-ruby18']         : package => 'uwsgi-plugin-rack-ruby18';
    ['rack-ruby191']        : package => 'uwsgi-plugin-rack-ruby191';
    ['rpc']                 : package => 'uwsgi-plugin-rpc';
    ['rrdtool']             : package => 'uwsgi-plugin-rrdtool';
    ['rsyslog']             : package => 'uwsgi-plugin-rsyslog';
    ['signal']              : package => 'uwsgi-plugin-signal';
    ['symcall']             : package => 'uwsgi-plugin-symcall';
    ['syslog']              : package => 'uwsgi-plugin-syslog';
    ['ugreen']              : package => 'uwsgi-plugin-ugreen';
  }

  file { '/etc/default/uwsgi':
    ensure  => file,
    content => template('uwsgi/uwsgi.erb'),
    require => Package['uwsgi'],
    notify  => Service['uwsgi'],
  }

  file { 'uwsgi.default.ini':
    ensure  => file,
    path    => '/etc/uwsgi/defaults.ini',
    content => template('uwsgi/default.ini.erb'),
    require => Package['uwsgi'],
    notify  => Service['uwsgi'],
  }
}
