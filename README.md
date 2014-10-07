pa-repack
=========

Script for repacking AOSPA (http://paranoidandroid.co/) OTA-updates (*.zip).
Features(state):
- [x] changing boot animation,
- [x] installing apps to system partition (for example some WebDAV sync tools),
- [ ] removing unnecessary files.

Usage
-----
  ```
  script.sh [firmware.zip]
  ```
Script can find latest OTA in script directory if no args was provided.
All apks from script folder will be added to OTA update (/system/app folder).
Files mentioned in deprecated.list will be deleted.
Bootanimation zip must have name 'bootanimation.zip' and also placed to script dir.
