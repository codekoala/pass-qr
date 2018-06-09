<h1 align="center">pass qr</h1>
<p align="center">
    A <a href="https://www.passwordstore.org/">pass</a> extension that quickly
    generates a QR code for passwords using fzf or rofi.
</p>

## Description
`pass qr` extends the pass utility with a short command to generate and display
a QR code for an existing password. This is useful when, for example, you don't
have your password store on your cell phone but want to quickly use a password.

## Usage

```
Usage:
    pass qr [options]
        Provide an interactive solution to generate QR codes for existing
        passwords. It will show all pass-names in either fzf or rofi, waits for
        the user to select one, then displays a QR code for the password.

        The user can select fzf or rofi by giving either --fzf or --rofi.
        By default, rofi will be selected and pass-qr will fallback to
        fzf.

    Options:
        -f, --fzf        Use fzf to select pass-name.
        -r, --rofi       Use rofi to select pass-name.
```

## Installation

### Requirements

* `pass 1.7.0` or greater.
* If you do not want to install this extension as system extension, you need to
  enable user extension with `PASSWORD_STORE_ENABLE_EXTENSIONS=true pass`. You
  can create an alias in `.bashrc`: `alias pass='PASSWORD_STORE_ENABLE_EXTENSIONS=true pass'`

### From git

```sh
git clone https://github.com/codekoala/pass-qr/
cd pass-qr
sudo make install  # For OSX: make install PREFIX=/usr/local
```

### ArchLinux

`pass-qr` is available in the [Arch User Repository][aur].
```sh
pacaur -S pass-qr  # or your preferred AUR install method
```

## Contribution

Feedback, contributors, pull requests are all very welcome.

## Acknowledgments

Thanks to the following projects, which I used as templates for `pass-qr`:

* [pass-update](https://github.com/roddhjav/pass-update)
* [pass-clip](https://github.com/ibizaman/pass-clip)

## License

    Copyright (C) 2018 Josh VanderLinden

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

[aur]: https://aur.archlinux.org/packages/pass-qr
