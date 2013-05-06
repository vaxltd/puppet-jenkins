# Parameters:
# lts = 0  (Default)
#   Use the most up to date version of jenkins
#
#lts =1  - Use LTS verison of jenkins
#
# repo = 1 (Default)
#   install the jenkins repo.
# repo = 0
#   Do NOT install a repo.  This means you'll manage a repo manually, outside this module.
# This is for folks that use a custom repo, or the like.
#
# config_hash = undef (Default)
# Hash with config options to set in sysconfig/jenkins defaults/jenkins
#
# Example use
# 
# class{ 'jenkins::config': 
#   config_hash => { 'PORT' => { 'value' => '9090' }, 'AJP_PORT' => { 'value' => '9009' } } 
# }
# 
class jenkins(
  $version     = 'installed', 
  $lts         = 0, 
  $repo        = 1,
  $config_hash = undef,
) {

  class { 'jenkins::repo':
    lts  => $lts,
    repo => $repo,
  }

  class { 'jenkins::package':
      version => $version,
  }

  class { 'jenkins::config':
      config_hash => $config_hash,
  }

  include jenkins::service
  include jenkins::firewall

  Class['jenkins::repo'] -> Class['jenkins::package']
  -> Class['jenkins::service']
}
# vim: ts=2 et sw=2 autoindent
