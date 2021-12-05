# macchina.io REMOTE Device Agent and Client Utilities Installer Script

## About macchina.io REMOTE

[macchina.io REMOTE](https://macchina.io/remote) provides secure remote access to connected devices
via HTTP or other TCP-based protocols and applications such as secure shell (SSH) or
Virtual Network Computing (VNC). With macchina.io REMOTE, any network-connected device
running the macchina.io REMOTE Device Agent software (*WebTunnelAgent*, contained in this SDK)
can be securely accessed remotely over the internet from browsers, mobile apps, desktop,
server or cloud applications.

This even works if the device is behind a NAT router, firewall or proxy server.
The device becomes just another host on the internet, addressable via its own URL and
protected by the macchina.io REMOTE server against unauthorized or malicious access.
macchina.io REMOTE is a great solution for secure remote support and maintenance,
as well as for providing secure remote access to devices for end-users via web or
mobile apps.

Visit [macchina.io/remote](https://macchina.io/remote) to learn more and to register for a free account.
Specifically, see the [Getting Started](https://macchina.io/remote_signup.html) page and the
[Frequently Asked Questions](https://macchina.io/remote_faq.html) for
information on how to use this SDK and the included *WebTunnelAgent* executable.


## About This Repository

This repository contains a shell script that clones the
[macchina.io REMOTE SDK](https://github.com/my-devices/sdk)
repository and builds the macchina.io REMOTE
[Device Agent (WebTunnelAgent)](https://github.com/my-devices/sdk/blob/master/WebTunnel/WebTunnelAgent/README.md)
and Client Utilities
[`remote-client`](https://github.com/my-devices/sdk/blob/master/WebTunnel/WebTunnelClient/README.md),
[`remote-ssh`](https://github.com/my-devices/sdk/blob/master/WebTunnel/WebTunnelSSH/README.md),
[`remote-scp`](https://github.com/my-devices/sdk/blob/master/WebTunnel/WebTunnelSCP/README.md),
[`remote-sftp`](https://github.com/my-devices/sdk/blob/master/WebTunnel/WebTunnelSFTP/README.md),
[`remote-vnc`](https://github.com/my-devices/sdk/blob/master/WebTunnel/WebTunnelVNC/README.md) and
[`remote-rdp`](https://github.com/my-devices/sdk/blob/master/WebTunnel/WebTunnelRDP/README.md).

To run the script:

```
$ curl https://raw.githubusercontent.com/my-devices/agent-installer/master/install.sh | bash
```

The script should work on most Debian and RedHat-based Linux distributions including Ubuntu and Raspbian.
On macOS, [Homebrew](https://brew.sh/) must be installed.

The script will install all required dependencies, then get the sources from GitHub and run the steps
necessary to build and install the binaries in `/usr/local/bin/`.
