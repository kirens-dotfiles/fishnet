function __fishnet_list_records
  ls "$HOME/.local/share/fish/fishnet_records/"
end

function __fishnet_complete_cond_arg_count
  test (count (commandline -poc)) $argv
end

function __fishnet_complete_files
  set -l cmd (commandline -poc)

  # If completing first word
  if test (count $cmd) -lt 3
    __fishnet_list_records
    return 0
  end

  # If some words have been given
  set -l first "$cmd[3..-1]"
  set -l length (echo $first | wc -c)
  set -l start (math $length + 1)
  for file in (__fishnet_list_records)
    if test "$first " = (string sub --length $length "$file")
      echo (string sub --start $start "$file")
    end
  end
end

function __fishnet_complete_cond_files
  set -l cmd (commandline -poc)
  test "$cmd[2]" = "run"
end

complete --command fishnet --erase
complete --command fishnet --no-files
complete --command fishnet --arguments record \
  --description 'Record a new fishnet' \
  --condition '__fishnet_complete_cond_arg_count -le 1'

complete --command fishnet --arguments run \
  --description 'Playback a fishnet' \
  --condition '__fishnet_complete_cond_arg_count -le 1'

complete --command fishnet \
  --arguments='(__fishnet_complete_files)' \
  --description 'A recording' \
  --condition '__fishnet_complete_cond_files'
