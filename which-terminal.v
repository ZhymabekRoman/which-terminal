module main

import os

const wayland_terminals = [
	'foot',
	'kgx',
	'alacritty',
	'kitty',
	'wezterm',
	'ghostty',
	'tilix',
	'blackbox',
	'terminator',
]

const x11_terminals = [
	'alacritty',
	'kitty',
	'wezterm',
	'ghostty',
	'tilix',
	'gnome-terminal',
	'terminator',
	'blackbox',
	'qterminal',
	'lxterminal',
	'urxvt',
	'rxvt',
	'xterm',
]

const terminals_needing_e_flag = [
	'gnome-terminal',
	'terminator',
	'qterminal',
	'lxterminal',
	'xterm',
	'alacritty',
]

fn command_exists(cmd string) bool {
	result := os.execute('command -v ${cmd}')
	return result.exit_code == 0
}

fn get_command_path(cmd string) string {
	result := os.execute('command -v ${cmd}')
	if result.exit_code == 0 {
		return result.output.trim_space()
	}
	return cmd
}

fn process_running(name string) bool {
	result := os.execute('pgrep -x ${name}')
	return result.exit_code == 0
}

fn needs_e_flag(term_name string) bool {
	return term_name in terminals_needing_e_flag
}

fn find_terminal(terms []string) string {
	// First check for running processes
	eprintln('[which-terminal] Checking for running terminal processes...')
	for term in terms {
		if process_running(term) {
			eprintln('[which-terminal] Found running process: ${term}')
			return term
		}
	}
	// Then check for installed commands
	eprintln('[which-terminal] No running terminals found, checking installed commands...')
	for term in terms {
		if command_exists(term) {
			eprintln('[which-terminal] Found installed command: ${term}')
			return term
		}
	}
	return ''
}

fn main() {
	mut term_to_use := ''

	// Determine which display system is in use
	wayland_display := os.getenv('WAYLAND_DISPLAY')
	x_display := os.getenv('DISPLAY')

	if wayland_display != '' {
		eprintln('[which-terminal] Detected Wayland session (WAYLAND_DISPLAY=${wayland_display})')
		term_to_use = find_terminal(wayland_terminals)
	} else if x_display != '' {
		eprintln('[which-terminal] Detected X11 session (DISPLAY=${x_display})')
		term_to_use = find_terminal(x11_terminals)
	} else {
		eprintln('[which-terminal] No display server detected')
	}

	if term_to_use == '' {
		eprintln('which-terminal: could not find a supported terminal emulator.')
		exit(1)
	}

	// Get the full path to the terminal
	term_path := get_command_path(term_to_use)
	eprintln('[which-terminal] Selected terminal: ${term_to_use} (${term_path})')

	args := os.args[1..]

	if args.len > 0 {
		mut exec_args := []string{}
		if needs_e_flag(term_to_use) {
			exec_args << term_path
			exec_args << '-e'
			exec_args << args
			eprintln('[which-terminal] Executing: ${term_path} -e ${args.join(" ")}')
		} else {
			exec_args << term_path
			exec_args << args
			eprintln('[which-terminal] Executing: ${term_path} ${args.join(" ")}')
		}

		// Execute the terminal
		mut p := os.new_process(exec_args[0])
		p.set_args(exec_args[1..])
		p.run()
		p.wait()
		exit(p.code)
	} else {
		// Just launch the terminal
		eprintln('[which-terminal] Launching: ${term_path}')
		mut p := os.new_process(term_path)
		p.run()
		p.wait()
		exit(p.code)
	}
}
