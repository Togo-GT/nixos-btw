{ config, pkgs, ... }:

let
  networkingPackages = with pkgs; [
    # =====================================
    # NETWORK DIAGNOSTICS AND ANALYSIS
    # =====================================
    iperf3      # Network bandwidth measurement tool
    nmap        # Network discovery and security auditing
    masscan     # Mass IP port scanner
    tcpdump     # Command-line packet analyzer
    tcpflow     # TCP stream recorder and analyzer
    traceroute  # Display network path to a host

    # =====================================
    # VPN AND NETWORK SECURITY
    # =====================================
    ettercap        # Comprehensive network sniffer and interceptor
    openvpn         # VPN daemon for secure point-to-point connections
    wireguard-tools # Fast and modern VPN implementation

    # =====================================
    # DOWNLOAD TOOLS
    # =====================================
    wget  # Command-line utility for downloading files from the web
  ];
in {
  environment.systemPackages = networkingPackages;
}
