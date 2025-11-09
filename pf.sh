#!/usr/bin/env bash

# port filtrate by pelamx – read IPs from stdin and list those with a given TCP port open - endpoint adding option

#

# usage:  cat hosts.txt | ./pf -p 10255

#

# options:

#   -p, --port <PORT>        (required) TCP port to test

#   -t, --timeout <SEC>      socket connect timeout in seconds   [default: 2]

#   -c, --concurrency <N>    how many IPs to probe in parallel   [default: 100]

#   -s, --https              print https:// instead of http://

#   -ep, --endpoint <PATH>   append endpoint (ex: /pods) to each output URL

#   -h, --help               this help



set -euo pipefail



usage() { grep -E '^#' "$0" | sed -E 's/^# ?//'; }



# ---------- defaults ----------

port=""

timeout_sec=2

concurrency=100

scheme="http"

endpoint=""

# -------------------------------



# ---------- option parser ------

while [[ $# -gt 0 ]]; do

  case "$1" in

    -p|--port)        port="$2";        shift 2 ;;

    -t|--timeout)     timeout_sec="$2"; shift 2 ;;

    -c|--concurrency) concurrency="$2"; shift 2 ;;

    -s|--https)       scheme="https";   shift   ;;

    -ep|--endpoint)   endpoint="$2";    shift 2 ;;

    -h|--help)        usage;            exit 0  ;;

    *) echo "Unknown option: $1" >&2; usage; exit 1 ;;

  esac

done



[[ -z "$port" ]] && { echo "[!] you must supply -p <port>" >&2; usage; exit 1; }

export port timeout_sec scheme endpoint



probe() {

  local ip="$1"

  # Ensure endpoint starts with "/" if set and isn't empty

  local ep="$endpoint"

  [[ -n "$ep" && "${ep:0:1}" != "/" ]] && ep="/$ep"

  # Fast /dev/tcp check (built-in to bash); fallback: try nc if /dev/tcp is disabled

  if timeout "${timeout_sec}" bash -c "exec 3<>/dev/tcp/${ip}/${port}" 2>/dev/null; then

    echo "${scheme}://${ip}:${port}${ep}"

  elif command -v nc >/dev/null 2>&1 \

       && timeout "${timeout_sec}" nc -z "${ip}" "${port}" >/dev/null 2>&1; then

    echo "${scheme}://${ip}:${port}${ep}"

  fi

}



export -f probe



# Stdin → unique, non-empty lines → parallel probe

grep -vE '^\s*$' | sort -u | \

  xargs -P "${concurrency}" -I{} bash -c 'probe "$1"' _ {}
