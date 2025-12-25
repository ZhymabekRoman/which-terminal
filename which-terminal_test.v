module main

// Test wayland terminals list
fn test_wayland_terminals_list() {
	assert wayland_terminals.len > 0
	assert 'foot' in wayland_terminals
	assert 'alacritty' in wayland_terminals
	assert 'kitty' in wayland_terminals
}

// Test x11 terminals list
fn test_x11_terminals_list() {
	assert x11_terminals.len > 0
	assert 'alacritty' in x11_terminals
	assert 'xterm' in x11_terminals
	assert 'gnome-terminal' in x11_terminals
}

// Test terminals needing e flag list
fn test_terminals_needing_e_flag_list() {
	assert terminals_needing_e_flag.len > 0
	assert 'gnome-terminal' in terminals_needing_e_flag
	assert 'xterm' in terminals_needing_e_flag
	assert 'terminator' in terminals_needing_e_flag
}

// Test needs_e_flag function for terminals that require -e
fn test_needs_e_flag_true() {
	assert needs_e_flag('gnome-terminal') == true
	assert needs_e_flag('terminator') == true
	assert needs_e_flag('qterminal') == true
	assert needs_e_flag('lxterminal') == true
	assert needs_e_flag('xterm') == true
}

// Test needs_e_flag function for terminals that don't require -e
fn test_needs_e_flag_false() {
	assert needs_e_flag('alacritty') == false
	assert needs_e_flag('kitty') == false
	assert needs_e_flag('foot') == false
	assert needs_e_flag('wezterm') == false
	assert needs_e_flag('nonexistent') == false
}

// Test command_exists for common system commands
fn test_command_exists_basic() {
	// These commands should exist on most Linux systems
	assert command_exists('ls') == true
	assert command_exists('echo') == true

	// This command should definitely not exist
	assert command_exists('this_command_definitely_does_not_exist_xyz123') == false
}

// Test process_running for current shell
fn test_process_running_basic() {
	// The shell running the test should not be running (pgrep won't find test processes)
	// Test with a process that definitely doesn't exist
	assert process_running('this_process_definitely_does_not_exist_xyz123') == false
}

// Test find_terminal with empty list
fn test_find_terminal_empty() {
	empty_list := []string{}
	result := find_terminal(empty_list)
	assert result == ''
}

// Test find_terminal with nonexistent terminals
fn test_find_terminal_nonexistent() {
	fake_terminals := ['fake_terminal_1', 'fake_terminal_2', 'fake_terminal_3']
	result := find_terminal(fake_terminals)
	assert result == ''
}

// Test find_terminal with common system commands (should find first available)
fn test_find_terminal_with_real_commands() {
	// Use common commands as a proxy for testing the logic
	test_list := ['nonexistent_cmd', 'ls', 'echo']
	result := find_terminal(test_list)
	// Should find 'ls' since it exists on all systems
	assert result == 'ls'
}

// Test that wayland and x11 lists contain some common terminals
fn test_common_terminals_in_both_lists() {
	// These should be in both lists as they support both
	common := ['alacritty', 'kitty', 'wezterm', 'tilix']

	for term in common {
		assert term in wayland_terminals
		assert term in x11_terminals
	}
}

// Test that x11-only terminals are not in wayland list
fn test_x11_only_terminals() {
	x11_only := ['xterm', 'rxvt', 'urxvt']

	for term in x11_only {
		assert term in x11_terminals
		assert term !in wayland_terminals
	}
}

// Test that wayland-only terminals are not in x11 list
fn test_wayland_only_terminals() {
	wayland_only := ['foot', 'kgx']

	for term in wayland_only {
		assert term in wayland_terminals
		assert term !in x11_terminals
	}
}

// Test that all terminals needing -e flag are in x11 list
fn test_e_flag_terminals_in_x11() {
	for term in terminals_needing_e_flag {
		// All terminals needing -e should be X11 terminals
		assert term in x11_terminals
	}
}

// Test terminal list consistency
fn test_terminal_lists_not_empty() {
	assert wayland_terminals.len > 0
	assert x11_terminals.len > 0
	assert terminals_needing_e_flag.len > 0
}

// Test that common terminals exist in arrays multiple times or uniquely
fn test_terminal_uniqueness() {
	// Count occurrences to ensure no duplicates in wayland list
	mut wayland_seen := map[string]int{}
	for term in wayland_terminals {
		wayland_seen[term] = wayland_seen[term] + 1
	}
	for term, count in wayland_seen {
		assert count == 1, 'Terminal ${term} appears ${count} times in wayland_terminals'
	}

	// Count occurrences to ensure no duplicates in x11 list
	mut x11_seen := map[string]int{}
	for term in x11_terminals {
		x11_seen[term] = x11_seen[term] + 1
	}
	for term, count in x11_seen {
		assert count == 1, 'Terminal ${term} appears ${count} times in x11_terminals'
	}
}
