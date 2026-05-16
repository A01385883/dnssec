#!/bin/bash
cd /etc/bind

# Limpiar llaves anteriores
rm -f K*.key K*.private db.test.lab.signed

# Generar solo 1 ZSK y 1 KSK
ZSK=$(dnssec-keygen -a ECDSAP256SHA256 -b 256 -n ZONE test.lab)
KSK=$(dnssec-keygen -f KSK -a ECDSAP256SHA256 -b 256 -n ZONE test.lab)

echo "\$INCLUDE ${ZSK}.key" >> db.test.lab
echo "\$INCLUDE ${KSK}.key" >> db.test.lab

named-checkzone test.lab db.test.lab
dnssec-signzone -o test.lab db.test.lab
named -g -c /etc/bind/named.conf
