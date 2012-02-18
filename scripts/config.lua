Setup.Package
{
    vendor = "liflg.org",
    id = "shogo",               -- unique identifier, will be proposed as installdirectory SAMPLE: "fakk2"
    description = "Shogo",      -- full name of the game, will be used during setup SAMPLE: "Heavy Metal: FAKK2"
    version = "2.2.11-multilingual",          -- version of the game SAMPLE: "1.02-english"
    splash = "splash.png", -- name of the splash file which has to be placed inside the meta directory
    superuser = false, 
    write_manifest = true, -- needs to be true if an uninstall-option should be provided
                           -- NOTE: atm installing serveral thousands files will slow down the installation process

    support_uninstall = true, 
    recommended_destinations =
    {
        "/usr/local/games",
	"/opt/",
	MojoSetup.info.homedir,
    }, 

    Setup.Readme
    {
        description = "README",
        source = "README.liflg"
    },

    Setup.Media
    {
        id = "shogo-disc",          -- unique identifier for the cd/dvd-rom SAMPLE: "fakk2-cd"
        description = "Shogo Linux Disc", -- this string will be shown to the end-user SAMPLE: "FAKK2-Loki CDROM"
        uniquefile = "Documentation/hshogoweb.html"   -- unique file to decide if a disc is the right one SAMPLE: "fakk/pak0.pk3"
    },

    Setup.DesktopMenuItem
    {
        disabled = false,
        name = "Shogo",           -- name of the menu-entry. SAMPLE: "Heavy Metal: FAKK2"
        genericname = "Ego-Shooter",    -- generic name. SAMPLE: "Ego-Shooter"
        tooltip = "Play Shogo",        -- tooltip SAMPLE "play Heavy Metal: FAKK2"
        builtin_icon = false,
        icon = "shogo.xpm",   -- path to icon file, realtive to the base-dir of the installation
        commandline = "%0/shogo.sh",    -- gamebinary or startscript, "%0/" stands for the base directory of the installation SAMPLE: "%0/fakk2.sh"
        category = "Game", 
    },

   Setup.Option
    {    
    	value = true,
	required = true,
    	disabled = false,
    	bytes = 640933971,
    	description = "Required game data",
    	tooltip = "Needs the Shogo-Linux-CDROM",
   
    	Setup.File
    	{
	    	wildcards = { "shogo.sh", "registergui.sh", "shogo", "shogosrv", "shogosrv.sh" },
		permissions = "0755",
    	},

	Setup.File
	{
		wildcards = "README.liflg",
	},

	Setup.File
	{
		source = "base:///dirs.tar/",
	},

	Setup.File
	{
		source = "base:///libesd-alsa0_0.2.36-3_i386.tar",
	},

	Setup.File
	{
		source = "base:///libgtk1.2.tar",
	},
   
    	Setup.File
    	{
    		source = "media://shogo-disc/",
    		wildcards = { "Documentation/*", "Movies/*", "README*", "shogo.xpm" }
    	},
 
     	Setup.File
	{
		source = "media://shogo-disc/setup.data/",
		wildcards = { "registergui" },
		permissions = "0755",
	},

    	Setup.File
    	{
    		source = "media://shogo-disc/files/bin.tgz",
    	},
    
    	Setup.File
    	{
    		source = "media://shogo-disc/files/data.tgz",
    	},
 
 	Setup.Option
	{
		value = false,
		bytes = 119594,
		description = "German texts",
		tooltip = "Add the german texts",
		Setup.File
		{
			source = "media://shogo-disc/files/german.tgz",
		},
	},
    },
}

