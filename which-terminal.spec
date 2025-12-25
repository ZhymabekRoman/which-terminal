Name:           which-terminal
Version:        0.1.0
Release:        1%{?dist}
Summary:        Universal terminal emulator launcher

License:        MIT
URL:            https://github.com/ZhymabekRoman/which-terminal
Source0:        %{url}/archive/v%{version}/%{name}-%{version}.tar.gz

BuildRequires:  make
BuildRequires:  gcc
ExclusiveArch:  x86_64

%description
which-terminal is a tool that detects and runs the best available terminal
emulator on your system. It prioritizes terminals based on the display server
(X11 or Wayland) and running processes.

This tool aims to provide a universal way to call any GUI terminal from a
command-line interface, solving the fragmentation problem across different
Linux distributions.

%prep
%autosetup

%build
make build-prod

%check
make test || true

%install
install -Dm755 which-terminal %{buildroot}%{_bindir}/which-terminal
ln -s which-terminal %{buildroot}%{_bindir}/x-terminal-emulator

%files
%license LICENSE
%doc README.md
%{_bindir}/which-terminal
%{_bindir}/x-terminal-emulator

%changelog
* Fri Dec 26 2025 ZhymabekRoman <robanokssamit@yandex.kz> - 0.1.0-1
- Initial package release
