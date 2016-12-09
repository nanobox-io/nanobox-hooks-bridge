# source docker helpers
. util/docker.sh

@test "Start Old Container" {
  start_container "test-migrate-old" "192.168.0.2"
}

@test "Configure Old Bridge" {
  # Run Hook
  run run_hook "test-migrate-old" "configure" "$(payload configure)"
  echo "$output"
  [ "$status" -eq 0 ]
}

@test "Start Bridge On Old" {
  run run_hook "test-migrate-old" "start" "$(payload start)"
  echo "$output"
  [ "$status" -eq 0 ]
}

@test "Insert Metric Data" {
  skip
  # figure out how to do this
}

@test "Start New Container" {
  start_container "test-migrate-new" "192.168.0.4"
}

@test "Configure New Bridge" {
  run run_hook "test-migrate-new" "configure" "$(payload configure-new)"
  echo "$output"
  [ "$status" -eq 0 ]
}

@test "Prepare New Import" {
  run run_hook "test-migrate-new" "import-prep" "$(payload import-prep)"
  echo "$output"
  [ "$status" -eq 0 ]
}

@test "Export Live Data" {
  run run_hook "test-migrate-old" "export-live" "$(payload export-live)"
  echo "$output"
  [ "$status" -eq 0 ]
}

@test "Stop Old Bridge Service" {
  run run_hook "test-migrate-old" "stop" "$(payload stop)"
  echo "$output"
  [ "$status" -eq 0 ]
}

@test "Export Final Data" {
  run run_hook "test-migrate-old" "export-final" "$(payload export-final)"
  echo "$output"
  [ "$status" -eq 0 ]
}

@test "Clean After Import" {
  run run_hook "test-migrate-new" "import-clean" "$(payload import-clean)"
  echo "$output"
  [ "$status" -eq 0 ]
}

@test "Start New Bridge Service" {
  run run_hook "test-migrate-new" "start" "$(payload start)"
  echo "$output"
  [ "$status" -eq 0 ]
}

@test "Verify Data Transfered" {
  run docker exec "test-migrate-old" md5sum /data/var/db/openvpn/pki/ca.crt
  echo "$output"
  old="$output"
  [ "$status" -eq 0 ]
  run docker exec "test-migrate-new" md5sum /data/var/db/openvpn/pki/ca.crt
  echo "$output"
  new="$output"
  [ "$status" -eq 0 ]
  [ "$old" = "$new" ]
}

@test "Stop Old Container" {
  stop_container "test-migrate-old"
}

@test "Stop New Container" {
  stop_container "test-migrate-new"
}
