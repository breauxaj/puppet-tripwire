define tripwire::config (
  $localpassphrase,
  $sitepassphrase,
  $globalemail
) {
  file { '/etc/tripwire/Makefile':
    owner   => 'root',
    group   => 'root',
    mode    => '0440',
    content => template('tripwire/Makefile.erb'),
    require => Package['tripwire'],
  }

  file { '/etc/tripwire/twcfg.txt':
    owner   => 'root',
    group   => 'root',
    mode    => '0440',
    content => template('tripwire/twcfg.erb'),
    require => Package['tripwire'],
  }

  file { '/etc/tripwire/twpol.txt':
    owner   => 'root',
    group   => 'root',
    mode    => '0440',
    content => template('tripwire/twpol.erb'),
    require => Package['tripwire'],
  }

  file { '/etc/cron.daily/tripwire-check':
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    source  => 'puppet:///modules/tripwire/tripwire-check',
    require => Package['tripwire'],
  }

  file { '/var/lib/tripwire/tripwire.twd':
    owner => 'root',
    group => 'root',
    mode  => '0440',
  }

  exec { 'init-tripwire':
    path    => '/bin:/usr/bin',
    command => 'make -C /etc/tripwire',
    cwd     => '/etc/tripwire',
    creates => '/var/lib/tripwire/tripwire.twd',
    timeout => 10000,
    require => [
      File['/etc/tripwire/Makefile'],
      File['/etc/tripwire/twcfg.txt'],
      File['/etc/tripwire/twpol.txt'],
    ],
  }

  exec { 'update-tripwire':
    path        => '/sbin:/usr/sbin',
    command     => "tripwire --update-policy -Z low --local-passphrase '${localpassphrase}' --site-passphrase '${sitepassphrase}' --quiet /etc/tripwire/twpol.txt",
    cwd         => '/etc/tripwire',
    timeout     => 10000,
    refreshonly => true,
    subscribe   => File['/etc/tripwire/twpol.txt'],
  }

}
