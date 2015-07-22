;RCC寄存器地址映像
RCC_BASE                EQU             0x40023800
RCC_CFGRLL              EQU             (RCC_BASE + 0x00)
RCC_CFGReg              EQU             (RCC_BASE + 0x04)
RCC_CIReg               EQU             (RCC_BASE + 0x08)
RCC_APB2RSTR            EQU             (RCC_BASE + 0x0C)
RCC_APB1RSTR            EQU             (RCC_BASE + 0x10)
RCC_AHBENR              EQU             (RCC_BASE + 0x14)
RCC_APB2ENR             EQU             (RCC_BASE + 0x18)
RCC_APB1ENR             EQU             (RCC_BASE + 0x1C)
RCC_BDCR                EQU             (RCC_BASE + 0x20)
RCC_CSR                 EQU             (RCC_BASE + 0x24)

;NVIC寄存器地址映像
NVIC_BASE               EQU             0xE000E000
NVIC_SETEN              EQU             (NVIC_BASE + 0x0010)    ;SETENA寄存器阵列的起始地址
NVIC_IRQPRI             EQU             (NVIC_BASE + 0x0400)    ;中断优先级寄存器阵列的起始地址
NVIC_VECTTBL            EQU             (NVIC_BASE + 0x0D08)    ;向量表偏移寄存器的地址
NVIC_AIRCR              EQU             (NVIC_BASE + 0x0D0C)    ;应用程序中断及复位控制寄存器的地址

SETENA0                 EQU             0xE000E100
SETENA1                 EQU             0xE000E104
;SysTick寄存器地址映像
SysTick_BASE            EQU             0xE000E010 
SYSTICKCSR              EQU             (SysTick_BASE + 0x00);NVIC_ST_CTRL_R
SYSTICKRVR              EQU             (SysTick_BASE + 0x04);NVIC_ST_RELOAD_R
NVIC_ST_CURRENT_R       EQU				(SysTick_BASE + 0x08);NVIC_ST_CTRL_CLK_SRC		
SYS_ST_CTRL_ENABLE   	EQU 			0x00000001  ; Counter mode
NVIC_ST_RELOAD_M     	EQU				0x0002903F  ; Counter load value	
NVIC_ST_CTRL_INTEN    	EQU 			0x00000002  ; Interrupt enable
NVIC_ST_CTRL_CLK_SRC  	EQU				0x00000004  ; Clock Source	
NVIC_ST_CTRL_COUNT      EQU 			0x00010000  ; Count flag
;;FLASH缓冲寄存器地址映像
FLASH_ACR               EQU             0x40022000
;SCB_BASE                EQU             (SCS_BASE + 0x0D00)
;-----------------
;MSP_TOP                 EQU             0x20005000              ;主堆栈起始值
PSP_TOP                 EQU             0x20004E00              ;进程堆栈起始值
BitAlias_BASE           EQU             0x22000000              ;位带别名区起始地址
Flag1                   EQU             0x20000200
b_flas                  EQU             (BitAlias_BASE + (0x200*32) + (0*4))              ;位地址
b_05s                   EQU             (BitAlias_BASE + (0x200*32) + (1*4))              ;位地址
DlyI                    EQU             0x20000204
DlyJ                    EQU             0x20000208
DlyK                    EQU             0x2000020C
SysTim                  EQU             0x20000210
 

;常数定义---------
Bit0                    EQU             0x00000001
Bit1                    EQU             0x00000002
Bit2                    EQU             0x00000004
Bit3                    EQU             0x00000008
Bit4                    EQU             0x00000010
Bit5                    EQU             0x00000020
Bit6                    EQU             0x00000040
Bit7                    EQU             0x00000080
Bit8                    EQU             0x00000100
Bit9                    EQU             0x00000200
Bit10                   EQU             0x00000400
Bit11                   EQU             0x00000800
Bit12                   EQU             0x00001000
Bit13                   EQU             0x00002000
Bit14                   EQU             0x00004000
Bit15                   EQU             0x00008000
Bit16                   EQU             0x00010000
Bit17                   EQU             0x00020000
Bit18                   EQU             0x00040000
Bit19                   EQU             0x00080000
Bit20                   EQU             0x00100000
Bit21                   EQU             0x00200000
Bit22                   EQU             0x00400000
Bit23                   EQU             0x00800000
Bit24                   EQU             0x01000000
Bit25                   EQU             0x02000000
Bit26                   EQU             0x04000000
Bit27                   EQU             0x08000000
Bit28                   EQU             0x10000000
Bit29                   EQU             0x20000000
Bit30                   EQU             0x40000000
Bit31                   EQU             0x80000000


		AREA    |.text|, CODE, READONLY, ALIGN=2
		THUMB
        EXPORT   SysTick_Init
		 
			
;------------SysTick_Init------------
; Initialize SysTick with busy wait running at bus clock.
; Input: none
; Output: none
; Modifies: R0, R1



SysTick_Init
    MOV R2,#0
	MOV R3,#0
	; disable SysTick during setup
    LDR R1, =SYSTICKCSR         ; R1 = &NVIC_ST_CTRL_R [0] ENABEL
    MOV R0, #0                      ; R0 = 0
    STR R0, [R1]                    ; [R1] = R0 = [0] Enable or disable counter
	                                ; [1]   Tickint counting down without exception   
	 ; maximum reload value
    LDR R1, =SYSTICKRVR      		 ; R1 = &NVIC_ST_RELOAD_R
    MOV R0, #21000;      ; R0 = NVIC_ST_RELOAD_M 0xE000E014 <-- 0x00FFFFFF<- tohex->16777215+1 clock pluses [0:23] Fully load [24:31] Reserved
    STR R0, [R1]                    ; [R1] = R0 = NVIC_ST_RELOAD_M
	
	 ; any write to current clears it
    LDR R1, =NVIC_ST_CURRENT_R      ; R1 = &NVIC_ST_CURRENT_R  [31]  NOREF--> refference clock provided 0, set to get no refference clock 
    MOV R0, #0                      ; R0 = 0
    STR R0, [R1]                    ; [R1] = R0 = 0
    ; enable SysTick with core clock
    LDR R1, =SYSTICKCSR         ; R1 = &NVIC_ST_CTRL_R
                                    ; R0 = ENABLE and CLK_SRC bits set
    MOV R0, #(SYS_ST_CTRL_ENABLE+NVIC_ST_CTRL_CLK_SRC);NVIC_ST_CTRL_INTEN
    STR R0, [R1]                    ; [R1] = R0 = (NVIC_ST_CTRL_ENABLE|NVIC_ST_CTRL_CLK_SRC) 0x00000001 |  0x00000004 first bit and second bit
                                     ; Counter enable 1 and counting down with exception  
Thetime
    ldr r0,=PSP_TOP 
	msr psp,r0
	mov             r0,#3
	msr             control,r0
    mov             r1,#0
    ldr             r0,=Flag1
    str             r1,[r0]
    ldr             r0,=DlyI
    str             r1,[r0]
    ldr             r0,=DlyJ
    str             r1,[r0]
    ldr             r0,=DlyK
    str             r1,[r0]
    ldr             r0,=SysTim
    str             r1,[r0]    
	
SysTick_Handler
	 ldr             r0,=SysTim
	 ldr             r1,[r0]
	 add             r1,#1
	 str             r1,[r0]
	 cmp             r1,#500
	 bcc             TickExit
	 mov             r1,#0
	 str             r1,[r0]
	 ldr             r0,=b_05s               ;位带操作置1
	 mov             r1,#1
	 str             r1,[r0]
TickExit
  
	BX LR
	ALIGN                           
    END                             ; 









