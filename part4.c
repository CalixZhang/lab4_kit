#include <unistd.h>
#include <stdio.h> 

#define switches (volatile char *)     0x00002010;
// SW[0] WILL BE "DIRECTION"           // 0: DOWN   1: UP
// SW[1] - SW[3] WILL BE "COLOR"
// SW[4] WILL BE "MODE"                // 0: STALL, 1: POLL

volatile unsigned int* MODE =          0x00700000; 
volatile unsigned int* STATUS =        0x00700004;
volatile unsigned int* GO =            0x00700008;
volatile unsigned int* LINESTART =     0x0070000C;
volatile unsigned int* LINEEND =       0X00700010;
volatile unsigned int* LINECOLOR =     0X00700014;


void main(){

	// Initiate the line
	*LINESTART = 513; // Y: 8b'0000 0001 (1)    X: 9b'0 0000 0001 (1)
	*LINEEND   = 848; // Y: 8b'0000 0001 (1)    X: 9b'1 0101 0000 (336)
	*LINECOLOR =   3; // COLOR: NOT BLACK

	while(1){
	
		// 1. Drawing the line at its current position.
		// *LINECOLOR = *switches
		
		// 2. Erasing the line at its previous position, by drawing a black line with colour=000.
		*LINECOLOR =   0; // COLOR: BLACK

		if(){                          // ~SW[0], Line goes down
		
			*LINESTART -= 256;
			*LINEEND -= 256;

		}
		else{                          // SW[0], Line goes up
		
			*LINESTART += 256;
			*LINEEND += 256;
		
		}
		
		// 3. Waiting for one frame's worth of time (eg. 1/30th of a second)
		sleep(40);
		
		// 4. Updating the line's current/old positions and going back to Step 1
		*LINECOLOR =   3; // COLOR: NOT BLACK

		if(){                          // ~SW[0], Line goes down
		
			*LINESTART += 512;
			*LINEEND += 512;
			
			// If y coordinate too large, reset to 0
			if(LINESTART >= 107520){ // Y: 8b'1101 0010 (210)  X: 9b'0 0000 0000 (0)
		
				// Reset this value before redrawing
				*LINESTART = 513; // Y: 8b'0000 0001 (1)    X: 9b'0 0000 0001 (1)
				*LINEEND = 848;   // Y: 8b'0000 0001 (1)    X: 9b'1 0101 0000 (336)
			}
		}
		else{                          // SW[0], Line goes up
		
			*LINESTART -= 512;
			*LINEEND -= 512;
			
			// If y coordinate too small, reset to 210
			if(LINESTART <= 0){   // Y: 8b'0000 0000 (0)   X: 9b'0 0000 0000 (0)

				// Reset this value before redrawing
				*LINESTART = 513; // Y: 8b'1101 0010 (210) X: 9b'0 0000 0001 (1)
				*LINEEND = 848;   // Y: 8b'1101 0010 (210) X: 9b'1 0101 0000 (336)
			
			}
		
		}
		
	}
}