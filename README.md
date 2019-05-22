## the sonaremin

![sonaremin image 01](https://github.com/hexdump0815/sonaremin/raw/master/images/sonaremin-01.jpg "sonaremin image 01")

welcome to the wonderful world of the sonaremin. the name sonaremin is combined from the latin word for sound: sonare and the end of theremin, the name of an unconventional instrument for its time in the 1920s. what is the sonaremin? it is following the philosophy of modular synthesizers by plugging together several excellent open source software projects to create something new. those projects are in its first incarnation (sonaremin one): vcvrack, linux, ubuntu, jack, xpra, overlayroot, fluxbox and many more. the goal is to create a a very flexible and easy to use device which can be used to create electronic music without the need of a computer. as soon as it gets plugged into the power socket it will start and it will be ready in about a minute. one just needs to connect a midi controller to it for playing it and at the end it can simply be unplugged from power to turn it off.

for creating sounds it uses the wonderful vcvrack modular synthesizer by running special sound-patches created for it, which can then be played and/or manipulated by a connected midi controller. the sonaremin has two modes of operation: display mode and headless mode.

besides that it might also be used as a good prototyping platform for audio experiments running on linux and small arm based computers. it runs on multiple devices, is based on a recent mainline linux kernel (4.19 and 5.0 right now), a long term supported standard ubuntu distribution (18.04 lts), it has some audio optimizations applied and has gpu accelerated opengl support (as good as possible for the different devices).

# display mode

in display mode the sonaremin will operate like a regular vcvrack installation: you connect the sonaremin to a hdmi monitor, connect a keyboard, a mouse, maybe a midi controller and an amplifier to it and can create or modify vcvrack patches with it.

# headless mode

in headless mode the sonaremin does not need a mouse, a keyboard and a monitor. it will work either completely on its own endlessly playing a generative patch or can be used as an instrument with a midi controller attached. both is possible by simply copying a properly prepared patch to a certain location which it will then automatically use on startup. even in headless mode it is possible to connect to the sonaremin via ethernet and share the screen with its running vcvrack via the xpra software (https://xpra.org/ - a good commandline on linux for instance is 'xpra --opengl=no --encoding=rgb --title="sonaremin" attach ssh/sonaremin@sonaremin/100'), which offers desktop viewing applications for linux, macos and windows. this mode is only useable for checking the operation or changing some settings (like jack connection or midi learn setup), as in this mode there is no gpu acceleration available for the screen rendering which results in all cpu power being eaten up by the graphics and close to none being left for audio, but for simple tasks this is still sufficent.

# supported hardware

the sonaremin currently runs (more or less) on the following arm cpu based devices:

- odroid c2 (pcm2704)
- asus tinkerboard (cooling, pcm2704) and tinkerboard s (untested, cooling, pcm2704)
- raspberry pi in 32bit [2b (untested, limited, 22khz), 3b & 3b+] (cooling) and 64bit mode [3b & 3b+] (cooling)
- amlogic s905w/s905x/s905 based android tv boxes (pcm2704) - tested on x96 mini (s905w), t95m (s905x), tx3 mini l (s905w) and mxq pro 4k (the s905 version - beware: there are other versions of this box with the same name with other cpus as well) - it should run on nearly any s905w, s905x, s905 based tv box i guess
- allwinner h3 based android tv boxes (22khz) - tested on tx1
- bananapi m1 (limited, pcm2704)

the comments in the brackets mean:

- pcm2704: a pcm2704 usb audio adapter is required - you can find it easily for around 3 euro on ebay
- cooling: a fan is required to cool the device, otherwise it will reduce its power automatically due to the create heat resulting in degraded audio performance (the tinkerboard will by default be run at a reduced clock speed to avoid the need of a fan, but with a fan it can be run at full speed with more cpu power)
- 22khz: running with a sampling frequency of 22,05khz instead of the regular 32khz of the sonaremin as the cpu power of the device it too low for higher sampling frequencies - please be aware that some modules (for example the texture and the modal synthesizer from audible instruments) use a 32khz sampling frequency internally and actually need more cpu power at 22khz, in this case running on 32khz is preferred even on slow hardware
- untested: i have no access to such a device, so i could not test them, but in theory they should work
- limited: those devices have too little cpu power for even medium sized patches like the supplied example patches, but they might still be used for very small and simple patches and to get an idea how the sonaremin works - using them for a longer time will most probably not be a very pleasant experience

the basic functionally is the same for all devices, but their cpu performance and thus possible maximum size of the possible patches differs a bit - here is an overview of the cpu usage of the different devices with the generative-01.vcv sample patch (vcvrack is configured for two audio threads, so it can at maximum utilize about 200% cpu for audio - more threads do not make sense, as vcvrack does not scale well with more threads - cpu usage should be measured in iconified mode, as this way the ui does not eat any extra cpu):

- odroid c2: 60-62%
- amlogic s905w/s905x tv box: 80% (s905w) / 70% (s905x)
- amlogic s905 tv box: 62-65%
- tinkerboard: 85-95% (limited to 1.2ghz - similar to odroid c2 with cooling and higher cpu clock)
- raspberry pi 3b in 64bit mode: 80%
- raspberry pi 3b in 32bit mode: 105-120% (the slowdown compared to the 64bit version comes alone from not using the 64bit armv8 cpu instructions)
- h3 tv box: 100-110% (22khz)
- t9 tv box (rockchip rk3328 @1296mhz - surprisingly slower than an amlogic s905w @1200mz): 80-90% (just some basic test - not yet supported)
- rock pi 4b (rockchip rk3399 2x a72 cores @1800mhz via taskset): 42% (just some basic test - not yet supported)
- intel atom baytrail z3740d system: 105-110% (just some basic test - not supported, just for comparison)

as a result recommended is the odroid c2 as it has a good performance and does not need cooling. also recommended are amlogic s905w/s905x based tv boxes as they have a good performance, do not need cooling and are cheap (around 30 euro for a box with 1gb ram, a bit more for a box with 2gb ram which is even better, but 1gb works well too) and come with a case and power supply already. the other devices are only recommended if they are around already: the tinkerboard is quite good, but expensive - the raspberry pi's are ok, but vcvrack pushes its gpu and graphics system to its limits, in headless mode they should work very good as well - the h3 tv box is at the low performance end and the bananapi even below that :)

please keep in mind, that with the exception of the raspberry pi's and the h3 tv box all other devices will need an extra pcm2704 usb audio adapter (just google for pcm2704, they cost around 3 euro, have low jitter and good latency - see the pictures in the images folder for which device to get exactly: https://github.com/hexdump0815/sonaremin/raw/master/images/pcm2704-01.jpg and https://github.com/hexdump0815/sonaremin/raw/master/images/pcm2704-02.jpg) as the internal audio is not working well enough for low latency audio or does not support a 32khz sampling frequency. the raspberry pi's work with the built in audio, but it has slightly worse latency and and quality compared to the pcm2704.

the qjackctl in the sonaremin images includes prepatched connections for an akai apc key 25 and for an worlde mini midi controller and the vcvrack patches have their midi-cc connections learned for the akai apc key 25. if any other controller should be used it is required to adjust and sage the qjackctl patch configuration and relearn the midi-cc connections in the sample patches to properly use them with other controllers.

# installation

for installing the sonaremin on one of the supported devices the provided images need to be downloaded (see the releases section on github), decompressed (gunzip to get rid of the .gz) and then flashed to an sd card of at least 8gb size (more is not a problem). please refer to the many ressources on the internet on how to decompress the .gz files and how to flash the images properly to an sd card depending on what operating system you are using for this task.

in the case of the amlogic s905w/s905x tv boxes there is an extra step required to enable multi boot mode. first a disclaimer: this worked for me and for lots of others for many amlogic s905w and s905x based tv boxes and is usually a very easy and reliable process, but there is always a small risk that it might brick the tv box - you have been warned. the procedure to enable multi boot mode is described here: https://forum.armbian.com/topic/2419-armbian-for-amlogic-s905-and-s905x-ver-544/ - the basic steps relevant are:

- boot the tv box into android with the sonamerin sd card inside
- open the android app "update & backup"
- click on "select" local update and chose the file on the removable media (aml_update.zip) aml_autoscript.zip
- start "update"
- system will reboot twice and then start running the system from the sd card, i.e. sonaremin (without the sd card inside it should still start the regular android of the tv box)

for some devices an adjustment for the dtb file is required - see the comments in the file menu/extlinux.conf (if there are any comments) in the BOOT partition of the written sd card.

# configuration

the basic configuration of the sonaremin device is done in the menu/extlinux.conf file on the BOOT partition of the written sd card (see above as well) for setting the overlayroot mode or not and the file config/sonaremin.txt in the DATA partition of the written sd card: here the display mode (display or headless) is the most important. besides that it is possible to turn off the audio tuning on boot, turn off the automatic start of qjackctl and vcvrack and change the maximum cpu clock in the case of a tinkerboard to avoid it overheating. it is also possible to switch to a v1 development version of vcvrack - this is not yet useable properly, but might be interesting to get an idea about the new version.

there are more options to configure the sonaremin, which will be described at a later time here (rc.boot-local, rc.xsession-local, config/systems directory, qjackctl directory)

the default patch used in headless mode is always vcvrack-v0/sonaremin.vcv (vcvrack-v1dev/sonaremin.vcv for the v1dev version) on the DATA partition of the sd card, so the desired patch to be run in headless mode should be copied there. by default the generative-01.vcv patch is copied there, so that the sonaremin should give some sound about a minute after it starts if everything is working well. in display mode vcvrack will use the patch last used in display mode - the initial default is the generative-01.vcv sample patch.

the username to use when logging in remotely via ethernet to the sonaremin is "sonaremin" and the password is "sonaremin" as well - please change the password with the "passwd" linux command for security reasons if you plan to connect the device more often to a network. the hostname you should able able to find the device at in the network is "sonaremin" as well and remote login is possible via ssh and in headless mode an xpra desktop sharing connection is possible too.

in display mode the right mouse button opens a menu to open a terminal window, an editor, start qjackctl or vcvrack (if not already running), select some keyboard layouts, reboot or shutdown the sonaremin. in display mode it should always be shutdown properly via the shutdown or reboot commands. in headless mode it can be simply powered off without any shutdown.

please be aware, that vcvrack will always start in iconified mode in the sonaremin. this is because in in headless mode otherwise the missing gpu acceleration would result in a lot of cpu being wasted to software-render the ui into nirwana - if started iconified no cpu cycles are used for rendering. in display mode vcvrack has to be deiconified from the applications tab at the bottom of the screen before using it.

# overlayroot mode

by default the sonaremin is running in overlayroot mode, i.e. the rootfilesystem is mounted read-only and and top of that a memory filesystem is mounted read-write. this means, that all changes to the systems are lost when the device is powered off and this allows to simply power off the device without a proper shutdown in headless mode. the DATA and BOOT partitions are mounted regularly in read-write mode, so that configuration changes done in files located on them and patches saved onto the DATA partition are not lost after a reboot. this is also the reason while various configuration files of qjackctl, vcvrack etc. are symbolically linked from the system partition to the DATA partition.

if permanent changes should be done to the system (for instance installation of software or more fundamental configuration changes) it can be switched between overlayroot and non overlayroot mode in the menu/extlinux.conf file and by rebooting the sonaremin afterwards. do not forget to switch it back to overloayroot mode afterwards. temporary access to the root filesystem in read-write mode is possible with the "overlayroot-chroot" command. to get root simply use "sudo -i".

# known problems and things to keep in mind

in general the sonaremin already works quite well - this is a list of things i have noticed and which should be kept in mind and maybe should be fixed one day:

- on bootup there is an error visible about an fsck problem - this is most probably due to the update-initramfs task in the image creation for some reason does not put the proper fsck binaries into the initramfs - it seems to be no big deal for now though
- the tinkerboard does only a shutdown when a reboot is requested - most probably some kernel patch is still missing - i do not see this as a big problem for now
- the allwinner s905 tv boxes might not work with all sd cards - maybe try another one in case you get mmc errors on boot, also some of the usb ports might not work
- tv boxes might also behave strange on shutdown or reboot (for instance do only one of the two, do them in reverse or simply hang in that case) - this is due to the widely variying hardware of those devices
- the raspberries are quite at the limit with their gpu driver and opengl implementation and vcvrack - this has two side effects: a lot of memory is required for the gpu (about half of the 1gb) resulting in the sonaremin sometimes hanging for up to a minute when it starts swapping as there is not enough memory left (so just be patient for a moment) - the other effect are rendering errors (for instance the rails are missing on the raspberry pi's) and one should be more careful with the graphics (for instance always first empty the vcvrack patch - top left button - before opening another one)
- some devices definitely need a fan for cooling (see hardware section above) - simple passive cooling with a small heat sink is definitely not enough
- as all this is running on the arm architecture only non commercial plugins, which are available in source form (so that they can be compiled and included into the sonaremin) can be used, so no bought plugins can be used and some popular other ones cannot be used neither as there is no source available for them (vult, nysthi, turing machine, ...) - this is less of a problem than it sounds as for many of them there are open sourced alternatives available (for instance the random sampler from audible instruments can take over some tasks of the turing machine)
- those little arm devices have much less cpu power than a normal pc or laptop, thus it is recommended to use modules which use less cpu power for the same task (for instance a perco filter instead of the fundamental vcf or the 21khz palm loop instead of the fundamental vco) - the power meter option in vcvrack is your friend in finding out which modules eat the most cpu (it is normal that the audio output is usually among the most cpu intensive ones, but this is by design and can't be changed)
- all controllers used via midi cc need to be wiggled a bit, so that they transmit their initial settings to vcvrack after startup (only the akai midi mix seems to have a button to send all the current settings at once) - this is not special for the sonaremin, but the way midi-cc works in vcvrack
- network connections are only supported via etherenet (no wlan) and keyboard and mouse have to be usb (no bluetooth)
- patches need to be expicitely configured (qjackctl patching and vcvrack midi learning etc.) in the patch in a display or xpra session first, before they can be used headless

# technical notes

a lot more info will come here over time - just some basic points already:
- the linux system of the sonaremin is a regular ubuntu 18.04 lts
- the vcvrack is a regular vcvrack (the rcomian fork in the case of the v0.6.2c one - i'm using my arm builds of it as a base - see: https://github.com/hexdump0815/vcvrack-dockerbuild-v0 and https://github.com/hexdump0815/vcvrack-dockerbuild-v1), so the patches should be fully compatible with a regular desktop vcvrack as long as all used plugins are available and the sonaremin has enough cpu power for a patch - as a result patches for the sonaremin can also be created on a pc or laptop - in this case it might be useful to use my linux or macos builds from https://github.com/hexdump0815/vcvrack-dockerbuild-v0/releases as they have the same plugins as the sonaremin
- configuration details: coming later
- realtime priority mode: coming later
- adding support for anothe device: coming later

# tips and tricks

a lot more info will come here over time - just some basic points already:

- it is possible to run vcvrack in sonaremin at 32khz smapling rate and to run jackd on the sonaremin at 44.1khz - in this case resampling is done inside of vcvrack which will cost about 10% of extra cpu usage, but might get relevant when using the sonaremin with the jackd network functionality and other gear, which does not support 32khz
- how to use jackd network functionality to communicate with other devices over network: coming later
- how to use multiple sonaremins in parallel: coming later

# possible future plans and ideas

- support for rockchip rk3328 based tv boxes
- support for more powerful arm devices like amlogic s905x2 tv boxes (sadly no gpu accelerated opengl in x11 yet), the odroid n2 (amlogic s922x - sadly no gpu accelerated opengl in x11 yet), rockpi 4 (rockchip rk3399 - gpu accelerated opengl in x11 should be possible, but linux mainline device support not very mature yet), nvidia jetson nano (very good gpu opengl support with nvidia 4.9 kernel), allwinner h6 tv boxes (linux mainline device support not very mature yet, gpu accelerated opengl unclear)
- work on sonaremin two (zynaddsubfx based) and further ones based on surge, helm, linuxsampler, ... maybe
- maybe introduce a mapping layer between different midi controllers and vcvrack (via ididings maybe?) to abstract them

# thanks, issues, more documentation

a lot of thanks go to all who made this possible, like the respective authors of the included or used open source projects like andrew belt for vcvrack, armbian - especially the tv box related part maintained by oleg, the vc4 raspberry pi gpu driver by eric anholt, the linux-meson project for amlogic arm linux mainline support and many many more ...

the generative-01.vcv patch is based on this patch https://www.youtube.com/watch?v=WVeP1a04DOs from omri cohen, but modified to fit the sonaremin, the other patches are built by myself.

please use the issues for this github project to give feedback if it works well or not, for which hardware it works well, if you find solutions for possible problems or if you run into unexpected problems, but please keep in mind that this is a one person project so far and my time to work on it is limited.

this documentation is the first draft to get the initial version of the sonaremin out - it is by far not complete yet and does not cover all topics, but it is at least a start and i tried to cover the most important parts.

now enjoy the sonaremin!

  best wishes - hexdump

![sonaremin image 02](https://github.com/hexdump0815/sonaremin/raw/master/images/sonaremin-02.jpg "sonaremin image 02")
