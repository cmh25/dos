//Cell06.cpp 

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
#include "cmhgrfx.h"
 
#define BMP_FILE_LENGTH 32000
#define CELL_MAP_LENGTH 64000 

int hand;//handle for file       

char FileBuffer[BMP_FILE_LENGTH];
char* pFileBuffer=FileBuffer;//read bmp file into this buffer
                
char CurrentCellMap[CELL_MAP_LENGTH]; 
char* pCurrentCellMap=CurrentCellMap;//same as what is on the screen 

char NextCellMap[CELL_MAP_LENGTH];
char* pNextCellMap=NextCellMap;//the next to be put on the screen  

char ThirdBuffer[CELL_MAP_LENGTH/8];
char* pThirdBuffer=ThirdBuffer;//used to draw screen with rep movsw
 
char pixel;
char abyte;// a byte from FileBuffer has 2 pixels 

int main()
{     
    //set video mode  
    SetMode(0x12);
           
    //put 320 x 190 16 color image(2 bytes/pixel) in FileBuffer
    hand=_open("cell08.bmp",_O_BINARY,_O_RDONLY); 
    _lseek(hand,0x76,SEEK_SET); 
    _read(hand,pFileBuffer,BMP_FILE_LENGTH); 
    _close(hand);
    
    //put modified image(1 byte/pixel) in NextCellMap
    pFileBuffer+=BMP_FILE_LENGTH-160; 
    for(int i=200;i>0;i--)      //do 190 rows
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
    _fmemcpy(pCurrentCellMap,pNextCellMap,CELL_MAP_LENGTH); 
    
    //go through NextCellMap and put neighbor_count in high nibble
    for(i=200;i>0;i--)//do 200 rows
    {
        for(int j=320;j>0;j--)//320 pixels/row
        {
            if((*pCurrentCellMap&0x0f)==0x01)    //if blue
            {
                *(pNextCellMap-1)+=0x10;
                *(pNextCellMap+1)+=0x10;
                *(pNextCellMap-319)+=0x10;
                *(pNextCellMap+319)+=0x10;
                *(pNextCellMap-320)+=0x10;
                *(pNextCellMap+320)+=0x10;
                *(pNextCellMap-321)+=0x10;
                *(pNextCellMap+321)+=0x10;         
            }
            pCurrentCellMap++;
            pNextCellMap++;            
        }
    }
    pNextCellMap=NextCellMap;
    pCurrentCellMap=CurrentCellMap;
   
    _fmemcpy(pCurrentCellMap,pNextCellMap,CELL_MAP_LENGTH); 
          
    //display bitmap
    for(int y=0;y<200;y++)        //this is the slow way, but it's not in the main loop
    {
        for(int x=0;x<320;x++)
        {
            Pixel(x,y,*pCurrentCellMap++);
        }
    } 
    pCurrentCellMap=CurrentCellMap;
                          
    //Set WriteMode 0 
    _asm
    {
        mov dx,3ceh
        mov al,5
        out dx,al
        inc dx
        in al,dx
        and al,not 3
        or al,0 
        out dx,al 
    }                             
    //Set MapMask to 0001b 
    _asm
    {
        mov dx,3c4h
        mov al,2
        mov ah,1
        out dx,ax
    }
   
    getchar();   //allow user to prepare for the unknowable
    
    //////////////////////////////////////////////////////////////////
    //This is the main loop
    //////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////
    while(!kbhit())
    {
        _asm
        {
            push ds
                              
            //Apply rules of life and update neighbor info
            les di,pNextCellMap                              
            lds si,pCurrentCellMap
            dec si
            dec di
            mov cx,64001
          NothingNew:
            dec cx
            jz PreDone
            inc si
            inc di 
            mov al,ds:[si]
            cmp al,00h      
            jz NothingNew   //Black with no neighbors(most)
            push ax
            and al,0fh        
            cmp al,01h
            jz Blue
            cmp al,0fh
            jz White
            //If it's not blue or white, it's black
            pop ax        //Black with neighbors
            and al,0f0h
            cmp al,30h
            jz NewLife
            jmp NothingNew
          Blue:
            pop ax
            and al,0f0h
            cmp al,20h
            jb NewDeath
            cmp al,30h
            ja NewDeath
            jmp NothingNew
          White:  
            pop ax        
            jmp NothingNew
          PreDone:
            jmp Done
          NewLife:
            add es:[di],01h        //Update surrounding neighbor counts
            add es:[di-1],10h   
            add es:[di+1],10h
            add es:[di-319],10h
            add es:[di+319],10h
            add es:[di-320],10h
            add es:[di+320],10h
            add es:[di-321],10h
            add es:[di+321],10h 
            jmp NothingNew
          NewDeath:
            sub es:[di],01h        //Update surrounding neighbor counts
            sub es:[di-1],10h
            sub es:[di+1],10h
            sub es:[di-319],10h
            sub es:[di+319],10h
            sub es:[di-320],10h
            sub es:[di+320],10h
            sub es:[di-321],10h
            sub es:[di+321],10h
            jmp NothingNew
          Done:
            
            //Load ThirdBuffer
            pop ds
            push ds
            les di,pThirdBuffer
            lds si,pNextCellMap
            dec si
            mov al,0
            mov bl,10000000b
            mov cx,8000        //counts down every byte
          Again:
            inc si
            mov ah,ds:[si]
            and ah,0fh
            cmp ah,00h
            jz BlackPix
            //Blue or white pixel
            or al,bl       //if it's not black, it's blue or white
            ror bl,1       //which is the same operation either way
            jc ByteFull
            jmp Again
          BlackPix:
            ror bl,1
            jc ByteFull
            jmp Again
          ByteFull:        //When the byte is full, copy it and advance di
            mov es:[di],al 
            mov al,0
            inc di
            dec cx 
            jz Done1
            jmp Again
          Done1:     
          
            //draw to screen 
            pop ds
            push ds
            mov ax,0a000h
            mov es,ax
            mov di,-40
            lds si, pThirdBuffer
            mov cx,200
          LineLoop:  
            push cx
            add di,40
            mov cx,20
            rep movsw
            pop cx
            dec cx
            jnz LineLoop
                  
            pop ds
        }  
        _fmemcpy(pCurrentCellMap,pNextCellMap,CELL_MAP_LENGTH);                
    }                                                          
    ///////////////////////////////////////////////////////////////////////
    //End of main loop
    ///////////////////////////////////////////////////////////////////////

    //change back to text mode and exit
    SetMode(3);
    return 0;   
}