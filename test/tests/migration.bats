# source docker helpers
. util/docker.sh

# source mist helpers
. util/mist.sh

@test "Start Mist Container" {
  start_mist
}

@test "Start Old Container" {
  start_container "test-migrate-old" "192.168.0.2"
}

@test "Configure Old Pulse" {
  # Run Hook
  run run_hook "test-migrate-old" "configure" "$(payload configure)"
  [ "$status" -eq 0 ]
}

@test "Start Pulse On Old" {
  run run_hook "test-migrate-old" "start" "$(payload start)"
  [ "$status" -eq 0 ]
}

@test "Insert Metric Data" {
  skip
  # figure out how to do this
}

@test "Start New Container" {
  start_container "test-migrate-new" "192.168.0.4"
}

@test "Configure New Pulse" {
  run run_hook "test-migrate-new" "configure" "$(payload configure-new)"
  [ "$status" -eq 0 ]
}

@test "Prepare New Import" {
  run run_hook "test-migrate-new" "import-prep" "$(payload import-prep)"
  [ "$status" -eq 0 ]
}

@test "Export Live Data" {
  run run_hook "test-migrate-old" "export-live" "$(payload export-live)"
  echo "$output"
  [ "$status" -eq 0 ]
}

@test "Stop Old Pulse Service" {
  run run_hook "test-migrate-old" "stop" "$(payload stop)"
  [ "$status" -eq 0 ]
}

@test "Export Final Data" {
  run run_hook "test-migrate-old" "export-final" "$(payload export-final)"
  echo "$output"
  [ "$status" -eq 0 ]
}

@test "Clean After Import" {
  run run_hook "test-migrate-new" "import-clean" "$(payload import-clean)"
  [ "$status" -eq 0 ]
}

@test "Start New Pulse Service" {
  run run_hook "test-migrate-new" "start" "$(payload start)"
  [ "$status" -eq 0 ]
}

@test "Verify Data Transfered" {
  run docker exec "test-migrate-new" bash -c "[ -d /var/db/influxdb/data ]"
  echo "$output"
  [ "$status" -eq 0 ]
}

@test "Stop Old Container" {
  stop_container "test-migrate-old"
}

@test "Stop New Container" {
  stop_container "test-migrate-new"
}

@test "Stop Mist Container" {
  stop_mist
}
