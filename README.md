# 3D UI Demo – Godot

This is a prototype implementation of a 3D menu in Godot. Feel free to use it for learning purpose or as a base for your own 3D UI.

It's the scene setup and source codes as promised in the comment section of this Reddit post:  
[&rarr; I had so much fun building a prototype for a game's main menu in 3D instead of using Godot's Control nodes!](https://www.reddit.com/r/godot/comments/wbrvhj/i_had_so_much_fun_building_a_prototype_for_a/)


## Where to start?

First of all start Godot and load the project, of course.


### Minimal

Have a look into the [menu-minimal/](./menu-minimal/) folder and open the [`MainMenu.tscn`](./menu-minimal/MainMenu.tscn) file.  
This is a most basic sample scene to achieve a 3D menu as seen in the Reddit post linked above.

I recommend to use that one as a base for your own menu, don't use the party mode sources.

Speaking of which…


### Party

To see how I've implemented the "party mode" as seen in the video of said Reddit post head to the [menu-partymode/](./menu-partymode/) folder and open the [`MainMenu.tscn`](./menu-partymode/MainMenu.tscn) file in it.

Basically the party mode sources are a direct copy of the minimal directory where I simply added a bit extra stuff.


#### Activate party mode

Activating the party mode is mapped to the space bar key.


#### By no means perfect

Please know that this whole project was a fun idea without the aspiration of building something neat and elegant. Especially the party-mode related code is put together roughly and explicitly without any sophisticated design priniciples of software development in mind.  
Long story short, it's quick and dirty at one or another place. So be warned. 😉


#### No sound

Be informed that I had to remove all audio files from the project that I originally used in the video on Reddit. I removed them due to licensing.  
The background music and sound effects came from some previous [&rarr; Humble Bundle](https://www.humblebundle.com/software) offers as well as from the [&rarr; Universal SFX](https://imphenzia.com/universal-sound-fx) pack made by Imphenzia.  
I can use these sound files commercially and everything, but I am not allowed to redistribute them in a free repository like this one on GitHub.

That's why I removed all sounds from the party. You can simply reenable them by uncommenting the appropriate lines in [`MainMenu.gd`](./menu-partymode/MainMenu.gd) and [`MenuItem_Party.gd`](./menu-partymode/MenuItem_Party.gd) and adding your own sounds to the [menu-partymode/](./menu-partymode/) folder.


## License

This project and all its files, unless stated differently, are licensed under the terms of the **MIT license** (also known as **Expat** or **X11** license). See also the project's [license file](./LICENSE).

Keep in mind that the used [font](./fonts/JetBrainsMono-2.242/), for instance, is licensed under **SIL Open Font License Version 1.1**. (By the way that font is really awesome!)

Godot itself which has been used to create this project is also licensed under **MIT license**, see also [&rarr; the official website of Godot](https://godotengine.org/license).
