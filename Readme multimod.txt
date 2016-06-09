What is ParrotMod_Multi?
========================

This is a multi-device overlay for ParrotMod to produce flashable ZIPs for devices other than the Nexus 7.


How do I add support for my device?
========================

1. Study these scripts to understand what's done where., They are fairly well self-documented.
2. create new directory in the "devices" tree
3. copy an existing device and modify parameters described below
4. there are at least 3 parameters which need to change: device product description, RAM, and CPU cores.
5. run mkmultimod.sh to create all the ZIPs including yours.
5. flash
6. profit!
