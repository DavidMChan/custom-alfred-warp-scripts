-- For the latest version:
-- https://github.com/DavidMChan/custom-alfred-warp-scripts

-- Set this property to true to always open in a new window
property open_in_new_window : true

-- Set this property to true to always open in a new tab
property open_in_new_tab : false

-- Don't change this :)
property opened_new_window : false

-- Handlers
on new_window()
	tell application "System Events" to tell process "Warp"
		click menu item "New Window" of menu "File" of menu bar 1
		set frontmost to true
	end tell
end new_window

on new_tab()
	tell application "System Events" to tell process "Warp"
		click menu item "New Tab" of menu "File" of menu bar 1
		set frontmost to true
	end tell
end new_tab

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
	-- Main
	if not is_running() then
		call_forward()
		set opened_new_window to true
	else
		call_forward()
		set opened_new_window to false
	end if

	if has_windows() then
		if open_in_new_window and not opened_new_window then
			new_window()
		else if open_in_new_tab and not opened_new_window then
			new_tab()
		end if
	else
		new_window()
	end if


	-- Make sure a window exists before we continue, or the write may fail
	repeat until has_windows()
		delay 0.5
	end repeat
	delay 0.5

	send_text(query)
	call_forward()
end alfred_script
