#
# Copyright:: Copyright (c) 2012 Opscode, Inc.
# License:: Apache License, Version 2.0
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
#

name "nginx"
default_version "1.4.7"

dependency "pcre"
dependency "openssl"
dependency "passenger"
dependency "nginx_echo"
dependency "nginx_headers_more"
dependency "nginx_x_rid_header"

source :url => "http://nginx.org/download/nginx-#{version}.tar.gz",
       :md5 => "aee151d298dcbfeb88b3f7dd3e7a4d17"

relative_path "nginx-#{version}"

env = {
  "PATH" => "#{install_dir}/embedded/bin:#{ENV["PATH"]}",
  "LD_RUN_PATH" => "#{install_dir}/embedded/lib",

  "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
}

build do
  command ["./configure",
           "--prefix=#{install_dir}/embedded",
           "--conf-path=#{install_dir}/etc/nginx/nginx.conf",
           "--pid-path=#{install_dir}/var/run/nginx.pid",
           "--lock-path=#{install_dir}/var/lock/subsys/nginx",
           "--error-log-path=#{install_dir}/var/log/nginx/error.log",
           "--http-log-path=#{install_dir}/var/log/nginx/access.log",
           "--http-client-body-temp-path=#{install_dir}/var/lib/nginx/tmp/client_body",
           "--http-proxy-temp-path=#{install_dir}/var/lib/nginx/tmp/proxy",
           "--http-fastcgi-temp-path=#{install_dir}/var/lib/nginx/tmp/fastcgi",
           "--http-uwsgi-temp-path=#{install_dir}/var/lib/nginx/tmp/uwsgi",
           "--http-scgi-temp-path=#{install_dir}/var/lib/nginx/tmp/scgi",
           "--with-http_ssl_module",
           "--with-http_stub_status_module",
           "--with-http_gzip_static_module",
           "--with-http_realip_module",
           "--add-module=#{source_dir}/nginx_echo-v0.53",
           "--add-module=#{source_dir}/nginx_headers_more-v0.25",
           "--add-module=#{source_dir}/nginx_x_rid_header-0daa3cc283d91a279a6013734fd78264582fce51",
           "--add-module=#{install_dir}/embedded/lib/ruby/gems/2.1.0/gems/passenger-4.0.41/ext/nginx",
           "--with-ipv6",
           "--with-debug",
           "--with-ld-opt=\"-L#{install_dir}/embedded/lib -luuid\"",
           "--with-cc-opt=\"-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include\""].join(" "),
          :env => env
  command "make -j #{max_build_jobs}", :env => env
  command "make install"
  command "mkdir -p #{install_dir}/var/lib/nginx/tmp"
end