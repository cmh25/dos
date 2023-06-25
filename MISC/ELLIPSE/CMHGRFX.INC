; --------------------------------------------------------------
;                       cmhgrfx.inc 
;                         10-31-98  
;       
; --------------------------------------------------------------  

;*********************************
; PROTOTYPES
;*********************************
Line            proto far c,xstart:word,ystart:word,xend:word,yend:word,
			    color:byte
Circle          proto far c,xcenter:word,ycenter:word,radius:word,color:byte
Ellipse         proto far c,xcenter:word,ycenter:word,xrad:word,yrad:word,
			    color:byte
SetMode         proto far c,mode:word       
Poly            proto far c,color:byte,argcount:word,vertex:vararg   
Fpoly           proto far c,color:byte,count:word,line_list_ptr:dword,
			    vertex:vararg
Fill            proto far c,address:word,bytecount:word,color:byte
Pixel           proto far c,x:word,y:word,color:byte
PutChar         proto far c,x:word,y:word,character:byte,color:byte
SetSplitScreen  proto far c,scanline:word
SetStartAddr    proto far c,start_addr:byte
	


	

	

							 

	


