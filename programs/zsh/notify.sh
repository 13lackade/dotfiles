if (( $# == 0 )); then
  printf 'Usage: notify COMMAND [ARG...]\n' >&2
  exit 2
fi

if [[ $1 == --help ]]; then
  printf 'Usage: notify COMMAND [ARG...]\nRun a command and send a desktop notification when it finishes.\n'
  exit 0
fi

status=0
"$@" || status=$?

if (( status == 0 )); then
  summary='Command completed'
  urgency=normal
else
  summary="Command failed (exit $status)"
  urgency=critical
fi

if ! notify-send --app-name=notify --urgency="$urgency" -- "$summary" "$1"; then
  printf 'notify: could not send desktop notification\n' >&2
fi

exit "$status"
