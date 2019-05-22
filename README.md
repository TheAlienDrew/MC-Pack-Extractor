# MC-Pack-Extractor

Do note that this script only works on the official versions that the [Minecraft Launcher](https://minecraft.gamepedia.com/Java_Edition_launcher) downloads.

COMPATIBILITY: Windows, Mac, & Linux!

* Features still left to implement:
  - Windows version doesn't have a system based zip/unzip backup for when someone can't use 7-Zip
  - Sounds aren't currently bundled with the resource packs, but is planned. > For now just use [this](https://minecraft.gamepedia.com/Tutorials/Sound_directory)
  - Currently only supports Minecraft: Java Edition, but support is planned for Minecraft: Bedrock Edition (Windows 10 and Android Only so far it seems)
  * Probably going to achive this when this support is added to my [MC Pack Workbench](https://thealiendrew.github.io/mcpw)

Links:
  - [Minecraft Forum (old)](https://www.minecraftforum.net/forums/mapping-and-modding-java-edition/resource-packs/resource-pack-discussion/2962634-script-minecraft-default-pack-extractor)

<details><summary>Screenshots Windows</summary>
<p>
  
![Script on startup](https://i.postimg.cc/XJTpHpR7/1win.png)
![Script after entering version](https://i.postimg.cc/mkCh0T43/2win.png)

</p>
</details>

<details><summary>Screenshots Linux (via WSL)</summary>
<p>
  
![Script on startup](https://i.postimg.cc/pT9mJD16/1lin.png)
![Script after entering version](https://i.postimg.cc/59CHHSzH/2lin.png)

</p>
</details>

<details><summary>Screenshots Example Extraction</summary>
<p>
  
![Where it archived to](https://i.postimg.cc/ZKzW6vPw/3win.png)
![What's inside it](https://i.postimg.cc/tCdYkR2p/4win.png)

</p>
</details>

Self Note:
Bedrock Default Resource Pack (Directories on certain systems)... (paths are not solid)
- Windows 10: `ls C:\Program Files\WindowsApps\ | find "Minecraft"` as admin in Powershell to find app path, then go to `data\resource_packs`
- Android: `pm path com.mojang.minecraftpe` in terminal to find app path, use the `base.apk` with 7z to extract resource files from `assets/resource_packs/`
