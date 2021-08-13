# Firefox Quick Keywords
dmenu or rofi launcher to open firefox bookmarks with keywords quickly

## Installing firefox-quick-keywords

> Requires [rofi](https://github.com/davatorium/rofi) or [dmenu](https://tools.suckless.org/dmenu/)

```sh
git clone https://github.com/GRFreire/firefox-quick-keywords $HOME/.local/share/firefox-quick-keywords

ln -s $HOME/.local/share/firefox-quick-keywords/firefox-quick-keywords $HOME/.local/bin/firefox-quick-keywords
```

After that, just run ```firefox-quick-keywords``` in your terminal

## Update

Go to ```$HOME/.local/share/firefox-quick-keywords``` and update the repo.

```sh
cd $HOME/.local/share/firefox-quick-keywords
git pull
```
