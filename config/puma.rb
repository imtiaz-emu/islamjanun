environment "production"

bind  "unix:///root/apps/islamjanun/shared/tmp/sockets/puma.sock"
pidfile "/root/apps/islamjanun/shared/tmp/pids/puma.pid"
state_path "/root/apps/islamjanun/shared/tmp/sockets/puma.state"
directory "/root/apps/islamjanun/current"

workers 2
threads 1,2

daemonize true

activate_control_app 'unix:///root/apps/islamjanun/shared/tmp/sockets/pumactl.sock'

prune_bundler
