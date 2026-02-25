# BannerFX-Termux

BannerFX-Termux is a Termux script to customize your terminal with a hacker-style banner using `figlet` and `lolcat`.

## Features

- Interactive menu.
- Banner name customization.
- Multiple modern styles.
- Preview before install.
- Optional random mode.
- Save/load profiles.
- Install and uninstall startup banner in `.bashrc`.

## Requirements (Termux)

- Termux
- `figlet`
- `ruby` (for `gem`)
- `lolcat`

## Quick Install (Termux)

```bash
pkg update -y && pkg upgrade -y && pkg install -y git && ( [ -d BannerFX-Termux/.git ] && cd BannerFX-Termux && git pull || git clone https://github.com/hackcrist/BannerFX-Termux.git && cd BannerFX-Termux ) && sed -i 's/\r$//' install.sh banner-hacker.sh && chmod +x install.sh && bash install.sh
```

## Step-by-step Install

```bash
pkg update && pkg upgrade -y
pkg install -y git

git clone https://github.com/hackcrist/BannerFX-Termux.git
cd BannerFX-Termux
sed -i 's/\r$//' install.sh banner-hacker.sh
chmod +x install.sh
bash install.sh
```

## Usage

Run from any folder:

```bash
bannerfx
```

Or run directly from repository:

```bash
bash banner-hacker.sh
```

## Update

```bash
cd ~/BannerFX-Termux
git pull
chmod +x install.sh
bash install.sh
```

## Uninstall

```bash
cd ~/BannerFX-Termux
chmod +x uninstall.sh
bash uninstall.sh
```

## Troubleshooting

If you get `syntax error: unexpected end of file`, convert line endings to LF and retry:

```bash
sed -i 's/\r$//' install.sh uninstall.sh banner-hacker.sh
chmod +x install.sh uninstall.sh banner-hacker.sh
bash install.sh
```

If `bannerfx` is not found after install:

```bash
hash -r
source ~/.bashrc
bannerfx
```

## Files

- `banner-hacker.sh`: main script.
- `install.sh`: Termux installer.
- `uninstall.sh`: removes command and startup banner.

## Author

hackcrist

## License

This project is licensed under Apache License 2.0.
See `LICENSE` and `NOTICE` for details.

