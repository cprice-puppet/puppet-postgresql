# puppet-postgresql
# For all details and documentation:
# http://github.com/inkling/puppet-postgresql
#
# Copyright 2012- Inkling Systems, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

define postgresql::role($username=$title, $password, $db='postgres', $version='9.1', $login=false, $createrole=false, $createdb=false, $superuser=false) {

  $login_sql      = $login      ? { true => 'LOGIN'     , false => 'NOLOGIN' }
  $createrole_sql = $createrole ? { true => 'CREATEROLE', false => 'NOCREATEROLE' }
  $createdb_sql   = $createdb   ? { true => 'CREATEDB'  , false => 'NOCREATEDB' }
  $superuser_sql  = $superuser  ? { true => 'SUPERUSER' , false => 'NOSUPERUSER' }

  # FIXME: Will not correct the superuser / createdb / createrole / login status of a role that already exists
  postgresql::psql {"CREATE ROLE ${username} ENCRYPTED PASSWORD '${password}' $login_sql $createrole_sql $createdb_sql $superuser_sql":
    version => $version,
    db      => $db,
    user    => 'postgres',
    unless  => "SELECT rolname FROM pg_roles WHERE rolname='$username'",
  }
}
