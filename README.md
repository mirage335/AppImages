# AppImages [![discourse](https://img.shields.io/badge/forum-discourse-orange.svg)](http://discourse.appimage.org) [![Build Status](https://travis-ci.org/probonopd/AppImages.svg)](https://travis-ci.org/probonopd/AppImages) [![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/probonopd/AppImageKit?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge) [![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=ZT9CL8M5TJU72)

Significant upstream projects have started providing their own AppImages of releases and/or nightly/continuous builds, see this [list of upstream-provided AppImages](https://github.com/probonopd/AppImageKit/wiki/AppImages#upstream-appimages).
 
This repository contains some recipes to generate __AppImages__ (portable Linux apps) using [AppImageKit](https://github.com/probonopd/appimagekit). See the [Bintray page](https://bintray.com/probono/AppImages) tab for downloads of the generated AppImages.

__Recipes__ are the scripts used to create the AppImages, and __Dockerfiles__ are used to build [Docker images on Docker Hub](https://hub.docker.com/r/probonopd/appimages/) (think of them as glorified `chroot` environments) in which the recipes can run. Finally, everything is tied together using travis-ci which uses Docker containers created by the Dockerfiles from this repository to generate AppImages using the recipes from this repository. The result are AppImages are uploaded to a Bintray repository and can run on most modern desktop Linux distributions.

This repository is intended to showcase the [AppImage](http://appimage.org) format and [AppImageKit](https://github.com/probonopd/AppImageKit) software used to create AppImages. Upstream projects are encouraged to use this showcase to produce their own __upstream packaging__ AppImages, as some projects (like [Subsurface](https://subsurface-divelog.org) already do).

## Usage

There are [multiple ways](https://github.com/probonopd/AppImageKit/wiki/Creating-AppImages) to generate AppImages. If you already have existing binaries (either in archive or `.deb` format or a ppa) then the recommended way to convert these to an AppImage is to write a [.yml description file](https://github.com/probonopd/AppImages/tree/master/recipes/meta) and run it with the [meta recipe bash script](https://github.com/probonopd/AppImages/tree/master/recipes/meta/Recipe):

To build an AppImage from a `.yml` description file:

```
./build _setup
./build ./recipes/App/App.yml
```

`.yml` description files tell the recipe where to get the ingredients from, and how to convert them to an AppImage (besides the general steps already included in the meta recipe). Study some [examples](https://github.com/probonopd/AppImages/tree/master/recipes/meta) to see how it works.

When necessary it is also possible to overload any function/variable in the build script using an "ops" shell script in the same directory as the `.yml` configuration, or the build script itself. It is also possible to directly use shell script formatted configuraton files instead of `.yml`. Further, there is no requirement that the configuration file be in any particular directory, though some resources may be created under the script's directory.

## Containment

Build script can be trivially confined to a DockerApp container given only necessary resources.

./appfactory/anchor ./build _setup
./anchor _setup

## Motivation

Linus addresses some core issues of Linux on the desktop in his [DebConf 14_ QA with Linus Torvalds talk](https://www.youtube.com/watch?v=5PmHRSeA2c8). At 05:40 Linus highlights application packaging: 

> I'm talking about actual application writers that want to make a package of their application for Linux. And I've seen this firsthand with the other project I've been involved with, which is my divelog application.

Obviously Linus is talking about [Subsurface](https://subsurface-divelog.org). 

> We make binaries for Windows and OS X. 

[subsurface-4.5.exe](https://subsurface-divelog.org/downloads/subsurface-4.5.exe) for Windows is 83.5 MB large, [Subsurface-4.5.dmg](https://subsurface-divelog.org/downloads/Subsurface-4.5.dmg) for Mac weighs in at 38.3 MB.

Both bundle not only the application itself, but also the required Qt libraries that the application needs to run. Also included are dependency libraries like `libssh2.1.dylib`and `libzip.2.dylib`.

> We basically don't make binaries for Linux. Why? Because binaries for Linux desktop applications is a major f*ing pain in the ass. Right. You don't make binaries for Linux. You make binaries for Fedora 19, Fedora 20, maybe there's even like RHEL 5 from ten years ago, you make binaries for debian stable.

So why not use the same approach as on Windows and OS X, namely, treat the base operating system as a _platform_ on top of which we tun the application we care about. This means that we have to bundle the application with all their dependencies that are _not_ part of the base operating system. Welcome [application bundles](https://blogs.gnome.org/tvb/2013/12/10/application-bundles-for-glade/).

[Here](https://github.com/probonopd/AppImages/releases/tag/1) is is an AppImage of Subsurface, built from the latest git sources in a CentOS 6 chroot using this [recipe](https://github.com/probonopd/AppImages/blob/master/recipes/subsurface/Recipe). Just download, `chmod a+x`, and run. At 49 MB, the AppImage is roughly in line with the binaries for Windows and OS X. With some more hand-tuning, the size could probably be brought further down. So far, the AppImage has been verified to run on
 * CentOS-6.7-x86_64-LiveCD.iso
 * CentOS-7.0-1406-x86_64-GnomeLive.iso
 * CentOS-7-x86_64-LiveGNOME-1503.iso
 * Chromixium-1.5-amd64.iso
 * debian-live-8.2.0-amd64-cinnamon-desktop.iso
 * debian-live-8.2.0-amd64-gnome-desktop+nonfree.iso
 * elementary_OS_0.3_freya_amd64.iso
 * Fedora-Live-Desktop-x86_64-20-1.iso
 * Fedora-Live-Workstation-x86_64-22-3.iso
 * Fedora-Live-Workstation-x86_64-23-10.iso
 * kali-linux-2.0-amd64.iso
 * Mageia-5-LiveDVD-GNOME-x86_64-DVD.iso
 * openSUSE-Tumbleweed-GNOME-Live-x86_64-Current.iso (20151012)
 * openSUSE-Tumbleweed-KDE-Live-x86_64-Current.iso (20151022)
 * tanglu-3.0-gnome-live-amd64.hybrid.iso
 * trisquel_7.0_amd64.iso
 * ubuntu-12.04.5-desktop-amd64.iso
 * ubuntu-14.04.1-desktop-amd64.iso
 * ubuntu-15.04-desktop-amd64.iso
 * ubuntu-15.10-desktop-amd64.iso
 * ubuntu-gnome-15.04-desktop-amd64.iso
 * ubuntu-gnome-15.10-desktop-amd64.iso
 * wily-desktop-amd64.iso
 * xubuntu-15.04-desktop-amd64.iso

But we also target 32-bit systems like
 * CentOS-6.4-i386-LiveDVD.iso
 * CentOS-6.5-i386-LiveCD.iso
 * CentOS-6.7-i386-LiveCD.iso
 * debian_7.0.0_wheezy_i386_20130705_binary.hybrid.iso
 * debian-live-7.5.0-i386-gnome-desktop.iso
 * Fedora-Live-Design-suite-i686-20-1.iso
 * Fedora-Live-Desktop-i686-19-1.iso
 * Fedora-Live-Desktop-i686-20-1.iso
 * Fedora-Live-Xfce-i686-20-1.iso
 * kali-linux-1.0.7-i386.iso
 * openSUSE-13.1-GNOME-Live-i686.iso
 * openSUSE-Tumbleweed-GNOME-Live-i686-Snapshot20151012-Media.iso (20151012)
 * tails-i386-1.5.iso
 * ubuntu-11.04-desktop-i386.iso
 * ubuntu-12.04.2-desktop-i386.iso

> Or actually you don't make binaries for debian stable because debian stable has libraries that are so old that anything that was built in the last century doesn't work. But you might make binaries for debian... whatever the codename is for unstable. And even that is a major pain because (...) debian has those rules that you are supposed to use shared libraries. Right. 

Note that the AppImage runs not only on debian stable, but even on debian __oldstable__ (which is wheezy at this time).

Most likely it will run on others, too - and with some fine-tuning of the [recipe](https://github.com/probonopd/AppImages/blob/master/recipes/subsurface/Recipe) (i.e., bundling additional dependencies) even more.

> And if you don't use shared libraries, getting your package in, like, is just painful. 

"Getting your package in" means that the distribution accepts the package as part of the base operating system. For an application, that might not be desired at all. As long as we can package the application in a way that it seamlessly runs on top of the base operating system. 

> But using shared libraries is not an option when the libraries are experimental and the libraries are used by two people and one of them is crazy, so every other day some ABI breaks. 

One simple way to achieve this is to bundle private copies of the libraries in question with the application that uses them. Preferably in a way that does not interfere with anything else that is running on the base operating system. Note that this does not have to be true for all libraries; core libraries that are matured, have stable interfaces and can reasonably expected to be present in all distributions do not necessarily have to be bundled with the application.

> So you actually want to just compile one binary and have it work. Preferably forever. And preferably across all Linux distributions. 

That is actually possible, as long as you stay away from any distribution-specific packaging, and as long as you do not use a too recent build system. The same will probably be true for Windows and OS X - if you compile on OS X 10.11 then I would not expect the resulting build products to run on OS X 10.5.

> And I actually think distributions have done a horribly, horribly bad job. 

Distributions are all about building the base operating system. But I don't think distributions are a good way to get applications. Rather, I would prefer to get the latest versions of applications directly from the people who write them. And this is already a reality for software like Google Chrome, Eclipse, Arduino and other applications. Who uses the (mostly outdated and changed) versions that are part of the distributions? Probably most people don't.

> One of the things that I do on the kernel - and I have to fight this every single release and I think it's sad - we have one rule in the kernel, one rule: we don't break userspace. (...) People break userspace, I get really, really angry. (...) 

Excellent. Thank you for this policy! This is why I can still run the Mosaic browser from over a decade ago on modern Linux-based operating systems. (I tried and it works.)

> And then all the distributions come in and they screw it all up. Because they break binary compatibility left and right. 

Luckily, binaries built on older distributions tend to still work on newer distributions. At least that has been my experience over the last decade with building application bundles using AppImageKit, and before that, klik.

> They update glibc and everything breaks. (...) 

There is a [way around this](https://blogs.gnome.org/tvb/2013/12/14/application-bundles-revisited/), although not many people actually care to use the workaround (yet).

> So that's my rant. And that's what I really fundamentally think needs to change for Linux to work on the desktop because you can't have applications writers to do fifteen billion different versions.

AppImage to the rescue. The AppImage format is a standardized format for packaging applications in a way that allows them to run on target systems without further modification. The AppImage format (which basically is an ISO that gets mounted when you run the application) has been created with specific objectives in mind, which are explained in more detail in the [AppImageKit README](https://github.com/probonopd/AppImageKit/blob/master/README.md):

1. Be Simple
2. Maintain binary compatibility 
3. Be distribution-agnostic 
4. Remove the need for installation
5. Keep apps compressed all the time
6. Allow to put apps anywhere
7. Make applications read-only
8. Do not require recompilation (not always desired or possible)
9. Keep base operating system untouched
10. Do not require root

I would welcome people writing applications to pick this up as an easy way to provide nightly builds that run (almost) everywhere and leave no traces in the base operating system. Some upstream projects like [Glade](https://github.com/GNOME/glade/tree/master/build/linux), [Gstreamer](http://lists.freedesktop.org/archives/gstreamer-bugs/2014-May/124914.html), and [Pitivi](http://pitivi.ecchi.ca/bundles/) have been building AppImages. There are more [sophisticated](http://0pointer.net/blog/revisiting-how-we-put-together-linux-systems.html) [approaches](https://wiki.gnome.org/Projects/SandboxedApps) in the works, which I welcome, but in the meantime here is something reasonably simple, universal, and robust that works today.

## Screenshots

Fedora 22 (Twenty Two) - Fedora-Live-Workstation-x86_64-22-3.iso

![fedora](https://cloud.githubusercontent.com/assets/2480569/10559493/0e837b86-74f2-11e5-94e1-56f901c51f6e.png)

CentOS Linux 7 (Core) - CentOS-7.0-1406-x86_64-GnomeLive.iso

![centos](https://cloud.githubusercontent.com/assets/2480569/10559404/919d607e-74f0-11e5-8816-e9032c25cdcd.png)

Ubuntu 14.04.1 LTS (Trusty Tahr) - ubuntu-14.04.1-desktop-amd64.iso

![ubuntu](https://cloud.githubusercontent.com/assets/2480569/10559436/02930bb2-74f1-11e5-88d0-2f8ce82e8846.png)

openSUSE Tumbleweed (20151012) - openSUSE-Tumbleweed-GNOME-Live-x86_64-Current.iso

![opensuse](https://cloud.githubusercontent.com/assets/2480569/10559386/f4bdc906-74ef-11e5-87b7-98d9033d1252.png)


## Miscellaneous

### Uploading AppImages to Bintray

The script [bintray.sh](https://github.com/probonopd/AppImages/blob/master/bintray.sh) can be used by anyone to upload AppImages to Bintray.

The script will:

1. Extract metadata from the AppImage
2. Make the AppImage updatable with zsync
3. Upload the AppImage to Bintray

In order to use `bintray.sh` you must first define your Bintray credentials in the environment. In order to get your Bintray API Key, you need to enter the "API Key" section in https://bintray.com/profile/edit

Example:
```
wget https://raw.githubusercontent.com/probonopd/AppImages/master/bintray.sh
export BINTRAY_USER=<Your Bintray username>
export BINTRAY_REPO=<Your Bintray repository>
export BINTRAY_REPO_OWNER=<Your bintray Organization (optional)>
export BINTRAY_API_KEY=<Your Bintray API Key>
./bintray.sh "Subsurface-4.5.1.667-x86_64.AppImage"
```

If you use Travis for CI, you can define these variables in the Travis control panel, specially the `BINTRAY_API_KEY`, in order to keep it secure.

## Contributing

You are invited to contribute to the AppImage format, the AppImageKit tools, and the example AppImages provided by us).

The preferred channel of communication for general questions and remarks is our forum and mailing list at http://discourse.appimage.org/.

For technical contibutions, https://github.com/probonopd/AppImageKit - please file [Issues](https://github.com/probonopd/AppImageKit/issues) (also for wishlist items or discussion topics) or submit [Pull requests](https://github.com/probonopd/AppImageKit/pulls).

There is also the #AppImage IRC channel on irc.freenode.net and we use [Gitter](https://gitter.im/probonopd/AppImageKit) which has the advantage that one does not have to be online all the time and one can communicate despite not being in the same timezone.

## Donations

[![Donate](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=ZT9CL8M5TJU72)

## Acknowledgments

This project would not have been possible without the contributors to AppImageKit and without the services which generously support Open Source projects:

* [JFrog](https://www.jfrog.com) for providing [Bintray](https://bintray.com), the distribution platform used to distribute AppImages built by the recipes in this project to users. Bintray has been truly invaluable for this project since it not only provides us with free hosting and traffic for our AppImages, but also makes it really easy to set up a repository for custom binary formats such as AppImage, and to maintain the metadata associated with the downloads. Thanks to the easy-to use REST API, we were able to set up an automated workflow involving GitHub and Travis CI to build, upload and catalog AppImages in no time. Also, JFrog Bintray relieved us from the burden to create a web UI for the repository by providing a generic one out-of-the-box. 
* [Travis CI](https://travis-ci.org) for providing cloud-based test and build services that are easy to integrate with GitHub.
* [GitHub](https://travis-ci.org) for making it possible to work on Code in the Cloud, and for making it super easy to contribute to Open Source projects.
