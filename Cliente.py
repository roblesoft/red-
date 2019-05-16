import socket

PORT = 5555
HOST = '127.0.0.1'


with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.connect((HOST, PORT))
    s.sendall(b'Hello, word')
    data = s.recv(1024)
print('Recived', repr(data))
