name "nginx_echo"
default_version "v0.53"

source :git => "https://github.com/openresty/echo-nginx-module.git"

relative_path "#{name}-#{version}"
