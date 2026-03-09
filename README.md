# macOS Keep Audio Alive

Prevents USB/wireless audio devices from sleeping or disconnecting due to inactivity on macOS.

Many USB and wireless audio devices (headsets, DACs, speakers) will enter a low-power sleep state when no audio is playing. This causes annoying reconnection delays, audio pops, or missed notifications when sound resumes. This project uses a macOS LaunchAgent to continuously output a silent audio stream to your device, keeping it awake at all times.

## How It Works

Uses [SoX](https://sox.sourceforge.net/) to generate a continuous silent sine wave (0 Hz at 0 volume) directed at a specific CoreAudio output device. A LaunchAgent ensures this runs automatically on login and restarts if interrupted.

## Prerequisites

- macOS (tested on macOS Sequoia / Apple Silicon)
- [Homebrew](https://brew.sh)

## Quick Setup

### 1. Install SoX

```bash
brew install sox
```

### 2. Find Your Audio Device Name

List available CoreAudio output devices:

```bash
sox -n -t coreaudio "?" synth sine 0 vol 0 2>&1
```

This will print an error along with a list of available device names. Copy the exact name of the device you want to keep alive.

### 3. Run the Install Script

```bash
chmod +x install.sh
./install.sh "Your Device Name"
```

This will:
- Generate the LaunchAgent plist for your device
- Install it to `~/Library/LaunchAgents/`
- Load it immediately

### Manual Setup

If you prefer to set it up manually, copy `com.keepaudioalive.plist.template` to `~/Library/LaunchAgents/com.keepaudioalive.plist`, replace `{{DEVICE_NAME}}` with your device name, then load it:

```bash
launchctl load ~/Library/LaunchAgents/com.keepaudioalive.plist
```

## Verify It's Running

```bash
launchctl list | grep keepaudioalive
```

You should see a line with a PID and exit status `0`.

## Uninstall

```bash
./uninstall.sh
```

Or manually:

```bash
launchctl unload ~/Library/LaunchAgents/com.keepaudioalive.plist
rm ~/Library/LaunchAgents/com.keepaudioalive.plist
```

## Troubleshooting

- **Device not found**: Make sure the device name exactly matches what `sox -n -t coreaudio "?" synth sine 0 vol 0 2>&1` reports.
- **SoX not found**: Ensure SoX is installed at `/opt/homebrew/bin/sox` (Apple Silicon) or `/usr/local/bin/sox` (Intel). Update the plist path if different — the install script handles this automatically.
- **Agent not starting**: Check logs with `launchctl list | grep keepaudioalive`. A `-` in the PID column means it's not running; check the exit code for clues.

## License

MIT
