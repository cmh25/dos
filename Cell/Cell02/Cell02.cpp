//Cell02.cpp 

#include <iostream.h> 
#include <graph.h>
#include <stdio.h>
#include <dos.h> 
#include <memory.h>
#include <string.h> 
#include <fcntl.h>
#include <sys\types.h>
#include <sys\stat.h>
#include <io.h> 
#include <conio.h> 
#include <stdlib.h>
                
int hand;
                
char buffer[64000]; 
char* pbuffer=buffer; 

char buffer5[64000];
char* p2buffer5=buffer5;
  
char buffer2[32000];
char* pbuffer2=buffer2;

void* pbuffer3 = _MK_FP(0xa000,0); 

char* pbuffer4=buffer;
char* pbuffer5=buffer5;
 
char pixel;
char abyte; 
int neighbor_count=0;

short pixel2;  

long generation=0;
char* pgeneration;

int main()
{     
	//set video mode  
	_setvideomode(_MRES256COLOR);
	       
	//put 320 x 200 16 color image in buffer2
    hand=_open("cell02.bmp",_O_BINARY,_O_RDONLY); 
    _lseek(hand,0x76,SEEK_SET); 
    _read(hand,pbuffer2,32000); 
    _close(hand);
    
    //put modified image(1 byte/pixel) in buffer   
    pbuffer=buffer;
    pbuffer2=buffer2;
    pbuffer2+=31840;
    
    for(int i=200;i>0;i--)      //do 200 rows
    {
    	for(int j=160;j>0;j--)       //do 320 pixels
    	{
    		abyte=*pbuffer2++;
    		pixel=0;
    		if(abyte&0x80) 
    			pixel=pixel|0x08;
    		if(abyte&0x40)       
    			pixel=pixel|0x01;
    		if(abyte&0x20)       
    			pixel=pixel|0x02;
    		if(abyte&0x10)       
    			pixel=pixel|0x04;
			*pbuffer++=pixel;
			pixel=0;    			
    		
    		if(abyte&0x08)
    			pixel=pixel|0x08;
    		if(abyte&0x04)       
    			pixel=pixel|0x01;
    		if(abyte&0x02)       
    			pixel=pixel|0x02;
    		if(abyte&0x01)       
    			
    			pixel=pixel|0x04;
    		*pbuffer++=pixel;
    	} 
    	pbuffer2-=320;
    }
                
    //at this point, buffer=vga; pbuffer4=pbuffer3;
    
    //display bitmap
	_fmemcpy(pbuffer3, pbuffer4, 64000);
	_fmemcpy(pbuffer5,pbuffer4,64000); 
	
	_asm
	{
		mov ah,0
		int 16h
	}	      
	                                          
	while(1)
	{           
		_asm
		{
			mov ah,1
			int 16h
			cmp ah,28
			jnz keepgoing
			jmp done
			keepgoing:
		}                          
		//check pixels on screen and change buffer accordingly   
		pbuffer=buffer;  
		p2buffer5=buffer5;
		for(long y=0;y<64000;y++)
		{			
			pixel2=*p2buffer5;  //get current pixel 
			                 
			//check if blue
			if(pixel2==1)
			{
				//check neighbors;
				neighbor_count=0;					
				if(*(p2buffer5-1)==1) 
					neighbor_count++;				
				if(*(p2buffer5-321)==1) 
				    neighbor_count++;
				if(*(p2buffer5-320)==1) 
				    neighbor_count++;
				if(*(p2buffer5-319)==1) 
					neighbor_count++;
				if(*(p2buffer5+1)==1)
					neighbor_count++;
				if(*(p2buffer5+321)==1) 
					neighbor_count++;
				if(*(p2buffer5+320)==1)  
				    neighbor_count++;
				if(*(p2buffer5+319)==1)	
					neighbor_count++;
				//stay alive or die
				if(neighbor_count<2)
					*pbuffer=0;
				if(neighbor_count>3)
					*pbuffer=0;
			}    
				     
			//check if black
			if(pixel2==0)
			{
				//check neighbors;
				neighbor_count=0;					
				if(*(p2buffer5-1)==1) 
					neighbor_count++;
				if(*(p2buffer5-321)==1) 
				    neighbor_count++;
				if(*(p2buffer5-320)==1) 
					neighbor_count++;
				if(*(p2buffer5-319)==1) 
					neighbor_count++;
				if(*(p2buffer5+1)==1)
				    neighbor_count++;
				if(*(p2buffer5+321)==1) 
					neighbor_count++;
				if(*(p2buffer5+320)==1)  
					neighbor_count++;
				if(*(p2buffer5+319)==1)	
					neighbor_count++; 
				//stay dead or be born
				if(neighbor_count==3)
					*pbuffer=1;

			} 
			pbuffer++;
			p2buffer5++;
			
		}    
		//getchar();
		_fmemcpy(pbuffer3, pbuffer4, 64000); 
        _fmemcpy(pbuffer5, pbuffer4, 64000);
		//output generation info  
		_settextcolor(1);
		_settextposition(0,0);
		_outtext("Generation: ");
		generation++;
		_ltoa(generation,pgeneration,10);  
		_outtext(pgeneration);

		
		
	} 
done:
	
	
	_setvideomode(_TEXTC80);
	return 0;	
}