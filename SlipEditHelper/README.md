# SlipEditHelper

SlipEditHelper is a Lua script for the digital audio workstation Reaper to assist with slip editing audio files. When executed it splits the selected item slightly before the next transient for early hits, or slightly before the nearest grid point for late hits. It then moves the contents of the now split item so that the transient aligns with the nearest grid point, just as in manual slip editing. It ignores transients that are "close enough" to the grid.

## Installation

1. Download this folder.
2. While the folder may be placed anywhere in your hard drive, other Reascripts are typically located in the Reaper Scripts folder. On Windows, this is likely `C:\Users\{yourusername}\AppData\Roaming\REAPER\Scripts`
3. Open Reaper. Click the Actions tab in the toolbar at the top left, then "Show action list...". Click "New action..." then "Load action...". Navigate to the directory where you downloaded the script, and open it.

Tip: if you couldn't find the Scripts folder in step 2, clicking "Load action..." in step 3 will likely open the Scripts folder.

## Usage

### Setting the transient detection sensitivity

This tool makes use of Reaper's built-in transient detection algorithm. To adjust the transient detection settings, click the Edit tab followed by Transient Detection Settings. Adjust this so that Reaper detects most or all of the item's transients without detecting non-hits. This may need to be adjusted frequently for very dynamic parts.

### Editing

This tool is most effective when assigned to an easily executable keyboard shortcut on the left side of the keyboard, as this leaves your right hand free for mouse movement during editing. I recommend unassigning `Alt+X` from the "Auto-crossfade media items when editing" action and assigning `Alt+X` to the SlipEditHelper action.

Set the grid division to match the items rhythm, just like you would with standard slip editing. Routinely reset the grid division when the item's rhythm changes.

Select the media item(s) that you would like to edit. If editing drums, render a dummy track with the kit items that you would like to edit--typically kick, snare, and toms. Group this new track with the other drum tracks and select this dummy track. Place the cursor before the first hit that you would like to edit, and execute the SlipEditHelper action using the keyboard shortcut that you assigned. Confirm that the tool correctly detected the transient of the next off-time hit, and that it moved it to the intended grid point. Repeat this process, periodically listening to the new edits to check for incorrect or bad edits. Undo with `Ctrl+Z` as needed and manually edit difficult hits if needed.

## Troubleshooting

### Missed Hits

- Lower the Transient Detection threshold.
- Place the edit cursor before the missed hit and execute the action again. Occasionally Reaper's tab-to-transient item will miss a hit the first time, but will detect it if the edit cursor is in a different spot.

### Edits at Points with No Transient

- Increase the Transient Detection threshold
- If editing drums, gate and/or high/low pass filter the kit pieces before rendering the dummy track

### Item Contents Moved to Unintended Grid Points

- Ensure that the grid division is set to match the rhythm of the item
- Occasionally a transient will be very off-time, roughly in between two grid points, but slightly closer to the incorrect grid point. In this case the tool will move the item's contents to the unintended grid point. Undo and manually edit the transient.
