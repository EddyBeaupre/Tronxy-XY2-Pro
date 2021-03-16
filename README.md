- [Warning](#Warning)
- [Pre-requisitions](#pre-requisitions)
- [First Steps](#first-Steps)
- [All right, time for backup](#all-right-time-for-backup)
  - [Settings Backup](#settings-backup)
  - [Firmware backup](#firmware-backup)
- [Marlin](#marlin)
  - [Compile Marlin](#compile-marlin)
  - [Install Marlin](#install-marlin)
  - [Configure Marlin](#configure-marlin)
    - [Adjust Z-Offset](#adjust-z-offset)
    - [Adjust E-Steps](#adjust-e-steps)
    - [Adjust Filament loading/unloading](#adjust-filament-loading-unloading)
- [Restore stock Tronxy firmware and settings](#restore-stock-tronxy-firmware-and-settings)

# Warning
Use this walkthru at your own risk. No waranty whatsoever that this will work for you. This is a work in progress, things may and will change in the futur.

# Pre-requisitions
- This is only for the Tronxy XY-2 Pro, non-titan.
- A full pot of coffee (or 10 full pots).
- A good caliper.
- Visual studio code with PlatformIO.
- A Laptop or Desktop near your printer.
- At least one 1Kg roll of PLA or wathever material you prefer that you don't mind throwing in the garbage.
- 24V/50W Heater rod, chances are they installed a cheap 12V/50W Heater rod in your machine and it's going to burn itself after a few prints.
- A runout detection sensor that has a brass or other strong material insert at the input side, your filament is going to cut right thru the stock all plastic Tronxy sensor after a while.
- Check every mechanical fastener, make sure all the screw are thight, no slack with the rollers, etc...
- Check every electrical's connections, Everything with a screw or connector should be secure properly, no loose connection. The AC female plug on mine gave up after about 6 month probably because i didn't check when i got my printer.

# First Steps
Try the stock firmware, if it work for you and you can manage to set it up properly and have constant results, stick with that, don't bother with this walkthru. I got tired of always having to adjust/tweak the printer after about 6 month of ownership. Sometime it was producing the best print i've ever seen, other time it wasn't even able to lay a first layer consistently.

Also, if you're running the stock firmware, forget about Octoprint, auto-leveling is not compatible with usb print, so unless your bed isn't perfectly leveled (good luck with that), it will never work.

# All right, time for backup
Well, almost, first, we will back up your current firmware, just in case you regret your next moves.

We have two things we need to backup in case we ever want to go back to the stock firmware. The current printer settings and the actual firmware. Let's start by backing up the settings.

## Settings Backup
1. Download this [g-code script](https://raw.githubusercontent.com/EddyBeaupre/Tronxy-XY2-Pro/main/gcode/savesettings.gcode) and save it to an SD card
2. Print this script and wait at least 30 seconds.
3. Turn off your printer. You should now have a file call **currentconfig.gcode** on your SD with all your printer's settings.

## Firmware Backup
1. Confirm your board version is CXY-V6-191017. You will need to open the bottom pannel under the printer and take a look at your motherboard. It should look like this and the version written on the board must match.

![CXY-V6-191017 Board](https://raw.githubusercontent.com/EddyBeaupre/Tronxy-XY2-Pro/main/images/tronxy%20CXY-V6-191017.png)

2. Unplug your printer.
3. Remove the **BOOT** jumper and move the **5V** jumper to the **USB** position.
4. Connect your printer to your computer with an USB cable, a new comm port should appear in the peripheral manager.
5. Download the  [STM32 Flash loader demonstrator](https://www.st.com/en/development-tools/flasher-stm32.html), you will need to create an account, but they are nice and if you ask nicely they will even send your engineering sample of some of their chips. Once it's done, unzip it, install the flash loader demo.
6. Start the Demonstrator GUI.
7. In the first screen, select the comm port of the Tronxy printer, leave all other fields at their default value (115200 baud, 8 bit, even parity, echo disabled, timeout 10) and press **Next**.
8. You should now see a status page saying the target is readeable, if not, check your jumpers and comm ports and start over. Press **Next**.
9. You should now see another status page with the microcontroller version and memory map status, press **Next** again.
10. Select the **Upload from device** tickbox, then press the  **...** button next to the **Upload to file** textbox.
11. A dialog box will open where you can select where to save your firmware, give it a name and make sure the file type is **Bin file (\*.bin)** then click **Open**
12. You will probably see a warning saying that the file doesn't exist ans asking if you want to create the faie (which is normal), answer **Yes** (You may see this warning twice, it's normal, just answer **Yes** again).
13. The memory map selection screen will appear, just make sure that **Select all** is checked at the bottom left then click **Ok**.
14. Once back to the main screen, click **Next** and wait for the firmware upload to complete, which will be confirmed by the progress bar turning green and the message **Upload operation completed successfully**.
15. Click **Close** and exit the Demonstrator GUI.
16. **Unplug the USB cable**.
17. Reinstall the **BOOT** jumper and switch back the other jumper from the **USB** to **5V** position.
18. You can now screw the bottom cover back. We should not have to go inside again unless we screw things up. Make sure you don't squeeze the flat cables, there's a cutoff that allow the LCD cable to go thru the case without issue, but for the print head/XY axis, there is not. I've installed two washer between the pannel and the printer to allow some spacing for the cable. It is not mandatory but if you thighten the pannel too tightly, you may damage the flat cable.

If you want a more visual description of all the steps, check [Jeff's 3D corner video](https://www.youtube.com/watch?v=vL-JXBVUNRg) where he goes thru the whole process.

Now that you have everything backed up, make 3 copies of them, send one to your grandmother, one to your mother and keep one. That way, you will always be able to recover them if you need. 

# Marlin

## Compile Marlin
At this point, the first thing to do is to pour yourself a nice warm cup of coffee and take a break while you consider if you still want to go thru the process or stick with the stock firmware. If you're not sure, take another coffee and make up your mind.

1. [Install Visual Studio Code](https://code.visualstudio.com/download).
2. [Install PlatformIO](https://platformio.org/install/ide?install=vscode) while taking another coffee, it take a while.
3. [Clone the rhapsodyv/Marlin](https://github.com/rhapsodyv/Marlin) repository.
4. Start Visual Studio Code and open **PlatformIO Home** (the little alien head in the left side taskbar).
5. Click on **Open Project** and select the directory where you cloned **rhapsodyv/Marlin**.
6. Let **PlatformIO** rebuild the IntelliSence Indexes while you're finishing your pot of coffee and start another one. It take a while and **PlatformIO** will be completly unresponsive and behave weirdly until this is done.
7. Open the file **platformio.ini** and change **default_envs** from **chitu_v5_gpio_init** to **chitu_f103**.
8. in the **Marlin** subdirectory open **Configuration.h**.
9. At or around line **44** uncomment **#define XY2_V6_255_NO_TITAN_TMC 1**.
10. At or around line **62** uncomment **#define TFT_COLOR_UI**.
11. At or around line **966** increase **#define EXTRUDE_MAXLENGTH** from **200** to **500**, with the bowden tube you will need more than 200mm of fillament to insert or remove the filament. In my case i need **325mm**.
12. At or around line **1690** uncomment **#define SOFT_ENDSTOPS_MENU_ITEM**.
13. **\*\*Optional\*\*** At or around line **1178** you can adjust your steps by changing the value of **#define DEFAULT_AXIS_STEPS_PER_UNIT**, or leave it default and adjust later via the printer's UI.
14. **\*\*Optional\*\*** At or around line **1874** you can adjust the number of point automatic bed leveling will check with **#define GRID_MAX_POINTS_X**, or leave it default.
15. In the **PlatformIO** side menu expand **Project Tasks** then **Default** then click **Build All**.
16. If everything goes well, after a few minutes you should see the following in the terminal window:

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

## Install Marlin
1. Open the **.pio\build\chitu_f103\\** folder.
2. Copy **update.cbd** to the root of an SD card.
3. Take a deep breath. Maybe another coffee.
4. Turn off your printer, insert the SD card, then turn it back on. You should hear a series of beeps and a message on screen with the status of the update. Don't touch anything and let it do it's magic.
5. Congratulation, you're now running Marlin and you can now adjust your Z-Offset (or your printer is bricked and you need to restore the original stock firmware and start over from scratch).

If you want a more visual description of all the steps, [Jeff's 3D corner](https://www.youtube.com/channel/UCfkuUbJ9yJltc0Qi4IDymNA) made [another video](https://www.youtube.com/watch?v=agOv6DsOz04) where he goes thru the whole process, the procedure is a little different because the video was made a while ago with an older version of PIO but overall the process is the same.

## Configure Marlin
### Adjust Z-Offset
1. Preheat your bed and extruder to the temperature you normally use for your material and go take a coffee or wait at least 10 minutes for everything to settle down.
2. Home your printer, touch the **Configuration** icon, **Motion** and finally **Auto Home**.
3. Auto Level your printer, touch the **Configuration** icon, **Motion**, **Bed Leveling** and finally **Level Bed**.
4. Move the print head to the center of the bed (X=**125**, Y=**125**), touch the **Configuration** icon, **Motion**, **Move Axis**, **Move X**/**Move Y** ...
5. Touch the **Back Arrow** until you go back to the **Motion** menu, then touch **Soft Endstops** and turn them off. **\*\*WARNING\*\*** Until you re-enable the Soft Endstops, you can crash your head on the bed or push an axis too far, so be careful.
6. Touch **Move X**, and adjust the Z-Axis very slowly until it barely grip on a piece of paper, take note of the position, that is your Z-Axis offset.
7. Touch the **Back Arrow** until you go back to the **Main Menu**, then touch **Configuration**, **Probe Z Offset** and enter the Z-Axis offset.
8. Touch the **Back Arrow** until you return to the **Main Configuration** menu then touch the **Right Arrow** to go to page two and touch **Store Settings**.

### Adjust E-Steps
1. Download this [g-code script](https://raw.githubusercontent.com/EddyBeaupre/Tronxy-XY2-Pro/main/gcode/Extrude100mm.gcode).
2. Default values are ok for about any types of PLA (**60'c** for the bed, **205'c** for the extruder), if you're using another kind of material, edit the G-Code and change theses values. Keep the Extruder a little bit hotter than you would normally extrude because we will extrude alot of filament in a short time.

```g-code
M140 S60; set bed temperature
M104 S205 T0; set nozzle temperature
```

3. With a caliper or a good ruler, mesure and mark 120mm of filament from the filament runout sensor.
4. Print the g-code script. It will print 100mm of filament.
5. Mesure what is left between the runout sensor and the mark you made earlier. Let's say 27mm for this example, you now know that you under-extruded **7mm** (**27mm - (120mm - 100mm) = 7mm**) or **93%** (**100mm - 7mm = 93mm**) of what you wanted to extrude.
6. Touch the **Configuration** icon, **Configuration**, **Advance Configuration**, **Right Arrow** to go to page two and touch **Steps/mm** and take note of your **E Steps/mm** (**186** in the stock configuration).
7. Divide your **E Steps/mm** by the percentage you calculated earlier, this will give your new **E Steps/mm**. In this example **186mm/0.93 = 200mm**.
8. Return to the **Steps/mm** menu, and enter your new **E Steps/mm** value.
9. Touch the **Back Arrow** until you return to the **Main Configuration** menu then touch the **Right Arrow** to go to page two and touch **Store Settings**.

Once again, [Jeff's 3D corner](https://www.youtube.com/channel/UCfkuUbJ9yJltc0Qi4IDymNA) made [another video](https://www.youtube.com/watch?v=4UCAwPmiBb4) where he goes thru the whole process and need more explanations.

### Adjust Filament loading/unloading.
1. Touch the **Configuration** icon, **Configuration**, **Advance Configuration**, **Right Arrow** to go to page two and touch **Filament**.
2. Set **Unload mm** to **400** and **Load mm** to **350**.
3. Touch the **Back Arrow** until you return to the **Main Configuration** menu then touch the **Right Arrow** to go to page two and touch **Store Settings**.
4. Touch the **Back Arrow** until you return to the **Main Configuration** menu then touch **Change Filament**, and follow the on-screen instructions.
5. Repeat theses steps, chaning the **Unload mm** / **Load mm** values until you are happy with them.

# Restore stock Tronxy firmware and settings.
1. Unplug your printer from the AC outlet.
2. Remove the bottom pannel under the printer.
3. Remove the **BOOT** jumper and move the **5V** jumper to the **USB** position.
4. Connect your printer to your computer with an USB cable, a new comm port should appear in the peripheral manager.
5. Start the Demonstrator GUI.
6. In the first screen, select the comm port of the Tronxy printer, leave all other fields at their default value (115200 baud, 8 bit, even parity, echo disabled, timeout 10) and press **Next**.
7. You should now see a status page saying the target is readeable, if not, check your jumpers and comm ports and start over. Press **Next**.
8. You should now see another status page with the microcontroller version and memory map status, press **Next** again.
9. Select the **Download to device** tickbox, then click on the **...** button next to the **Download from file** textbox.
10. Make sure the file type is **Bin file (\*.bin)** then browse for the firm
11. ware backup file you made earlier and clock **Open**.
12. Leave all other options to their default values (**Erase necessary pages** ticked and **@ (h)** at 8000000) then click **Next**.
13. Wait for the software download to complete, the progress bar will turn green with the message **Download operation finished successfully**.
14. **Unplug the USB cable**.
15. Reinstall the **BOOT** jumper and switch back the other jumper from the **USB** to **5V** position.
16. You can now screw the bottom cover back.
17. Plug your printer to an AC outlet and turn it on, it should boot back to the Tronxy firmware.
18. Put the backed up setting file **currentconfig.gcode** on an SD card (If you use the same SD, don't forget to remove the **update.cbd** file, else you may flash it back to Marlin).
19. Insert the SD card in the printer and print **currentconfig.gcode**, wait until the printer confirm that the printing is done.
20. Turn the printer off for at least 15 seconds.
21. Turn the printer back on.
