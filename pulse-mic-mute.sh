#!/bin/sh
## from here: https://askubuntu.com/questions/12100/command-to-mute-and-unmute-a-microphone

pacmd list-sources | awk '\
  BEGIN {default_found=0;}

/^[\t ]*\*/ {default_found=1;}

/^[\t ]*name:/ {
if (default_found) {
  name=$2;
  gsub("[<>]", "", name);
}
}

/^[\t ]*muted:/ {
if (default_found) {
  if ($2=="yes") {
    mute=0;
    icon="microphone-sensitivity-medium";
    status="unmuted"
  } else {
  mute=1;
  icon="microphone-sensitivity-muted";
  status="muted"
}
system("pacmd set-source-mute " name " " mute);
system("notify-send --icon " icon " Microphone: " status);
exit;
}
}

/^[\t ]*index:/{if (default_found) exit;}'
