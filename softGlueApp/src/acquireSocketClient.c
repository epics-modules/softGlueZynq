#include <stdio.h>
#include <string.h>	// strlen
#include <sys/socket.h>
#include <arpa/inet.h>	// inet_addr
#include "acquireSocket.h"
#include <unistd.h>	// usleep
#include <stdlib.h> // atoi

int debug = 0;

int main(int argc, char *argv[])
{
	int socket_desc, i, j, k, numAvailWords, numRecv;
	struct sockaddr_in server;
	char message[100], server_reply[100];
	unsigned int dataTran[acquireTranWords];
	float totalWords;
	
	// Create socket
	totalWords = 0;
	k = 0;
	socket_desc = socket(AF_INET, SOCK_STREAM, 0);
	if (socket_desc == -1) {
		printf("acquireSocketClient: Could not create socket");
	}
		
	server.sin_addr.s_addr = inet_addr("164.54.104.145"); // acq2206
	server.sin_family = AF_INET;
	server.sin_port = htons( 8888 );

	// Connect to remote server
	if (connect(socket_desc, (struct sockaddr *)&server, sizeof(server)) < 0) {
		puts("acquireSocketClient: connect error");
		return 1;
	}
	
	if (debug) printf("acquireSocketClient: Connected\n");
	
	while (1) {
		// Send some data
		sprintf(message, "%s", "sendnumw");
		if (send(socket_desc, message, CMD_LEN, 0) < 0) {
			printf("acquireSocketClient: Send failed\n");
			return 1;
		}
		//puts("acquireSocketClient: Data Send\n");
		
		// Receive a reply from the server
		for (i=0; i<strlen(server_reply); i++) server_reply[i] = 0;
		numRecv = recv(socket_desc, server_reply, NUM_LEN, MSG_WAITALL);
		if (numRecv < 0) {
			puts("acquireSocketClient: recv failed");
		}
		if (debug) {
			printf("server replied '%s'\n", server_reply);
			printf(" received %d bytes\n", numRecv);
		}
		numAvailWords = atoi(server_reply);
		if (debug) printf("%d words available\n", numAvailWords);
		if (numAvailWords >= acquireTranWords) {
			if (debug) printf("enough for transfer\n");
		} else {
			if (debug) printf("not enough for transfer\n");
		}

		if (numAvailWords >= acquireTranWords) {
			sprintf(message, "%s", "senddata");
			if (send(socket_desc, message, CMD_LEN, 0) < 0) {
				printf("acquireSocketClient: Send failed\n");
				return 1;
			}
			if (debug) puts("acquireSocketClient: Data Send\n");

			// Receive a reply from the server
			numRecv = recv(socket_desc, dataTran, acquireTranWords*4, MSG_WAITALL);
		totalWords += acquireTranWords;
		if (numRecv < 0) {
				puts("acquireSocketClient: recv failed");
			}
			if (debug) printf(" received %d bytes\n", numRecv);
			if (numRecv < 0) {
				printf("acquireSocketClient: recv failed\n");
			}
			if (debug>2) {
				for (j=0; j<8; j++) {
					printf("%d\n", dataTran[j]);
				}
				printf("\n");
			}
		}
		k++;
		if (k%600 == 0) {
			k = 0;
			printf("total words acquired = %.3e\n", totalWords);
		}
		usleep(10000);
	}
	return 0;
}
