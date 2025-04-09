#!/usr/bin/python3

import socket
import sys

import time 
import struct
import numpy as np

localIP      = "127.0.0.1"

localPort   = 8091

bufferSize  = 1024



# Create a datagram socket

UDPServerSocket = socket.socket(family=socket.AF_INET, type=socket.SOCK_DGRAM)
 

# Bind to address and ip
UDPServerSocket.bind((localIP, localPort))

print("UDP server up and listening")

snr = np.array([], dtype=float)

tmpCount = 0;

while(True):

    bytesAddressPair = UDPServerSocket.recvfrom(bufferSize)

    message = bytesAddressPair[0]

    address = bytesAddressPair[1]

    # print(message[0:3])
    # print("\n")

    clientMsg = "Message from Client:{}".format(message)
    clientIP  = "Client IP Address:{}".format(address)

    print(clientMsg)
    print(clientIP)

