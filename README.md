# Pre-requisitions
- A full pot of coffee (or 10 full pots).
- A good caliper.
- Visual studio code with PlatformIO.
- At least one 1Kg roll of PLA or wathever material you prefer that you don't mind throwing in the garbage.
- 24V/50W Heater rod, chances are they installed a cheap 12V/50W Heater rod in your machine and it's going to burn itself after a few prints.

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

2. Remove the **BOOT** jumper and move the **5V** jumper to the **USB*** position.
3. Connect your printer to your computer with an USB cable, a new comm port should appear in the peripheral manager.
4. Download the  [STM32 Flash loader demonstrator](https://www.st.com/en/development-tools/flasher-stm32.html), you will need to create an account, but they are nice and if you ask nicely they will even send your engineering sample of some of their chips. Once it's done, unzip it, install the flash loader demo.
5. Start the Demonstrator GUI.
6. In the first screen, select the comm port of the Tronxy printer, leave all other fields at their default value (115200 baud, 8 bit, even parity, echo disabled, timeout 10) and press **Next**
7. You should now see a status page saying the target is readeable, if not, check your jumpers and comm ports and start over. Press **Next**.
8. You should now see another status page with the microcontroller version and memory map status, press **Next** again.
9. Select the **Upload from device** tickbox, then press the  **...** button next to the **Upload to file**
10. A dialog box will open where you can select where to save your firmware, give it a name and make sure the file type is **Bin file (\*.bin)** then click **Open**
11. You will probably see a warning saying that the file doesn't exist ans asking if you want to create the faie (which is normal), answer **Yes** (You may see this warning twice, it's normal, just answer **Yes** again).
12. The memory map selection screen will appear, just make sure that **Select all** is checked at the bottom left then click **Ok**.
13. Once back to the main screen, click **Next** and wait for the firmware upload to complete, which will be confirmed by the progress bar turning green and the message **Upload operation completed successfully**.
14. Click **Close** and exit the Demonstrator GUI.
15. **Unplug the USB cable**.
16. Reinstall the **BOOT** jumper and switch back the other jumper from the **USB** to **5V** position.
17. You can now screw the bottom cover back. We should not have to go inside again unless we screw things up.

# Compile Marlin


