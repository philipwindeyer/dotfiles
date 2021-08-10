#!/bin/zsh

echo "Might need ya password ey. Might not. If it asks, plz gib"

sudo -v
while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done 2>/dev/null &

echo "This might take a bit. If you happen to have Google Drive installed or other network shares open, stop/cmd+c this then close/eject them ('find'ing from root includes everything visible on the file system), then run again"

IFS=$'\n'
BULLSHIT=$(sudo find / -iname "*zscaler*" 2>/dev/null)

echo "Found this bullshit:"
echo $BULLSHIT

read "DOIT?Wanna nuke the shit out of all of it? Type 'yes' if so: "

if [[ "$DOIT" == "yes" ]]; then
  while IFS= read -r nugget; do
    sudo rm -Rf $nugget
  done <<< $BULLSHIT

  echo "Nuked! 2 more steps before it's gone though"

  echo "Step 2: Open 'System Preferences' -> 'Network' -> 'Wi-Fi' -> 'Advanced...' -> 'Proxies' -> 'Automatic Proxy Configuration'"
  echo "Delete the value in 'URL' and make sure 'Automatic Proxy Configuration' is deselected. Then click 'OK', then 'Apply'"

  echo -e "\n\nStep 3: (almost done) RESTART YO COMPOODER! You should be free of that stupid thing that requires your to restart 4 times a day just so you can do what you're employed to do, while it claims to be protecting you while you do what you do. Define irony lol kthxbye"

else
  echo "kden, bai 👋"
fi
