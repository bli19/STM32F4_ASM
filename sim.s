		IMPORT   PLL_getV	
		IMPORT   SysTick_Init	
 
GPIO_PORTD_Mode    EQU 0x40020C00 ;Moder[0:1] from [31...0] 01 for output  
GPIO_PORTD_PP	   EQU 0x40020C04 ;don;t care for this if using pp unless adjust value for OD 
GPIO_PORTD_Ospeed  EQU 0x40020C08 ;Keep it reset if you wanna low speed 2MHz 
GPIO_PORTD_PUR_R   EQU 0x40020C0C ;Keep it reset if you just wanna No Pull Re
GPIO_PORTD_IDR     EQU 0x40020C10 ;x	 
GPIO_PORTD_ODR     EQU 0x40020C14 ;odr [0:15] i don;t know, this shit never work for me
GPIO_PORTD_BSRR    EQU 0x40020C18 ;BSRR [0:15] for set and[16:31] FOR  reset
GPIO_PORTD_en	   EQU 0x40023830 ;RCC enable: to enable D, the value should [0:7] as 0x08	 
GPIO_PORTD_AMSEL_R EQU 0x40025528
GPIO_PORTD_PCTL_R  EQU 0x4002552C
QUARTERSEC         EQU 1755555      ;you could delay longer if you need that  


        AREA    |.text|, CODE, READONLY, ALIGN=2
        THUMB
        EXPORT  Start
		
Start
    BL  PLL_getV
	BL 	SysTick_Init
    BL  PortD_Init                   
    
loop
	LDR R0, =QUARTERSEC
	BL  delay  
	LDR R1,=GPIO_PORTD_BSRR
	LDR R0, =0x0000F000
	STR R0, [R1]
    BL  delay 	
    LDR R1,=GPIO_PORTD_BSRR
	LDR R0,=0x00000000
	ORR R0,R0,#0xF0000000
	STR R0, [r1]
	NOP
	NOP
    B   loop


PortD_Init
    LDR R1, =GPIO_PORTD_en          
    LDR R0, [R1]                 
    ORR R0, R0, #0x08               
    STR R0, [R1]                  
    NOP
    NOP                              
	LDR R1,=GPIO_PORTD_Mode
	LDR R0, =0x55000000
	STR R0, [R1]	
	NOP
	NOP               
    BX  LR                         

delay
    SUBS R0, R0, #1
    BNE delay
    BX  LR
	
    ALIGN                            
    END  
  
