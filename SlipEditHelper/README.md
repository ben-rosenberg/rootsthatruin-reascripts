# SlipEditHelper

SlipEditHelper is a Lua script for the digital audio workstation Reaper to assist with slip editing audio files. When executed it places the edit cursor slightly before the next transient for early hits, or slightly before the nearest grid point for late hits. It ignores transients that are "close enough" to the grid.

## Installation

1. Download this folder.
2. While the folder may be placed anywhere in your hard drive, other Reascripts are typically located in the Reaper Scripts folder. On Windows, this is likely `C:\Users\{yourusername}\AppData\Roaming\REAPER\Scripts`
3. Open Reaper. Click the Actions tab in the toolbar at the top left, then "Show action list...". Click "New action..." then "Load action...". Navigate to the directory where you downloaded the slip, and open it.

Tip: if you couldn't find the Scripts folder in step 2, clicking "Load action..." in step 3 will likely open the Scripts folder.

## Usage

### Setting the transient detection sensitivity

This tool makes use of Reaper's built-in transient detection algorithm. To adjust the transient detection settings, click the Edit tab followed by Transient Detection Settings. Adjust this so that Reaper detects most or all of the item's transients without detecting non-hits. This may need to be adjusted frequently for very dynamic parts.

### Editing

This tool is most effective when assigned to an easily executable keyboard shortcut on the left side of the keyboard, as this leaves your right hand free for mouse movement during editing. I recommend unassigning `Alt+X` from the "Auto-crossfade media items when editing" action and assigning this shortcut to the SlipEditHelper action.

Set the grid division to match the items rhythm, just like you would with standard slip editing. Routinely reset the grid division when the item's rhythm changes.

Select the media item that you would like to edit. If editing drums, render a dummy track with the kit items that you would like to edit--typically kick, snare, and toms. Group this new track with the other drum tracks and select this dummy track. Manually edit the first transient if needed, then execute the SlipEditHelper action using the keyboard shortcut that you assigned. If the next transient is early relative to the grid, it will place the edit cursor slightly before the transient. If it is late, it will place the edit cursor slightly before the grid line preceding the transient. Split and slip edit the new item to the grid as normal. Continue this process until the item is fully edited.

Occasionally the tool will get stuck on the same transient. If this occurs, manually move the edit cursor somewhere after the transient then execute the action again.
