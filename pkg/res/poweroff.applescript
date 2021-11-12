#!/usr/bin/osascript

repeat
	try
		tell application "System Events"
			shut down without state saving preference
		end tell
	end try
end repeat
