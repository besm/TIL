# "Compiling and Installing Emacs 27.2 on Ubuntu"
## 2021-05-07

```bash
sudo apt install build-essential texinfo libx11-dev libxpm-dev libjpeg-dev libpng-dev libgif-dev libtiff-dev libgtk2.0-dev libncurses-dev libgnutls28-dev libjansson-dev
wget https://ftp.gnu.org/gnu/emacs/emacs-27.2.tar.gz
tar -xvzf emacs-27.2.tar.gz && rm emacs-27.2.tar.gz
cd emacs-27.2
./configure --with-json
make && sudo make install
```
