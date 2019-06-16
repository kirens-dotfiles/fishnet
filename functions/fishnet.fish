function __fishnet_setStatus
  return $argv[1]
end

function __fishnet_resolve_name
  echo "$HOME/.local/share/fish/fishnet_records/$argv[1]"
end

function __fishnet_err
  echo $argv >&2
end

function __fishnet_print_counter --no-scope-shadowing
  printf "$recorded_args "
  set_color red;
  printf "🔴"
  set_color normal;
end

# The main functions are below
###############################

function __fishnet_playback
  # Make sure recording exists
  set -l file (__fishnet_resolve_name "$argv[1]")
  if not test -f "$file"
    __fishnet_err Recording does not seem to exist
    return 127
  end

  set -l last_status 0
  while read --null cmd
    switch $cmd
      case '# *'
        echo '- NOTE ---'
        string sub --start 3 "$cmd"
        echo '----------'
      case '*'
        __fishnet_setStatus $last_status
        read \
          --prompt=fish_prompt \
          --command="$cmd" \
          --shell \
          command < /dev/stdin
        eval "$command"
        set -l last_status $status
    end
  end < "$file"

  echo Completed sequence "\"$argv[1]\""
end


function __fishnet_record --no-scope-shadowing
  # Make sure not to overwrite another command
  set -l file (__fishnet_resolve_name "$argv[1]")
  if test -f "$file"
    set -l overwrite (read --prompt-str='Overwrite existing record? (y/N) ')
    if test "$overwrite" != y
      return 0
    end
  end

  # Write to a temporary file so we don't overwrite if anything bad happens
  set -l tmp_file (mktemp)

  # Input loop
  set -x recorded_args 0
  set -l last_status 0

  while true
    set recorded_args (math $recorded_args + 1)
    __fishnet_setStatus $last_status
    read \
      --right-prompt=__fishnet_print_counter \
      --prompt=fish_prompt \
      --shell \
      command
    if test $status != 0 -o "$command" = exit
      set recorded_args (math $recorded_args - 1)
      break
    end
    echo -n "$command" >> "$tmp_file"
    echo -ne "\0" >> "$tmp_file"
    eval "$command"
    set last_status $status
  end

  # Commit recorded sequence
  mv "$tmp_file" "$file"

  echo "Completed recording $recorded_args commands for \"$argv[1]\""
end


function fishnet
  # Use our symlinked history file
  set -lx fish_history fishnet

  switch "$argv[1]"
    case 'record'
      __fishnet_record "$argv[2..-1]"
    case 'run'
      __fishnet_playback "$argv[2..-1]"
    case '*'
      __fishnet_err 'Usage: fishnet COMMAND NAME'
      __fishnet_err
      __fishnet_err 'Simple record/replay utility for fish'
      __fishnet_err
      __fishnet_err 'COMMAND'
      __fishnet_err '  record Begins a new recording'
      __fishnet_err '  run    Replays an existing recording'
      __fishnet_err
      __fishnet_err 'NAME'
      __fishnet_err '  Name of the recording'
      return 127
  end
end
