PipPIM

To often have I seen great applications not use standard file formats. A primary example is remind, which is used by many. It has it's own file format instead of using the iCal specification. PipPIM is a ruby based PIM designed to fill in perceived gaps in the Linux PIM 'industry'.

Planned Features:

 - Online Synchronization
 - NCurses interface(s)
 - A contact manager (using the vcard format)
 - A todo list (using the iCal format as well)

So far, this PIM suite only has a calendar.

How to use the calendar
=======================

The calendar is designed to emulate the UNIX cal program in look, but not necessarily in functionality. It's supposed to be speedy and highlight all the days that have events (as defined in the iCalendar files).

This program is split into 2: A client and server.

The server looks for all files with .ics as extensions in the folder calendars/ in the same directory as it is.
The client connects to this server via DRb and generates the calendar itself in stdout.

## Dependencies:
 - [Icalendar](http://icalendar.rubyforge.org) (tested with version 1.0.2)

## How to run pipcal:
Start the server:

    ruby pippim_server.rb

And it will sit there, don't worry, it's running.

Run the client:

    ruby cal.rb

And out should pop a calendar with the dates in the ics files highlighted!
