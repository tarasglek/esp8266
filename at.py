#!/usr/bin/python
import serial
import sys

ser = serial.Serial('/dev/ttyAMA0', 9600, timeout=1)
ser.write(sys.argv[1] + "\r\n")


while True:
    sys.stdout.write(ser.readline())
    sys.stdout.flush()


ser.close()