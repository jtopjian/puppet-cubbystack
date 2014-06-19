class cubbystack::roles::controller::glance::backup (
  $backup_destination = false
) {
  if ($backup_destination) {
    ## Glance backup schedule
    cron { 'glance backup six hours':
      command => "/usr/bin/rsync -a /var/lib/glance/images/ ${backup_destination}:/var/lib/glance/images/",
      user    => 'root',
      minute  => '0',
      hour    => '*/6',
    }

    cron { 'glance full weekly sync':
      command => "/usr/bin/rsync -a --delete /var/lib/glance/images/ ${backup_destination}:/var/lib/glance/images/",
      user    => 'root',
      minute  => '0',
      hour    => '2',
      weekday => '0',
    }
  }
}
