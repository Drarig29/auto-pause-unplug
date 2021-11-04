# auto-pause-unplug

A script which automatically pauses your music when you unplug your headphones or disconnect your Bluetooth device.

You can tweak it to meet your needs.

Dependencies:

- Pulse Audio for `pactl`
- [playerctl](https://github.com/altdesktop/playerctl)

## Usage

Download this script or clone the repository.

Then, symlink it somewhere like `/usr/bin/auto-pause-unplug`:

```bash
ln -s ~/path/to/auto-pause-unplug.sh /usr/bin/auto-pause-unplug
```

**Warning:** this file contains an infinite loop, so you need to run the command in the background with `&`, otherwise your desktop environment is likely to freeze when you log in.

I personally used `~/.xprofile`, here is its content:

```bash
#!/bin/bash
exec /usr/bin/auto-pause-unplug &
```

## How it works?

- It uses `pactl subscribe`, so no polling is involved
- Any existing instance of the script is killed
- All errors are ignored so that the program doesn't stop unexpectedly
- When a `change` event is detected on a Pulse Audio card, it checks if the active port is something else than the headphones
- If it's the case, we assume the headphones were just unplugged (I didn't have any false positive yet)
- We then pause the playing media with `playerctl`

You can view the logs using `journalctl`: 

```bash
journalctl -b | grep -E "\[$(pidof -x /usr/bin/auto-pause-unplug)\]"
```

