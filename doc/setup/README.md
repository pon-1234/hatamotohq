# Installing Ruby 2.6.3 with rbenv

```
# You might need to install some package if missing
apt-get update --fix-missing
apt install -y libssl-dev libreadline-dev zlib1g-dev libmysqlclient-dev gcc g++ make

git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
exec $SHELL
git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build
rbenv install 2.6.3

```

# Install node js and yarn

```
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt-get install -y nodejs
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update && sudo apt install yarn
```

# Install redis

```
sudo add-apt-repository ppa:redislabs/redis
sudo apt-get update
sudo apt-get install redis
```

# Enable sidekiq service

Run `sudo visudo` and insert below line
`%sudo ALL=NOPASSWD:/bin/systemctl restart sidekiq`

Create a file name `sidekiq.service` and copy content from config/service/sidekiq.service and locate it on /lib/systemd/system.

# Install and enable puma

```
gem install puma
```

Run `sudo visudo` and insert below line
`%sudo ALL=NOPASSWD:/bin/systemctl restart kenkoupoint_puma`

Create a file name `puma.service` and copy content from config/servie/puma.service and locate it on /lib/systemd/system.

# Install imagemagick

```
# Install on Ubuntu < 20
1. uncomment deb-src http://us.archive.ubuntu.com/ubuntu/ bionic main restricted in /etc/apt/sources.list
2. install dependencies
sudo apt update
sudo apt build-dep imagemagick
wget https://www.imagemagick.org/download/ImageMagick.tar.gz
tar xvzf ImageMagick.tar.gz
./configure
make
sudo make install
sudo ldconfig /usr/local/lib

# Install libpng for Ubuntu 20
sudo apt-get install autoconf automake autopoint autotools-dev build-essential chrpath cm-super-minimal debhelper dh-autoreconf dh-exec dh-strip-nondeterminism doxygen doxygen-latex dpkg-dev fonts-lmodern g++ g++-7 gcc gcc-7 gir1.2-harfbuzz-0.0 graphviz icu-devtools libann0 libasan4 libatomic1 libbz2-dev libc-dev-bin libc6-dev libcairo-script-interpreter2 libcairo2-dev libcdt5 libcgraph6 libcilkrts5 libclang1-6.0 libdjvulibre-dev libexif-dev libexpat1-dev libfftw3-bin libfftw3-dev libfftw3-long3 libfftw3-quad3 libfile-stripnondeterminism-perl libfontconfig1-dev libfreetype6-dev libgcc-7-dev libgdk-pixbuf2.0-dev libglib2.0-dev libglib2.0-dev-bin libgraphite2-dev libgts-0.7-5 libgvc6 libgvpr2 libharfbuzz-dev libharfbuzz-gobject0 libice-dev libicu-dev libicu-le-hb-dev libicu-le-hb0 libilmbase-dev libitm1 libjbig-dev libjpeg-dev libjpeg-turbo8-dev libjpeg8-dev liblab-gamut1 liblcms2-dev liblqr-1-0-dev liblsan0 libltdl-dev liblzma-dev libmime-charset-perl libmpx2 libopenexr-dev libpango1.0-dev libpathplan4 libpcre16-3 libpcre3-dev libpcre32-3 libpcrecpp0v5 libperl-dev libpixman-1-dev libpng-dev libpotrace0 libptexenc1 libpthread-stubs0-dev libquadmath0 librsvg2-bin librsvg2-dev libsigsegv2 libsm-dev libsombok3 libstdc++-7-dev libtexluajit2 libtiff-dev libtiff5-dev libtiffxx5 libtool libtool-bin libtsan0 libubsan0 libunicode-linebreak-perl libwmf-dev libx11-dev libxau-dev libxcb-render0-dev libxcb-shm0-dev libxcb1-dev libxdmcp-dev libxext-dev libxft-dev libxml2-dev libxml2-utils libxrender-dev libxt-dev libzzip-0-13 linux-libc-dev m4 make pkg-config pkg-kde-tools po-debconf preview-latex-style tex-common texlive-base texlive-binaries texlive-extra-utils texlive-font-utils texlive-fonts-recommended texlive-latex-base texlive-latex-extra texlive-latex-recommended texlive-pictures x11proto-core-dev x11proto-dev x11proto-xext-dev xorg-sgml-doctools xsltproc xtrans-dev zlib1g-dev

wget https://www.imagemagick.org/download/ImageMagick.tar.gz
tar xvzf ImageMagick.tar.gz
cd ImageMagick-7.0.8-26/
./configure
make
sudo make install
sudo ldconfig /usr/local/lib
apt install webp
```

# Install ffmpeg

https://linuxize.com/post/how-to-install-ffmpeg-on-ubuntu-18-04/

# Deployment

`cap {env} deploy`

# Enable timezone support

Follow this below url: https://github.com/ankane/groupdate#additional-instructions

# Install elastic plugin for japanese

sudo bin/elasticsearch-plugin install analysis-kuromoji
