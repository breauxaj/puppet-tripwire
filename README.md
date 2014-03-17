tripwire
========

Tripwire is a free software security and data integrity tool useful for
monitoring and alerting on specific file change(s) on a range of systems.

Do not use the passphrases below, create your own.

Samples
-------
```
include tripwire
```
```
tripwire::config { 'default':
  localpassphrase => '8Ls1L6o0J4dZx3v',
  sitepassphrase  => 'X6L4K4w72L7j42t',
  globalemail     => 'admin@domain.com'
}
```

License
-------
GPL3

Contact
-------
breauxaj AT gmail DOT com
