# vim: tabstop=2 shiftwidth=2 softtabstop=2
# This class installs postgresql server and configures it using the conf template
class postgresql::python {

  #Default client installed by postgresql module
  include postgresql
  
  # Add what's missing
  $pg_packages=['python-psycopg2', 'libpq-dev', 'python-egenix-mx-base-dev']

   package { $pg_packages:
     ensure => installed,
   }
   if ! defined(Package['python-dev']) {
     package { 'python-dev':
       ensure => installed,
     }
   }

#   package { 'mcloud-psycopg':
#     ensure => installed,
#   }
}
