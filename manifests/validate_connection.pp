# TODO: docs

define postgresql::validate_connection(
    $database_host,
    $database_port,
    $database_username,
    $database_password,
    $database_name,
    $client_package_name     = $postgresql::params::client_package_name,
) {
    require postgresql::params

    package { 'postgresql-client':
        name   => $client_package_name,
        ensure => present,
    }

    # TODO: port to ruby
    $psql = "${postgresql::params::psql_path} --tuples-only --quiet -h $database_host -U $database_username -p $database_port --dbname $database_name"

    exec {"validate postgres connection for $database_host/$database_name":
      #command     => "/bin/echo \"SELECT 1\" | $psql |egrep -v -q '^$'",
      command     => "/bin/echo \"SELECT 1\" | $psql",
      cwd         => '/tmp',
      environment => "PGPASSWORD=$database_password",
      logoutput   => 'on_failure',
      #returns     => 1,
    }
}

