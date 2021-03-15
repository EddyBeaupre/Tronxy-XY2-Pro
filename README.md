# Warning
Use this walkthru at your own risk. No waranty whatsoever that this will work for you.

# Pre-requisitions
- This is only for the Tronxy XY-2 Pro, non-titan.
- A full pot of coffee (or 10 full pots).
- A good caliper.
- Visual studio code with PlatformIO.
- A Laptop or Desktop near your printer.
- At least one 1Kg roll of PLA or wathever material you prefer that you don't mind throwing in the garbage.
- 24V/50W Heater rod, chances are they installed a cheap 12V/50W Heater rod in your machine and it's going to burn itself after a few prints.
- Check every mechanical fastener, make sure all the screw are thight, no slack with the rollers, etc...
- Check every electrical's connections, Everything with a screw or connector should be secure properly, no loose connection. The AC female plug on mine gave up after about 6 month probably because i didn't check when i got my printer.

# First Steps
Try the stock firmware, if it work for you and you can manage to set it up properly and have constant results, stick with that, don't bother with this walkthru. I got tired of always having to adjust/tweak the printer after about 6 month of ownership. Sometime it was producing the best print i've ever seen, other time it wasn't even able to lay a first layer consistently.

Also, if you're running the stock firmware, forget about Octoprint, auto-leveling is not compatible with usb print, so unless your bed isn't perfectly leveled (good luck with that), it will never work.

# All right, time for backup
Well, almost, first, we will back up your current firmware, just in case you regret your next moves.

We have two things we need to backup in case we ever want to go back to the stock firmware. The current printer settings and the actual firmware. Let's start by backing up the settings.

## Settings Backup
1. Download this [gcode script](https://raw.githubusercontent.com/EddyBeaupre/Tronxy-XY2-Pro/main/gcode/savesettings.gcode) and save it to an SD card
2. Print this script and wait at least 30 seconds.
3. Turn off your printer. You should now have a file call **currentconfig.gcode** on your SD with all your printer's settings.

## Firmware backup
1. Confirm your board version is CXY-V6-191017. You will need to open the bottom pannel under the printer and take a look at your motherboard. It should look like this and the version written on the board must match.

![CXY-V6-191017 Board](https://raw.githubusercontent.com/EddyBeaupre/Tronxy-XY2-Pro/main/images/tronxy%20CXY-V6-191017.png)

2. Remove the **BOOT** jumper and move the **5V** jumper to the **USB** position.
3. Connect your printer to your computer with an USB cable, a new comm port should appear in the peripheral manager.
4. Download the  [STM32 Flash loader demonstrator](https://www.st.com/en/development-tools/flasher-stm32.html), you will need to create an account, but they are nice and if you ask nicely they will even send your engineering sample of some of their chips. Once it's done, unzip it, install the flash loader demo.
5. Start the Demonstrator GUI.
6. In the first screen, select the comm port of the Tronxy printer, leave all other fields at their default value (115200 baud, 8 bit, even parity, echo disabled, timeout 10) and press **Next**.
7. You should now see a status page saying the target is readeable, if not, check your jumpers and comm ports and start over. Press **Next**.
8. You should now see another status page with the microcontroller version and memory map status, press **Next** again.
9. Select the **Upload from device** tickbox, then press the  **...** button next to the **Upload to file**.
10. A dialog box will open where you can select where to save your firmware, give it a name and make sure the file type is **Bin file (\*.bin)** then click **Open**
11. You will probably see a warning saying that the file doesn't exist ans asking if you want to create the faie (which is normal), answer **Yes** (You may see this warning twice, it's normal, just answer **Yes** again).
12. The memory map selection screen will appear, just make sure that **Select all** is checked at the bottom left then click **Ok**.
13. Once back to the main screen, click **Next** and wait for the firmware upload to complete, which will be confirmed by the progress bar turning green and the message **Upload operation completed successfully**.
14. Click **Close** and exit the Demonstrator GUI.
15. **Unplug the USB cable**.
16. Reinstall the **BOOT** jumper and switch back the other jumper from the **USB** to **5V** position.
17. You can now screw the bottom cover back. We should not have to go inside again unless we screw things up. Make sure you don't squeeze the flat cables, there's a cutoff that allow the LCD cable to go thru the case without issue, but for the print head/XY axis, there is not. I've installed two washer between the pannel and the printer to allow some spacing for the cable. It is not mandatory but if you thighten the pannel too tightly, you may damage the flat cable.

If you want a more visual description of all the steps, check [Jeff's 3D corner video](https://www.youtube.com/watch?v=vL-JXBVUNRg) where he goes thru the whole process.

# Compile Marlin
At this point, the first thing to do is to pour yourself a nice warm cup of coffee and take a break while you consider if you still want to go thru the process or stick with the stock firmware. If you're not sure, take another coffee and make up your mind.

1. [Install Visual Studio Code](https://code.visualstudio.com/download).
2. [Install PlatformIO](https://platformio.org/install/ide?install=vscode) while taking another coffee, it take a while.
3. [Clone the rhapsodyv/Marlin](https://github.com/rhapsodyv/Marlin) repository.
4. Start Visual Studio Code and open **PlatformIO Home** (the little alien head in the left side taskbar).
5. Click on **Open Project** and select the directory where you cloned **rhapsodyv/Marlin**.
6. Let **PlatformIO** rebuild the IntelliSence Indexes while you're finishing your pot of coffee and start another one. It take a while and **PlatformIO** will be completly unresponsive and behave weirdly until this is done.
7. Open the file **platformio.ini** and change **default_envs** from **chitu_v5_gpio_init** to **chitu_f103**.
8. in the **Marlin** subdirectory open **Configuration.h**.
9. Scroll down and at or around line **44** uncomment **#define XY2_V6_255_NO_TITAN_TMC 1**.
10. Scroll down and at or around line **60** uncomment **#define TFT_LVGL_UI**.
11. In the **PlatformIO** side menu expand **Project Tasks** then **Default** then click **Build All**.
12. If everything goes well, after a few minutes you should see the following in the terminal window:

```
Checking size .pio\build\chitu_f103\firmware.elf
Building .pio\build\chitu_f103\firmware.bin
Advanced Memory Usage is available via "PlatformIO Home > Project Inspect"
RAM:   [========= ]  87.2% (used 52760 bytes from 60536 bytes)
encrypt([".pio\build\chitu_f103\firmware.bin"], [".pio\build\chitu_f103\firmware.elf"])
Flash: [=======   ]  70.2% (used 337220 bytes from 480288 bytes)
Block Count is  166
================================================= [SUCCESS] Took 131.05 seconds =================================================
Environment    Status    Duration
-------------  --------  ------------
chitu_f103     SUCCESS   00:02:11.055
================================================== 1 succeeded in 00:02:11.055 ==================================================
```

13. Open the **.pio\build\chitu_f103\\** folder.
14. Copy **update.cbd** and the **assets** folder to the root of an SD card.
15. Take a deep breath. Maybe another coffee.
16. Turn off your printer, insert the SD card, then turn it back on. You should hear a series of beeps and a message on screen with the status of the update. Don't touch anything and let it do it's magic.
17. Congratulation, you're now running Marlin and you can now adjust your Z-Offset (or your printer is bricked and you need to restore the original stock firmware and start over from scratch).

If you want a more visual description of all the steps, [Jeff's 3D corner](https://www.youtube.com/channel/UCfkuUbJ9yJltc0Qi4IDymNA) made [another video](https://www.youtube.com/watch?v=agOv6DsOz04) where he goes thru the whole process, the procedure is a little different because the video was made a while ago with an older version of PIO but overall the process is the same.

# Restore stock firmware
**TODO**

# Adjust Z-Offset.
**TODO**

# Adjust E-Steps.
**TODO**
