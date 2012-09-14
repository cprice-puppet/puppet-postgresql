# TODO: docs - relies on use of 'db'!!

define postgresql::validate_db_connection(
    $database_host,
    $database_port,
    $database_username,
    $database_password,
    $database_name,
    $client_package_name = "",
) {
    include postgresql::params

    # TODO: splain

    if (! $client_package_name) {
        $package_name = $postgresql::params::client_package_name
    } else {
        $package_name = $client_package_name
    }

    package { 'postgresql-client':
        name   => $package_name,
        ensure => present,
    }

    # TODO: port to ruby
    $psql = "${postgresql::params::psql_path} --tuples-only --quiet -h $database_host -U $database_username -p $database_port --dbname $database_name"

    $exec_name = "validate postgres connection for $database_host/$database_name"
    exec {$exec_name:
      command     => "/bin/echo \"SELECT 1\" | $psql",
      cwd         => '/tmp',
      environment => "PGPASSWORD=$database_password",
      logoutput   => 'on_failure',
      require     => Package['postgresql-client'],
    }

    # TODO: splain
    Db<|title == $database_name|> -> Exec[$exec_name]
}

