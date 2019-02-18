# source docker helpers
. util/docker.sh

@test "Start Container" {
  start_container "test-single" "192.168.0.2"
}

@test "Configure" {
  # Run Hook
  run run_hook "test-single" "configure" "$(payload configure-null)"
  echo "$output"
  [ "$status" -eq 0 ]

  # Verify Bridge configuration
  run docker exec test-single bash -c "[ -f /data/etc/openvpn/openvpn.conf ]"
  echo "$output"
  [ "$status" -eq 0 ]
}

@test "keys" {
  # Run hook
  run run_hook "test-single" "keys" "$(payload keys)"
  echo "$output"
  [ "$status" -eq 0 ]
}

@test "Start" {
  # Run hook
  run run_hook "test-single" "start" "$(payload start-null)"
  echo "$output"
  [ "$status" -eq 0 ]

  # Verify Bridge running
  run docker exec test-single bash -c "ps aux | grep [o]penvpn"
  echo "$output"
  [ "$status" -eq 0 ]
}

@test "Verify Service" {
  skip
  # figure out how to do this
}

@test "Stop" {
  # Run hook
  run run_hook "test-single" "stop" "$(payload stop-null)"
  echo "$output"
  [ "$status" -eq 0 ]

  # Test the double stop
  run run_hook "test-single" "stop" "$(payload stop-null)"
  echo "$output"
  [ "$status" -eq 0 ]

  # Wait until services shut down
  while docker exec "test-single" bash -c "ps aux | grep [o]penvpn"
  do
    sleep 1
  done

  # Verify Bridge is not running
  run docker exec test-single bash -c "ps aux | grep [o]penvpn"
  echo "$output"
  [ "$status" -eq 1 ]

  # Verify narc is not running
  run docker exec test-single bash -c "ps aux | grep [n]arc"
  echo "$output"
  [ "$status" -eq 1 ]
}

@test "Stop Container" {
  stop_container "test-single"
}
