//Cell04.cpp 

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
#include <time.h>
 
#define BMP_FILE_LENGTH 30400
#define CELL_MAP_LENGTH 60800 

int hand;//handle for file       

char FileBuffer[BMP_FILE_LENGTH];
char* pFileBuffer=FileBuffer;//read bmp file into this buffer
                
char CurrentCellMap[CELL_MAP_LENGTH]; 
char* pCurrentCellMap=CurrentCellMap;//same as what is on the screen 

char NextCellMap[CELL_MAP_LENGTH];
char* pNextCellMap=NextCellMap;//the next to be put on the screen

void* pVgaBuffer = _MK_FP(0xa000,3200);//starts on the 11th row - first 10 for text 
 
char pixel;
char abyte;// a byte from FileBuffer has 2 pixels 
char neighbor_count=0;  

long generation=0;
char* pgeneration;  

time_t start;
time_t* pstart=&start;
time_t end;    
time_t* pend=&end;
int decimal;
int sign;
char* pchartotaltime;

double totaltime;

int main()
{     
    //set video mode  
    _setvideomode(_MRES256COLOR);//mode 13h
           
    //put 320 x 190 16 color image(2 bytes/pixel) in FileBuffer
    hand=_open("cell04.bmp",_O_BINARY,_O_RDONLY); 
    _lseek(hand,0x76,SEEK_SET); 
    _read(hand,pFileBuffer,BMP_FILE_LENGTH); 
    _close(hand);
    
    //put modified image(1 byte/pixel) in NextCellMap
    pFileBuffer+=BMP_FILE_LENGTH-160;
    
    for(int i=190;i>0;i--)      //do 190 rows
    {
        for(int j=160;j>0;j--)       //do 320 pixels
        {
            abyte=*pFileBuffer++;
            pixel=0;
            if(abyte&0x80) 
                pixel|=0x08;
            if(abyte&0x40)       
                pixel|=0x01;
            if(abyte&0x20)       
                pixel|=0x02;
            if(abyte&0x10)       
                pixel|=0x04;
            *pNextCellMap++=pixel;
            pixel=0;                

            if(abyte&0x08)
                pixel|=0x08;
            if(abyte&0x04)       
                pixel|=0x01;
            if(abyte&0x02)       
                pixel|=0x02;
            if(abyte&0x01)
                pixel|=0x04;
            *pNextCellMap++=pixel;
        } 
        pFileBuffer-=320;
    }   
    pNextCellMap=NextCellMap;            
   
    //display bitmap
    _fmemcpy(pVgaBuffer,pNextCellMap,CELL_MAP_LENGTH);
    _fmemcpy(pCurrentCellMap,pNextCellMap,CELL_MAP_LENGTH);
     
    //setup generation info
    _settextcolor(1);
    _settextposition(0,0);
    _outtext("Generation: ");
    
    getchar(); 
    
    time(pstart);
                                              
    while(generation<1000)
    {                       
        //check pixels in CurrentCellMap(which is also on the screen)
        //and change pixels in NextCellMap accordingly
        for(unsigned short y=0;y<CELL_MAP_LENGTH;y++)
        {           
            pixel=*pCurrentCellMap;  //get current pixel  
            
            if(pixel==0x0f)          //if it's white skip it
            {
                pCurrentCellMap++;
                pNextCellMap++;
                continue;
            }
                
            neighbor_count=0;  
            
            _asm
            {
                push ds
                lds si,pCurrentCellMap
                mov bl,0

                mov al,ds:[si-1] 
                sub al,1
                jnz b1
                inc bl 
              b1:                
              
                mov al,ds:[si-321]
                sub al,1
                jnz b2 
                inc bl 
              b2:                
             
                mov al,ds:[si-320]
                sub al,1
                jnz b3
                inc bl  
              b3:                       
              
                mov al,ds:[si-319]
                sub al,1
                jnz b4
                inc bl  
              b4:                       
               
                mov al,ds:[si+1]
                sub al,1
                jnz b5
                inc bl  
              b5:                          
             
                mov al,ds:[si+321]
                sub al,1
                jnz b6
                inc bl  
              b6:                          
            
                mov al,ds:[si+320]
                sub al,1
                jnz b7
                inc bl  
              b7:                         
              
                mov al,ds:[si+319]
                sub al,1
                jnz b8
                inc bl  
              b8:
                pop ds 
                mov neighbor_count,bl     
            } 
   
            //check if blue
            if((pixel==1)&&((neighbor_count<2)||(neighbor_count>3)))
                *pNextCellMap=0;    
                     
            //check if black
            if((pixel==0)&&(neighbor_count==3))
                *pNextCellMap=1; 
            pCurrentCellMap++;
            pNextCellMap++;
            //if it's not blue or black it stays the same    
        }  
        pNextCellMap=NextCellMap;
        pCurrentCellMap=CurrentCellMap;
        
        _fmemcpy(pVgaBuffer,pNextCellMap,CELL_MAP_LENGTH); 
        _fmemcpy(pCurrentCellMap,pNextCellMap,CELL_MAP_LENGTH); 
        
        //output generation info       
        generation++;
        _ltoa(generation,pgeneration,10);
        _settextposition(0,13);  
        _outtext(pgeneration);    
    } 
    //output elapsed time
    time(pend);
    totaltime=*pend-*pstart;
    pchartotaltime=_ecvt(totaltime,3,&decimal,&sign);
    _settextposition(0,23);
    _outtext(pchartotaltime);   
    _outtext(" seconds");

    getchar();
    
    //change back to text mode and exit
    _setvideomode(_TEXTC80);
    return 0;   
}