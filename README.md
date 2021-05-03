# Mixed-Media-Bundle-Launcher

## What is it?

This Godot 3 project is an easy-to-edit jumping off point for making a launcher to make your game/file/whatever bundles look more professional. As the name implies it can launch pretty much anything you throw at it, all in one consistent looking animated package.

The MM Bundle Launcher configured to run windows games from [Indiepocalypse Zine issue #1](https://pizzapranks.itch.io/indiepocalypse-1).

(insert video here)

The MM Bundle Launcher running the example provided in the repo. See it for yourself by cloning the repo and running `Launcher.exe`in the `Launcher Example` folder.

(insert video here)

## What can it do?

It **can**:

- launch exe files
- open files using default app
- run an emulator with the game already loaded and ready to play
- open folders in file explorer
- be used with a controller

At the moment it **can't**:

- have multiple files per one cover on the carousel
- have submenus
- show files in a non carousel view 
- emulate other consoles without prior modifications

Things listed above can be added or changed if you are ready to tweak the source code a bit.

## FAQ

Q: Some/all projects I want to run were made in an engine other than Godot, will it still run?

A: Yes, absolutely.

Q: Do I have to know how to code to use this with my project?

A: Absolutely not, you can change it to fit your project by just drag&dropping files.

-------

# Documentation and Instructions

[TOC]

Last edited on May 1st 2021.

## Set up the environment

Skip this section if you have experience working with Godot and have the latest version + export templates already installed. If not - follow the steps below.

1. Download the [latest stable release of Godot Engine](https://godotengine.org/download)(33.8MB). Get the standard version, NOT Mono.
2. Download the source files for this project(1.5MB) and if you feel like it - the example(80.3MB).
4. Run Godot, on the right hand side click `Scan` and select the `Launcher Source` folder from the project source files that you downloaded. If everything went right you should see a new project appear.
5. Open the `Launcher` project. It should load into `Launcher.tscn` by default. This is how it should look if everything went right (except your interface will be dark gray/blue).![](https://cdn.discordapp.com/attachments/814658514328354867/837881527731879956/unknown.png) 
6. Look at the top-left side of the screen. Under `Editor > Manage Export Templates`and download the export templates for the current version (this might take a while)

Extra info if you are new to Godot:

* Click on a node in the `Scene` hierarchy window on the left side, then look at the `Inspector` window on the right side to see and change its parameters.
* To preview how the project will look click on the play button in the top-right (above `Inspector`).
* You can drag and drop files from the `FileSystem` window on the bottom-right into the scene as well as into relevant fields in the `Inspector` window.

If everything went right you should be all set up now!

### Exporting the launcher

To test if it is able to launch the files that you specified and prepare the launcher for release and distribution you will need to export it. To do it, in the top right go to `Project > Export...`. Select the preset that is already there and click `Export Project`. It should be done in a second or two.

## Adding your games to the launcher

### Structure

In `Launcher.tscn` the `Carousel` node of is a parent to many instances of `Game.tscn`.

 ![](https://cdn.discordapp.com/attachments/814658514328354867/838062783085674566/unknown.png)

Each Instance represents one game cover on the carousel. The `Script Variables` of each of these nodes(found in the `Inspector` on the right) contain the information you will need to tweak to replace the examples with your own stuff.

The names of the nodes do not do anything and can be whatever. 

The order in which they are shown in the scene hierarchy is important and determine where they will be on the carousel.![](https://cdn.discordapp.com/attachments/814658514328354867/838064423238631424/unknown.png)

### Variables

For each cover you want to be presented in the launcher you will need to fill out the information displayed to the user.

- [ ] Write the name of the game in `Game Name`
- [ ] Write the name of the author in `Author Name`, the launcher will then display "by [author name you wrote]"
- [ ]  Add the images you want to use as covers to the project folder.
- [ ] Drag and drop the image file you want to be the cover from `File System` window into the `Cover` field.
- [ ] If the image is not upright and you want to change that select the appropriate option from the `Rotate` dropdown menu.
- [ ] Select the appropriate `Game Type` from the dropdown, this will determine how the next variable is treated. More about what each game type means can be found below.
- [ ] Input the path to the file you want to execute/open in the `File To Run` field. More info on how this data should be formatted can be found below.

Keep in mind that changing these variables will not cause any immediate change in what you see in the editor. You need to run the project to see how it will look.



Breakdown of what each variable will change and how it will look for the user.

![](https://cdn.discordapp.com/attachments/814658514328354867/838066393097830490/unknown.png)

| Variable Name | What it do                                                   |
| ------------- | ------------------------------------------------------------ |
| Game Name     | What is displayed in a large bold font over the cover when it is in front of the user |
| Author Name   | Second line displayed above cover is "by `Author Name`"      |
| Cover         | Image used as game cover. <br />Can be of any resolution and aspect ratio, the launcher will scale it to look reasonable.<br />Most formats are supported, [details can be found here](https://docs.godotengine.org/en/stable/getting_started/workflow/assets/importing_images.html). |
| Rotate        | If using zine pages as covers - some of them can be intended to be read in landscape mode. <br />This dropdown eliminates the need to open an image editor. <br />[Handy free tool to convert PDF pages to PNGs in bulk](https://pdf2png.com/). |
| Game Type     | Changes the third line displayed above the cover as well as the way the launcher treats the file provided in `File To Run`.<br />How to change these will be described in detail later. |
| File To Run   | Relative path from the compiled .exe of the launcher to the file you intend this cover to launch. <br />Details below. |

### File Paths and how to use them

Paths to the app/file you want to open/run can be relative or absolute. I recommend using relative paths if you intend to share the launcher with other people as it is not relying on the user unpacking the bundle in a specific spot. Lets examine the relative paths from Launcher.exe in the provided example.

Folder structure of example

```
Launcher Example
┣━A folder
┃ ┣━Folder inside a folder
┃ ┃ ┣━yo-grl
┃ ┃ ┃ ┣━info.txt
┃ ┃ ┃ ┗━yo-grl.gb
┃ ┃ ┗━TEXTREME.exe
┃ ┗━example_video.mp4
┣━GB Emulator
┣━example pdf file.pdf
┗━Launcher.exe
```

| What the launcher will do                      | `File To Run` variable                                 | `Game Type` variable     |
| ---------------------------------------------- | ------------------------------------------------------ | ------------------------ |
| open `example pdf file.pdf`                    | example pdf file.pdf                                   | link/pdf/html/other file |
| open `example_video.mp4`                       | A folder\\\example_video.mp4                           | link/pdf/html/other file |
| run `TEXTREME.exe`                             | A folder\\\Folder inside a folder\\\TEXTREME.exe       | windows exe              |
| run `yo-grl.gb` in a Gameboy emulator          | A folder\\\Folder inside a folder\\\yo-grl\\\yo-grl.gb | gameboy rom              |
| open `Folder insdie a folder` in file explorer | A folder\\\Folder inside a folder                      | link/pdf/html/other file |
| open `itch.io` in browser                      | https://itch.io                                        | link/pdf/html/other file |

Keep in mind that to test if your launcher is able to launch the things you want it to it first has to be exported and placed in the folder where the files it will launch/folders containing those files are located (Done through `Project > Export` in the top right).

## Making your launcher sexy

If you got this far you probably already have a functioning launcher but it still doesn't fit the theme of your bundle or your personal style. Not to worry, the appearance shouldn't be hard to change!

### Fonts

Make sure to drop the fonts you want to use into the project folder in `.otf` or `.ttf` format. 

#### Game title

Open `Game.tscn`, find the `TextInfo > GameName` node. In the inspector scroll down until you see the `Custom Fonts` tab. Inside you will find a font resource, click on it. You should now see this. Drag and drop your new font into `Font Data` and change other variables until you are satisfied. You can change the color of the letters in the `Custom Colors` tab below.

![](https://cdn.discordapp.com/attachments/814658514328354867/838078660215832586/unknown.png)

#### Author and file type

In `Game.tscn` edit the parameters of the `TextInfo > ExtraInfo` node.

#### Control instructions

In `Launcher.tscn` edit the parameters of the `Controls` node.



### Other Visuals

#### Background

In `Launcher.tscn` edit the children of `Background`. You can use sprites or a tiled TextureRect node. Simple effects can be applied to it using ColorRect nodes/other images with CanvasItemMaterial set to different mixing modes. If you already know how to use Godot I'm sure you can come up with some fun shaders or animations to put there.

**IMPORTANT DETAIL**
Project is currently configured in a way where the users with any monitor size and aspect ratio will see the same amount of the scene vertically. If the user has a 4:3 aspect ratio they will not see the sides of what is in the thin blue border. If they have an ultra wide monitor they will see beyond the thin blue border. Because of this please make sure to add a bit of padding around what the camera would normally see.

#### Quit Launcher Pop-Up

In `Launcher.tscn` edit the children of `Exit Popup`. Everything inside of that node is purely decorative and can be changed however you want.

#### Tint on game cover

In `Launcher.tscn` edit the parameters of `Carousel`. The covers are tinted the colour of `Far Tint * Unselected Tint` when they are on the furthest point of the carousel from user. They are tinted the colour of `Unselected Tint` when they are on the closest point of the carousel. They are not tinted at all when they are selected (located in the front of carousel and in the middle of your screen). Tint can be removed by setting tint colours to white.



### Sounds

#### Moving the carousel

In `Launcher.tscn` change the `Stream` parameter in the `Move` node to a .wav file of your choice.

#### Launching a game

In `Game.tscn` change the `Stream ` parameter in the `Success` node to a .wav file of your choice.

#### Nothing to launch

In `Game.tscn` change the `Stream` parameter in the `Failure` node to a .wav file of your choice.

-------



# Advanced Fuckery

## Inner workings

| Game Type                | What it does                                                 |
| ------------------------ | ------------------------------------------------------------ |
| no file                  | does nothing and plays a disappointed sound                  |
| windows exe              | Asks OS to run the given file with no arguments<br />OS.execute(file_to_run, [], false) |
| link/pdf/html/other file | Sends a URI to open to the OS<br />OS.shell_open(file_to_run) |
| gameboy rom              | Asks OS to run the emulator with the provided ROM as an argument<br />OS.execute("GB Emulator\\bgb.exe", ["-rom", file_to_run], false) |



## Emulating other consoles

Find an emulator for your console of choice that:

1. You can legally package with your bundles
2. Can be run from console with game file to emulate as an argument



Open `Game.gd`, edit line with `game_type` export var.

```
export (int, "no file", "windows exe", "link/pdf/html/other file", "gameboy rom", "new console to emulate") var game_type
```

edit the `match game_type:` in `func _ready():`

```
match game_type:
		0:
			# no exe
			$TextInfo/ExtraInfo.text += "no compatible file available"
			pass
		1:
			# exe
			$TextInfo/ExtraInfo.text += "a Windows executable"
			pass
		2:
			# pdf/html
			$TextInfo/ExtraInfo.text += "opens a file"
			pass
		3:
			# gb rom
			$TextInfo/ExtraInfo.text += "GameBoy ROM that runs in emulator"
			pass
		4:
			# new console to emulate
			$TextInfo/ExtraInfo.text += "Game emulated in my new console"
```

edit the `match game_type:` in `func play():`

```
	match game_type:
		0:
			# nothing to run
			$Failure.play()
			pass
		1:
			# exe
			OS.execute(file_to_run, [], false)
			$Success.play()
			pass
		2:
			# pdf/html/other file
			OS.shell_open(file_to_run)
			$Success.play()
			pass
		3:
			# gb rom
			OS.execute("GB Emulator\\bgb.exe", ["-rom", file_to_run], false)
			$Success.play()
			pass
		4:
			# new console to emulate
			OS.execute("relative path to new emulator", 
					[arguments to run file_to_run as array of strings], false)
			$Success.play()
```

