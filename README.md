## the sonaremin

![sonaremin image 01](https://github.com/hexdump0815/sonaremin/raw/master/images/sonaremin-01.jpg "sonaremin image 01")

welcome to the wonderful world of the sonaremin. the name sonaremin is combined from the latin word for sound: sonare and the end of theremin, the name of an unconventional instrument for its time in the 1920s. what is the sonaremin? it is following the philosophy of modular synthesizers by plugging together several excellent open source software projects to create something new. those projects are: vcvrack, raveloxmidi, jack, xpra, overlayroot, fluxbox, linux, ubuntu and many more. the goal is to create a a very flexible and easy to use device which can be used to create electronic music without the need of a computer. as soon as it gets plugged into the power socket it will start and it will be ready in about a minute. one just needs to connect a midi controller to it for playing it and at the end it can simply be unplugged from power to turn it off.

for creating sounds it uses the wonderful vcvrack modular synthesizer by running special sound-patches created for it, which can then be played and/or manipulated by a connected midi controller. the sonaremin has two modes of operation: display mode and virtual mode.

besides that it might also be used as a good prototyping platform for audio experiments running on linux and small arm based computers. it runs on multiple devices, is based on a recent mainline linux kernel (4.19 and 5.0 right now), a long term supported standard ubuntu distribution (18.04 lts), it has some audio optimizations applied and has gpu accelerated opengl support (as good as possible for the different devices).

IMPORTANT: in case you run into problems with vcvrack on the sonaremin, please create an issue in this git repo and not in the vcvrack repo, as the problems might be related to the sonaremin and not to vcvrack in general

# changelog

version 1.1.6_8
- using a new vcvrack build (1.1.16_5 - 25.08.2020) with 162 open source plugins included resulting in 1700+ vcvrack modules!
- allow setting a default kbd language for the display mode in sonaremin.txt config file
- linux kernel and mesa 3d graphics library (where used) updated
- raspberry pi kernel updated to v5.8.2 - still limited to using 1gb ram on the 1/2/4gb model - the 8gb model still does not work yet
- small fixes here and there

version 1.1.6_7
- add support for odroid u3, odroid xu4 and an allwinner h3 tv box

version 1.1.6_6
- using a new vcvrack build (1.1.16_4 - 17.07.2020) with 150 open source plugins included resulting in 1640 vcvrack modules!
- it is now possible to set the sampling frequency in the sonaremin.conf (22050, 32000, 44100 or 48000 khz) to save cpu power or gain better quality
- small fixes here and there
- other/newer firmware files for rpi4, but its still only using 1gb or ram for now and still not working at all for the 8gb model

version 1.1.6_5
- remove sfizz samplers - it did not work properly: i often got very high latencies or cpu usage when using the sifzz samplers due to the requirement to have multiple audio interfaces in vcvrack (which is not working very well and very unreliable) to get the sfizz audio back into vcvrack
- allow to disable cpu cores to reduce heat produced
- a lot fo cleanup under the hood
- initial support for some allwinner h6 tv boxes (tested with eachlink mini and q-plus - they have nearly as much cpu power as the raspberry pi 4, but they run very hot and thus need a lot of extra cooling, which is not easy to achieve)
- raspberry pi 4 status: it should work on the 1gb, 2gb and 4gb model (with a hack for now to limit the used ram to 1gb) but it does not work yet on the 8gb model

version 1.1.6_4
- remove support for systems which are simply too slow for the sonaremin in reality (h3 tv boxes, raspberry pi 2)
- remove support for vcvrack v0 (0.6.2c)
- remove support for padthv1 and synthv1

version 1.1.6_3
- same as last version, but with raspberry pi 4 support

version 1.1.6_2
- more included modules (132 plugins = 1450+ vcvrack modules, status 08.04.2020)
- rethought the operational modes
  - display:  with monitor, mouse and keyboard connected
  - virtual:  via xpra and remembering the last file
  - headless: like virtual but always starting with sonaremin.vcv
- the virtual mode now uses the gpu for rendering in all provided images
- better virtual mode due to proper allowCursorLock setting
- easier custom audio device setup for other usb audio interfaces
- extra audio channels for jack in network mode
- add some adapted tinyvcvpatches as sample files (thanks to their creator)

version 1.1.6
- upgrade vcvrack to version v1.1.6
- more included modules (119 plugins = 1350+ vcvrack modules, status 01.02.2020)
- better handling of realtime scheduling priority and cpu affinity - this helps quite a bit on the raspberry pi
- there is now an optimize option in the desktop menu to rerun the realtime scheduling priority and cpu affinity setup whenever needed
- rename headless mode to virtual mode to make room for the upcoming proper headless mode in vcvrack v2
- switch mali gpu based systems to modesetting xorg server plus LIBGL_FB=3 mode of gl4es - this lets the gpu even render the ui if we are in virtual mode via xpra (does not work on the raspberry pi as it is mesa based)
- image building process completely changed - it is way more clean and flexible now
- supported systems: raspberry pi 3b and 3b plus (working much better now), amlogic s905w, s905x and s905 based android tv boxes, odroid c2 (yet untested) - more to come
- work on raspberry pi 4 support has started but is not working yet - meanwhile you can use my raspbian build of vcvrack on raspbian (not as fast as running it in 64bit on the sonaremin, but better than nothing until that is ready)
- upgraded software everwhere: linux kernel is on v5.4 lts now, mesa for the raspberry pi is at v20rc1, gl4es is fresh and the underlying ubuntu is still 18.04 updated to current state

version 1.1.3 (planned only - not released, skipped)
- upgrade vcvrack to version v1.1.3
- more included modules (69 plugins = 870 vcvrack modules)
- as vcvrack v1.1.3 has jack-midi enabled again, provide 4 jack midi connections instead of only one for more flexibility

version 1.1.1
- upgrade vcvrack to version v1.1.1
- more included modules (65 plugins = 772 vcvrack modules)
- more sample patches
- prebuilt images for 64bit raspberry pi, s905w/x tv boxes and the tinkerboard only (more on request - just test an older existing image on your hardware - if it works then just ask me to build a current one as well for it)
- support for realtime mode of vcvrack v1 audio threads (be careful with this together with the overlay mode, it seem to hang the system sometimes)
- padtv1 and synthv1 get their own routing if jack is used (besides a routing with vcvrack together)
- extra-files is no tar file anymore - unpacked now as it is much easier to handle this way and gives a better git history
- lots of minor fixes
- i am no longer testing the vcvrack v0.6.2c installation on the sonaremin - it is still there but untested

version 1.0.0
- support for vcvrack v1.0.0 (v0.6.2c is still part of the sonaremin, but in the exact same version as in sonaremin 0.5.0)
- support for amlogic s905 tv boxes
- with vcvrack v1 the raspberry pi seems to be useable in display mode finally (for v0 it is still discouraged)
- added support to use rtpmini (via raveloxmidi) as input - used for instance in macos as network midi or on windows via tobias erichsen's rtpmidi software
- added support for midi input and audio output via jack net functionality (if enabled no local audio output)
- added support for using 2x padthv1 and/or 2x synthv1 from rncbc.org instead of vcvrack for sound creation
- changed partitioning: less data (512mb should be enough), less swap (if we swap too much with audio we are lost anyway) and more space free in the system (for experiments)
- lots of minor fixes and improvements

version 0.5.0
- initial version

# display mode

in display mode the sonaremin will operate like a regular vcvrack installation: you connect the sonaremin to a hdmi monitor, connect a keyboard, a mouse, maybe a midi controller and an amplifier to it and can create or modify vcvrack patches with it.

# virtual mode

in virtual mode the sonaremin does not need a mouse, a keyboard and a monitor. it will work either completely on its own endlessly playing a generative patch or can be used as an instrument with a midi controller attached. both is possible by simply copying a properly prepared patch to a certain location which it will then automatically use on startup. even in virtual mode it is possible to connect to the sonaremin via ethernet and share the screen with its running vcvrack via the xpra software (https://xpra.org/ - a good commandline on linux for instance is 'xpra --opengl=no --encoding=rgb --title="sonaremin" attach ssh/sonaremin@sonaremin/100'), which offers desktop viewing applications for linux, macos and windows. this mode is only useable for checking the operation or changing some settings (like jack connection or midi learn setup), as in this mode there is no gpu acceleration available for the screen rendering which results in all cpu power being eaten up by the graphics and close to none being left for audio, but for simple tasks this is still sufficent.

# rtpmidi and jack network mode

more info coming soon ...

# supported hardware

the sonaremin currently runs (more or less) on the following arm cpu based devices:

- odroid c2 (pcm2704)
- asus tinkerboard (cooling, pcm2704) and tinkerboard s (untested, cooling, pcm2704)
- raspberry pi in 32bit [3b & 3b+ (untested)] (cooling) and 64bit mode [3b, 3b+ (untested) & 4b] (cooling)
- amlogic s905w/s905x/s905 based android tv boxes (pcm2704) - tested on x96 mini (s905w), t95m (s905x), tx3 mini l (s905w) and mxq pro 4k (the s905 version - beware: there are other versions of this box with the same name with other cpus as well) - it should run on nearly any s905w, s905x, s905 based tv box i guess

the comments in the brackets mean:

- pcm2704: a pcm2704 usb audio adapter is required - you can find it easily for around 3 euro on ebay
- cooling: a fan or really big heat sink is required to cool the device, otherwise it will reduce its cpu performance automatically due to the created heat resulting in degraded audio performance (the tinkerboard will by default be run at a reduced clock speed to avoid the need of a fan, but with a fan it can be run at full speed with more cpu power)
- untested: i have no access to such a device, so i could not test them, but in theory they should work

the basic functionally is the same for all devices, but their cpu performance and thus possible maximum size of the possible patches differs a bit.

as a result recommended is the odroid c2 as it has a good performance and does not need cooling. also recommended are amlogic s905w/s905x based tv boxes as they have a good performance, do not need cooling and are cheap (around 30 euro for a box with 1gb ram, a bit more for a box with 2gb ram which is even better, but 1gb works well too) and come with a case and power supply already. the raspberry pi's are good as well, but need very good cooling.

please keep in mind, that with the exception of the raspberry pi's all other devices will need an extra pcm2704 usb audio adapter (just google for pcm2704, they cost around 3 euro on ebay, have low jitter and good latency - see the pictures in the images folder for which device to get exactly: https://github.com/hexdump0815/sonaremin/raw/master/images/pcm2704-01.jpg and https://github.com/hexdump0815/sonaremin/raw/master/images/pcm2704-02.jpg) as the internal audio is not working well enough for low latency audio or does not support a 32khz sampling frequency. the raspberry pi's work with the built in audio, but it has slightly worse latency and and quality compared to the pcm2704.

the qjackctl in the sonaremin images includes prepatched connections for an akai apc key 25 and for an worlde mini midi controller and the vcvrack patches have their midi-cc connections learned for the akai apc key 25. if any other controller should be used it is required to adjust and save the qjackctl patch configuration and relearn the midi-cc connections in the sample patches to properly use them with other controllers.

# installation

for installing the sonaremin on one of the supported devices the provided images need to be downloaded (see the releases section on github), decompressed (gunzip to get rid of the .gz) and then flashed to an sd card of at least 8gb size (more is not a problem). please refer to the many ressources on the internet on how to decompress the .gz files and how to flash the images properly to an sd card depending on what operating system you are using for this task.

in the case of the amlogic s905w/s905x/s905 tv boxes there is an extra step required to enable multi boot mode. first a disclaimer: this worked for me and for lots of others for many amlogic s905w, s905x and s905 based tv boxes and is usually a very easy and reliable process, but there is always a small risk that it might brick the tv box - you have been warned. the procedure to enable multi boot mode is described here: https://forum.armbian.com/topic/2419-armbian-for-amlogic-s905-and-s905x-ver-544/ - the basic steps relevant are:

- boot the tv box into android with the sonamerin sd card inside
- open the android app "update & backup"
- click on "select" local update and chose the file on the removable media (aml_update.zip) aml_autoscript.zip
- start "update"
- system will reboot twice and then start running the system from the sd card, i.e. sonaremin (without the sd card inside it should still start the regular android of the tv box)

for some devices an adjustment for the dtb file is required - see the comments in the file menu/extlinux.conf (if there are any comments) in the BOOT partition of the written sd card.

# configuration

the basic configuration of the sonaremin device is done in the menu/extlinux.conf file on the BOOT partition of the written sd card (see above as well) for setting the overlayroot mode or not and the file config/sonaremin.txt in the DATA partition of the written sd card: here the display mode (display or virtual) is the most important. besides that it is possible to turn off the audio tuning on boot, turn off the automatic start of qjackctl and vcvrack and change the maximum cpu clock in the case of a tinkerboard to avoid it overheating. it is possible to enable samba to be able to access to the BOOT and DATA partitions over the net as smb shares to change the configuration or to up- or download patches to the sonaremin.

there are more options to configure the sonaremin, which will be described at a later time here (rc.boot-local, rc.xsession-local, config/systems directory, qjackctl directory)

the default patch used in virtual mode is always vcvrack-v1/sonaremin.vcv on the DATA partition of the sd card, so the desired patch to be run in virtual mode should be copied there. by default the generative-01.vcv patch is copied there, so that the sonaremin should give some sound about a minute after it starts if everything is working well. in display mode vcvrack will use the patch last used in display mode - the initial default is the generative-01.vcv sample patch.

the username to use when logging in remotely via ethernet to the sonaremin is "sonaremin" and the password is "sonaremin" as well - please change the password with the "passwd" linux command for security reasons if you plan to connect the device more often to a network. the hostname you should able able to find the device at in the network is "sonaremin" as well and remote login is possible via ssh and in virtual mode an xpra desktop sharing connection is possible too.

in display mode the right mouse button opens a menu to open a terminal window, an editor, start qjackctl, vcvrack (if not already running), select some keyboard layouts, reboot or shutdown the sonaremin. in display mode it should always be shutdown properly via the shutdown or reboot commands. in virtual mode it can be simply powered off without any shutdown assuming it is configured to run in overlayroot mode.

please be aware, that vcvrack will always start in iconified mode in the sonaremin. this is because in in virtual mode otherwise the missing gpu acceleration would result in a lot of cpu being wasted to software-render the ui into nirwana - if started iconified no cpu cycles are used for rendering. in display mode vcvrack has to be deiconified from the applications tab at the bottom of the screen before using it.

# overlayroot mode

by default the sonaremin is running in overlayroot mode, i.e. the rootfilesystem is mounted read-only and and top of that a memory filesystem is mounted read-write. this means, that all changes to the systems are lost when the device is powered off and this allows to simply power off the device without a proper shutdown in virtual mode. the DATA and BOOT partitions are mounted regularly in read-write mode, so that configuration changes done in files located on them and patches saved onto the DATA partition are not lost after a reboot. this is also the reason while various configuration files of qjackctl, vcvrack etc. are symbolically linked from the system partition to the DATA partition.

if permanent changes should be done to the system (for instance installation of software or more fundamental configuration changes) it can be switched between overlayroot and non overlayroot mode in the menu/extlinux.conf file and by rebooting the sonaremin afterwards. do not forget to switch it back to overloayroot mode afterwards. temporary access to the root filesystem in read-write mode is possible with the "overlayroot-chroot" command. to get root simply use "sudo -i".

# upgrading the installed vcvrack version

it is possible to upgrade the vcvrack version used in the sonaremin in case there is a newer build of vcvrack for available at https://github.com/hexdump0815/vcvrack-dockerbuild-v1/releases ... the following is a short summay to do the upgrade (requires some command line experience and assumes a machine with an ssh and scp client installed to connect to the sonaremin)
  ```
  # first switch the sonaremin into no_overlayroot mode by following the comment on top of the
  # menu/extlinux.conf file on the BOOT partition (should be accessible from any linux, macos
  # or windows machine as its a normal dos filesystem) 
  # second disable qjackctl and vcvrack autostart by changing the setting for QJACKCTL_START
  # and VCVRACK_START from "yes" to "no" in config/sonaremin.txt on the DATA partition (should
  # be accessible from any linux, macos or windows machine as its a normal dos filesystem)
  # third start the sonaremin with ethernet connected
  # then download the latest release from the above link - assuming it to be named
  # vcvrack.aarch64-v1.tar.gz in this example now
  # then copy it to the sonaremin
  scp vcvrack.aarch64-v1.tar.gz sonaremin@sonaremin:.
  # then login to the sonaremin - see above for the password
  ssh sonaremin@sonaremin
  # on the sonaremin, unpack the new version - it will take a while
  tar xzf vcvrack.aarch64-v1.tar.gz
  # move aside the old vcvrack version
  mv vcvrack-v1 vcvrack-v1.old
  # move the unpacked new version to its place
  mv vcvrack.aarch64-v1 vcvrack-v1
  # go to the old versions directory and copy some config files over to the new version
  cd vcvrack-v1.old
  cp template.vcv autosave.vcv settings.json ../vcvrack-v1
  # shutdown the sonaremin
  sudo -i
  shutdown -h now
  # undo the changes in menu/extlinux.conf and config/sonaremin.txt above and on the next start
  # the sonaremin should use the new vcvrack version
  ```

# known problems and things to keep in mind

in general the sonaremin already works quite well - this is a list of things i have noticed and which should be kept in mind and maybe should be fixed one day:

- on the raspberry pi there might be display problems (missing rails etc.) if the vcvrack window is large (for istance full hd size)
- there might be sometimes hangs of the system (most probably related to enabling realtime priority in overlay mode)
- on bootup there is an error visible about an fsck problem - this is most probably due to the update-initramfs task in the image creation for some reason does not put the proper fsck binaries into the initramfs - it seems to be no big deal for now though - fixed in 1.0.0
- the tinkerboard does only a shutdown when a reboot is requested - most probably some kernel patch is still missing - i do not see this as a big problem for now - seems to be resolved in 1.0.0
- the allwinner s905 tv boxes might not work with all sd cards - maybe try another one in case you get mmc errors on boot, also some of the usb ports might not work
- tv boxes might also behave strange on shutdown or reboot (for instance do only one of the two, do them in reverse or simply hang in that case) - this is due to the widely variying hardware of those devices
- some devices definitely need a fan for cooling (see hardware section above) - simple passive cooling with a small heat sink is definitely not enough
- on the bananpi m1 i'm getting strange audio dropouts every 10 seconds if no hdmi cable is connected even in virtual mode, as soon as i connect something to the hdmi port, audio is fine
- as all this is running on the arm architecture only non commercial plugins, which are available in source form (so that they can be compiled and included into the sonaremin) can be used, so no bought plugins can be used and some popular other ones cannot be used neither as there is no source code available for them (vult, nysthi, turing machine, ...) - this is less of a problem than it sounds as for many of them there are open sourced alternatives available (for instance the random sampler from audible instruments can take over some tasks of the turing machine)
- those little arm devices have much less cpu power than a normal pc or laptop, thus it is recommended to use modules which use less cpu power for the same task (for instance a lindenberg research vcf filter instead of the fundamental vcf or the lindenberg research woldemar vco instead of the fundamental vco - squinkylabs and bogaudio modules seem to be often very cpu efficient and many others too) - the power meter option in vcvrack is your friend in finding out which modules eat the most cpu (it is normal that the audio output is usually among the most cpu intensive ones, but this is by design and can't be changed)
- all controllers used via midi cc need to be wiggled a bit, so that they transmit their initial settings to vcvrack after startup (only the akai midi mix seems to have a button to send all the current settings at once) - this is not special for the sonaremin, but the way midi-cc works in vcvrack
- network connections are only supported via etherenet (no wlan) and keyboard and mouse have to be usb (no bluetooth)
- patches need to be expicitely configured (qjackctl patching and vcvrack midi learning etc.) in the patch in a display or xpra session first, before they can be used virtual

# technical notes

a lot more info will come here over time - just some basic points already:
- the linux system of the sonaremin is a regular ubuntu 18.04 lts
- the vcvrack is a regular vcvrack, so the patches should be fully compatible with a regular desktop vcvrack as long as all used plugins are available and the sonaremin has enough cpu power for a patch - as a result patches for the sonaremin can also be created on a pc or laptop
- configuration details: coming later
- realtime priority mode: coming later
- adding support for anothe device: coming later

# tips and tricks

a lot more info will come here over time - just some basic points already:

- it is possible to run vcvrack in sonaremin at 32khz smapling rate and to run jackd on the sonaremin at 44.1khz - in this case resampling is done inside of vcvrack which will cost about 10% of extra cpu usage, but might get relevant when using the sonaremin with the jackd network functionality and other gear, which does not support 32khz - this mode is the default now in v1.0.0
- how to use jackd network functionality to communicate with other devices over network: coming later
- how to use multiple sonaremins in parallel: coming later
- it should be possible to run the arm 32bit and 64bit versions of reaper on the sonaremin (with vcvrack startup disabled) to get a little daw :)

# possible future plans and ideas

- support for the raspberry pi 4b (waiting for the linux mainline 64bit for it to mature first)
- support for more devices and tv boxes (proof of concept test done for rockchip rk3328, rk3399, allwinner h6)

# thanks, issues, more documentation

a lot of thanks go to all who made this possible, like the respective authors of the included or used open source projects like andrew belt for vcvrack, rui nuno capela (rncbc) for qjackctl, dave kelly for raveloxmidi, armbian - especially the tv box related part maintained by oleg, the vc4 raspberry pi gpu driver by eric anholt, the linux-meson project for amlogic arm linux mainline support and many many more ...

the generative-01.vcv patch is based on this patch https://www.youtube.com/watch?v=WVeP1a04DOs from omri cohen, but modified to fit the sonaremin, the other patches are built by myself.

please use the issues for this github project to give feedback if it works well or not, for which hardware it works well, if you find solutions for possible problems or if you run into unexpected problems, but please keep in mind that this is a one person project so far and my time to work on it is limited.

this documentation is the first draft to get the initial version of the sonaremin out - it is by far not complete yet and does not cover all topics, but it is at least a start and i tried to cover the most important parts.

now enjoy the sonaremin!

  best wishes - hexdump

![sonaremin image 02](https://github.com/hexdump0815/sonaremin/raw/master/images/sonaremin-02.jpg "sonaremin image 02")
