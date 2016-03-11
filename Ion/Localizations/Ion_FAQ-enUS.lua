--Ion, a World of Warcraft® user interface addon.
--Copyright© 2006-2014 Connor H. Chenoweth, aka Maul - All rights reserved.

--English spelling validated by Eledryn

local L = LibStub("AceLocale-3.0"):NewLocale("Ion", "enUS", true)

L.LINE1 = "TEST"
L.LINE2 = "TEST"
L.LINE3 = "TEST"
L.LINE4 = "TEST"
L.LINE5 = "TEST"

L.FAQ_BAR_CONFIGURE = "Bar Configiration"
L.FAQ_BAR_CONFIGURE_GENERAL_OPTIONS_TITLE = "General Options"
L.FAQ_BAR_CONFIGURE_BAR_STATES_TITLE = "Bar States"
L.FAQ_BAR_CONFIGURE_SPELL_TARGET_TITLE = "Spell Target Options"

L.FAQ_MACRO_EDITOR = "Macro Editor"


L.FAQ = "F.A.Q."
L.FAQ_LONG = "Frequently Asked Questions"

L.WHATS_NEW_TITLE = "ION Helium v1.0 Update Changes"
L.WHATS_NEW_INFO = [[
Bug Fixes
-Fixed issue where mounts would not display proper tooltip.
-Fixed issue where toys would not display proper tooltip.
-Fixed issue where toys would not correct usability shade.
-Fixed issue where auto cast could not be toggled on pet bar.
-Fixed issue where high rank in the Brawler Guild would break the status bars.
-Fixed issue where Bar Editor state list would not display after selection a non action bar.
-Fixed issues with the Macro Editor icon selector and its interaction with spces.
-Fixed issue where a user could not re-add a special bar (Extra Action, Menu) if deleted.
-Updated spell cooldown display to not display cooldown on spells with charges until all charges have been used.
-Tweaked spell detection code to hopefully fix some of the tooltip & cooldown displays issues that are still floating around.
-Various code fixes to help prevent taint errors.

Updates & Additions
*Game Menu Bar*
-Updated code to reflect the current default menu bar.  It now will display alerts when there are changes to collections or talents.  

*Action Bar Editor*
-Added visibility state toggles to editor UI.
-Added additional bar states to option list. States added were target, indoors, outdoors, mounted, flying, help, harm, resting, swimming.
-Added ability to enter custom states via the editor UI.  The UI will check to make sure the entered custom state is valid and give an error if it is not.
-Added spell target options to the bars.  Bars can now be set so spells on them have Self, Focus, & Mouse over casting options.  Only spells that contain the #autowrite line in the macro editor will be affected by the settings. 

*Macro Editor*
-Added a "Reset" button to completely reset the current macro to a fresh state.
-Added a "Save" button to verify that changes have been saved.
-Added spec selection buttons for bars that are set to dual spec.  This allows a user to view a buttons macro info for alternate specs with out having to switch.
-Updated state list to include custom states

*Extra Action Bar*
-Updated button to allow stop requests when a character is on a Taxi.

*Draenor Action Button*
-This has been completely overhauled. The default Blizzard version of the button has been disabled and a new ION specific version has been implemented.  This version has the same functionality as the default button but with the added functionality of ION bars.
-An option to hide the decorative border of the button has been added under its Bar Editor Options.

*Stance Bar*
-A stance bar has been added to ION for classes/specs that have them. 

*Flyouts*
-Flyouts have been updated to provide additional functional and to fix some bugs.  Some of the flyout commands have either changed or have been removed.  Please see the Flyout section of the FAQ for full information.]]


L.FLYOUT = "Flyout"
L.FLYOUT_FAQ = [[Ion allows for the creation of flyout menus of spells, items or companions. It accomplishes this by adding a new macro command and building the menu based on several options. The following are the instructions on how to go about making a custom flyout menu via the ION Button Macro Editor:

Format -  /flyout <type>:<keyword>:<shape>:<flyout anchor point>:<macro button anchor point>:<columns|radius>:<click|mouse>:<show/hide flyout arrow>



Types: Use as many comma-delimited types as you want (ex: "spell, item") 

Keyword: Use as many comma-delimited keywords as you want (ex: "quest, potion, blah, blah, blah")
    Use ! in front of a keyword to exclude anything containing that keyword (ex: "!hearthstone")

Available Types & Keywords:  Note: Special Keywords such as Any or Favorite need to start with a Capitol letter.

item:id or partial name
Add an item by its item:id or all items in your bags or worn that contain the partial name.
Examples: item:1234, item:Bandage, item:Ore

spell:id or partial name
Add a spell by its numerical id or all spells that contain the partial name.
Examples: spell:1234, spell:Shout, spell:Polymorph

mount:"Flying", "Land", "Favorite", "FFlying", "FavLand" or partial name
Add all flying, land, favorite, favorite flying, favorite land mounts or mounts that contain the partial name.
Examples: mount:flying, mount:Raptor, mount:favflying

companion:"Favorite", "Any" or partial name
Adds favorite pets, all pets or pet that contain the partial name.
Examples: companion:Crash, companion:favorite, companion:any

type:ItemType
Add all items that contain the keyword in one of its type fields. See www.wowpedia.com/ItemType for a full list.
Examples: type:Quest, type:Food, type:Herb, type:Leather

profession:"Primary", "Secondary", "Any" or partial name
Adds all primary professions, secondary professions or any professions.
Examples: profession:Primary, profession:Any, profession:Herb

fun:"Favorite", "Any" or partial name
Adds favorite toys, all toys or toys that contain the partial name.
Examples: toy:Crash, toy:favorite, toy:any


Shapes:
    linear
    circular

Flyout Anchor Point is going to be the anchor point on first button of the flyout and influences the direction it goes. IE if you set it "BOTTOM" then the flyout will be anchored on the bottom row and display the rest of the buttons in a upward direction.

Macro Button Anchor Point is where the flyout will appear in relation to button the macro is in and determines what side of the macro the little flyout indicator arrow will be on if enabled. IE if you set it to RIGHT then the indicator will be on the right side and the flyout will be displayed to the right of the macro button.

Points:
    left
    right
    top
    bottom
    topleft
    topright
    bottomleft
    bottomright
    center


Colums/Radius:
    Any number.  For a Linear style this will be how many columns the flyout will have.  For a Circular style, thiw will be how wide the circle will be.  

Click/Mouse:
    click: Displays the flyout when the button is clicked.
    mouse: Displays the flyout on mouse-over.

Show/hide flyout arrow
    show: Displays the flyout indicator arrow
    hide: Hides the indicator arrow.


Examples -

/flyout type:trinket:linear:right:left:6:click:show
This will show all trinkets in a 6 column flyout that displays on a button click

/flyout mount:invincible, phoenix, !dark:circular:center:center:15:mouse:hide
This will display any mounts with invincible & phoenix in the title excluding mounts with the word dark

/flyout companion:Favorite:linear:right:left:4:click:show
This will dislay any companions that are marked as favorite

/flyout spell, item:heal:linear:right:left:4:click:show
This will show all items & spells that have "heal" in the name

Most options may be abbreviated -
/flyout i:bandage:c:c:c:15:c:h is the same as /flyout item:bandage:circular:center:center:15:click:hide]]