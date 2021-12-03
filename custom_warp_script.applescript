-- For the latest version:
-- https://github.com/DavidMChan/custom-alfred-warp-scripts

-- Set this property to true to always open in a new window
property open_in_new_window : true

-- Handlers
on new_window()
	tell application "System Events" to tell process "Warp"
		click menu item "New Window" of menu "File" of menu bar 1
		set frontmost to true
	end tell
end new_window

on call_forward()
	tell application "Warp" to activate
end call_forward

on is_running()
	application "Warp" is running
end is_running

on has_windows()
	if not is_running() then return false
	tell application "System Events"
		if windows of process "Warp" is {} then return false
	end tell	
	true
end has_windows

on send_text(custom_text)
	tell application "System Events"
		keystroke custom_text
	end tell
end send_text

-- Main
on alfred_script(query)
	if has_windows() then
		if open_in_new_window then
			new_window()
		end if
	else
		-- If Warp is not running and we tell it to create a new window, we get two
		-- One from opening the application, and the other from the command
		if is_running() then
			new_window()
		else
			call_forward()
		end if
	end if

	-- Make sure a window exists before we continue, or the write may fail
	repeat until has_windows()
		delay 0.01
	end repeat

	send_text(query)
	call_forward()
end alfred_script
