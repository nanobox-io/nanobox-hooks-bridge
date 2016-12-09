# source docker helpers
. util/docker.sh

@test "Start Container" {
  start_container "simple-single-no-logvac" "192.168.0.2"
}

@test "Configure" {
  # Run Hook
  run run_hook "simple-single-no-logvac" "configure" "$(payload configure-no-logvac)"
  echo "$output"
  [ "$status" -eq 0 ]

  # Verify Bridge configuration
  run docker exec simple-single-no-logvac bash -c "[ -f /data/etc/openvpn/openvpn.conf ]"
  echo "$output"
  [ "$status" -eq 0 ]

  # Verify narc configuration
  run docker exec simple-single-no-logvac bash -c "[ -f /opt/gonano/etc/narc.conf ]"
  echo "$output"
  [ "$status" -eq 1 ]
}

@test "Start" {
  # Run hook
  run run_hook "simple-single-no-logvac" "start" "$(payload start)"
  echo "$output"
  [ "$status" -eq 0 ]

  # Verify Bridge running
  run docker exec simple-single-no-logvac bash -c "ps aux | grep [o]penvpn"
  echo "$output"
  [ "$status" -eq 0 ]

  # Verify narc running
  run docker exec simple-single-no-logvac bash -c "ps aux | grep [n]arc"
  echo "$output"
  [ "$status" -eq 1 ]
}

@test "Verify Service" {
  skip
  # figure out how to do this
}

@test "Stop" {
  # Run hook
  run run_hook "simple-single-no-logvac" "stop" "$(payload stop)"
  echo "$output"
  [ "$status" -eq 0 ]

  # Test the double stop
  run run_hook "simple-single-no-logvac" "stop" "$(payload stop)"
  echo "$output"
  [ "$status" -eq 0 ]

  # Wait until services shut down
  while docker exec "simple-single-no-logvac" bash -c "ps aux | grep [o]penvpn"
  do
    sleep 1
  done

  # Verify Bridge is not running
  run docker exec simple-single-no-logvac bash -c "ps aux | grep [o]penvpn"
  echo "$output"
  [ "$status" -eq 1 ]

  # Verify narc is not running
  run docker exec simple-single-no-logvac bash -c "ps aux | grep [n]arc"
  echo "$output"
  [ "$status" -eq 1 ]
}

@test "Stop Container" {
  stop_container "simple-single-no-logvac"
}
