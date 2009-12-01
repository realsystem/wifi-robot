
#pragma used+
sfrb TWBR=0;
sfrb TWSR=1;
sfrb TWAR=2;
sfrb TWDR=3;
sfrb ADCL=4;
sfrb ADCH=5;
sfrw ADCW=4;      
sfrb ADCSRA=6;
sfrb ADMUX=7;
sfrb ACSR=8;
sfrb UBRRL=9;
sfrb UCSRB=0xa;
sfrb UCSRA=0xb;
sfrb UDR=0xc;
sfrb SPCR=0xd;
sfrb SPSR=0xe;
sfrb SPDR=0xf;
sfrb PIND=0x10;
sfrb DDRD=0x11;
sfrb PORTD=0x12;
sfrb PINC=0x13;
sfrb DDRC=0x14;
sfrb PORTC=0x15;
sfrb PINB=0x16;
sfrb DDRB=0x17;
sfrb PORTB=0x18;
sfrb EECR=0x1c;
sfrb EEDR=0x1d;
sfrb EEARL=0x1e;
sfrb EEARH=0x1f;
sfrw EEAR=0x1e;   
sfrb UBRRH=0x20;
sfrb UCSRC=0X20;
sfrb WDTCR=0x21;
sfrb ASSR=0x22;
sfrb OCR2=0x23;
sfrb TCNT2=0x24;
sfrb TCCR2=0x25;
sfrb ICR1L=0x26;
sfrb ICR1H=0x27;
sfrw ICR1=0x26;   
sfrb OCR1BL=0x28;
sfrb OCR1BH=0x29;
sfrw OCR1B=0x28;  
sfrb OCR1AL=0x2a;
sfrb OCR1AH=0x2b;
sfrw OCR1A=0x2a;  
sfrb TCNT1L=0x2c;
sfrb TCNT1H=0x2d;
sfrw TCNT1=0x2c;  
sfrb TCCR1B=0x2e;
sfrb TCCR1A=0x2f;
sfrb SFIOR=0x30;
sfrb OSCCAL=0x31;
sfrb TCNT0=0x32;
sfrb TCCR0=0x33;
sfrb MCUCSR=0x34;
sfrb MCUCR=0x35;
sfrb TWCR=0x36;
sfrb SPMCR=0x37;
sfrb TIFR=0x38;
sfrb TIMSK=0x39;
sfrb GIFR=0x3a;
sfrb GICR=0x3b;
sfrb SPL=0x3d;
sfrb SPH=0x3e;
sfrb SREG=0x3f;
#pragma used-

#asm
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
#endasm

#pragma used+

void delay_us(unsigned int n);
void delay_ms(unsigned int n);

#pragma used-

typedef char *va_list;

#pragma used+

char getchar(void);
void putchar(char c);
void puts(char *str);
void putsf(char flash *str);

char *gets(char *str,unsigned int len);

void printf(char flash *fmtstr,...);
void sprintf(char *str, char flash *fmtstr,...);
void snprintf(char *str, unsigned int size, char flash *fmtstr,...);
void vprintf (char flash * fmtstr, va_list argptr);
void vsprintf (char *str, char flash * fmtstr, va_list argptr);
void vsnprintf (char *str, unsigned int size, char flash * fmtstr, va_list argptr);
signed char scanf(char flash *fmtstr,...);
signed char sscanf(char *str, char flash *fmtstr,...);

#pragma used-

#pragma library stdio.lib

#pragma used+

unsigned char cabs(signed char x);
unsigned int abs(int x);
unsigned long labs(long x);
float fabs(float x);
int atoi(char *str);
long int atol(char *str);
float atof(char *str);
void itoa(int n,char *str);
void ltoa(long int n,char *str);
void ftoa(float n,unsigned char decimals,char *str);
void ftoe(float n,unsigned char decimals,char *str);
void srand(int seed);
int rand(void);
void *malloc(unsigned int size);
void *calloc(unsigned int num, unsigned int size);
void *realloc(void *ptr, unsigned int size); 
void free(void *ptr);

#pragma used-
#pragma library stdlib.lib

#pragma used+

char *strcat(char *str1,char *str2);
char *strcatf(char *str1,char flash *str2);
char *strchr(char *str,char c);
signed char strcmp(char *str1,char *str2);
signed char strcmpf(char *str1,char flash *str2);
char *strcpy(char *dest,char *src);
char *strcpyf(char *dest,char flash *src);
unsigned int strlenf(char flash *str);
char *strncat(char *str1,char *str2,unsigned char n);
char *strncatf(char *str1,char flash *str2,unsigned char n);
signed char strncmp(char *str1,char *str2,unsigned char n);
signed char strncmpf(char *str1,char flash *str2,unsigned char n);
char *strncpy(char *dest,char *src,unsigned char n);
char *strncpyf(char *dest,char flash *src,unsigned char n);
char *strpbrk(char *str,char *set);
char *strpbrkf(char *str,char flash *set);
char *strrchr(char *str,char c);
char *strrpbrk(char *str,char *set);
char *strrpbrkf(char *str,char flash *set);
char *strstr(char *str1,char *str2);
char *strstrf(char *str1,char flash *str2);
char *strtok(char *str1,char flash *str2);

unsigned int strlen(char *str);
void *memccpy(void *dest,void *src,char c,unsigned n);
void *memchr(void *buf,unsigned char c,unsigned n);
signed char memcmp(void *buf1,void *buf2,unsigned n);
signed char memcmpf(void *buf1,void flash *buf2,unsigned n);
void *memcpy(void *dest,void *src,unsigned n);
void *memcpyf(void *dest,void flash *src,unsigned n);
void *memmove(void *dest,void *src,unsigned n);
void *memset(void *buf,unsigned char c,unsigned n);
unsigned int strcspn(char *str,char *set);
unsigned int strcspnf(char *str,char flash *set);
int strpos(char *str,char c);
int strrpos(char *str,char c);
unsigned int strspn(char *str,char *set);
unsigned int strspnf(char *str,char flash *set);

#pragma used-
#pragma library string.lib

#pragma used+
unsigned char spi(unsigned char data);
#pragma used-

#pragma library spi.lib

extern int MMC_Init(void);
extern unsigned char     mmc_write_sector (unsigned long int	 addr, unsigned char     *Buffer);
extern unsigned char     mmc_read_sector (unsigned long int	 addr, unsigned char     *Buffer);
extern unsigned char     mmc_read_cid (unsigned char     *Buffer);
extern unsigned char     mmc_read_csd (unsigned char     *Buffer);

flash char motd[]="System started\n\rReady for work\n\r";

flash char err_dev_num[]="\n\rError: Invalid device number: ";
flash char err_dev_val[]="\n\rError: Invalid device value: ";
flash char err_dev_max_val[]="\n\rError: Device value is out of range: ";
flash char err_dev_mot_cmd[]="\n\rError: Invalid command for the device motor: ";
flash char err_dev_serv_cmd[]="\n\rError: Invalid command for the device servo: ";
flash char mystring[] = "test";

unsigned char     rx_buffer[100];

unsigned char     rx_wr_index,rx_rd_index,rx_counter;

bit rx_buffer_overflow;

unsigned char     sector[512];

unsigned char     dev_val[2]={0,127};

unsigned char     dev_type;

unsigned char     dev_num = 0, motor_cmd, servo_cmd;

signed char     direction = 0;
unsigned char     ret; 

unsigned char     servo_poz = 127;
unsigned char     index_st = 0; 
flash char pb_state[2]={
0b00000001,  
0b00000000 };

unsigned int      ctr_last  = 20000;

unsigned char     timer0_int_cnt;

unsigned char     timer0_pause_cnt;

unsigned char     p[7][7] =
{
{14,	43,	    57,	    71,	    86,	    93,	    100},
{7,	    43,	    71,	    100,	100,	100,	100},
{7,	    50,	    93,	    100,	100,	100,	100},
{7,	    50,	    57,	    100,	100,	100,	100},
{29,	29,	    29,	    29,	    57,	    79,	    100},
{36,	36,	    36,	    36,	    71,	    93,	    100},
{36,	36,	    36,	    36,	    71,	    79,	    100},
};

unsigned char     cur_move;

enum {STOP, F, FR, FL, B, BR, BL};

unsigned char     RC5flg;
unsigned char     RC5err;
unsigned char     RC5num;
unsigned char     RC5cnt;
unsigned char     RC5wrk;
unsigned char     RC5prg;

unsigned int     RC5inp;
unsigned int     RC5old;
unsigned int     RC5rcv;
unsigned int     RC5tmp;

unsigned char     RC5cnt0a;
unsigned char     RC5cnt1a;
unsigned char     RC5cnt0b;
unsigned char     RC5cnt1b;

void spi_init(void)
{
TCCR0=0x00;
TCNT0=0x00;
TCCR1A=0x00;
TCCR1B=0x00;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1A=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

DDRB = 0x2c;
SPCR = 0x53;
PORTB &= ~(1 << 2    );;    
}

void timer_init(void)
{

TCCR0=0x02;
TCNT0=0xF4;

TCCR1A=0x00;
TCCR1B=0x02;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1A=1496;
OCR1BH=0x00;
OCR1BL=0x00;

ASSR=0x00;
TCCR2=0x69;
TCNT2=0x00;
OCR2=0x00;
}

void init(void)
{

PORTB=0x00;
DDRB=0x0F;

PORTC=0x00;
DDRC=0x1F;

PORTD=0x00;
DDRD=0x00;

UCSRA=0x00;
UCSRB=0x98;
UCSRC=0x86;
UBRRH=0x00;
UBRRL=0x0C;

GICR|=0xC0;
MCUCR=0x05;
GIFR=0xC0;

TIMSK=0x11;

ACSR=0x80;
SFIOR=0x00;

#asm("sei")
}

#pragma used+
unsigned char     getchar(void)
{
unsigned char     data;

while (rx_counter==0);
data=rx_buffer[rx_rd_index];
if (++rx_rd_index == 100) rx_rd_index=0;
#asm("cli")
--rx_counter;
#asm("sei")

return data;
}
#pragma used-

void fillbuf(unsigned char     *buf)     { 
unsigned int     i, c = 0;

printf("fill buf\n\r");
for (i=0; i<=512; i++) {
buf[i] = mystring[c];
c++;
if (c > 4) { c = 0; }
}
}

void output_buf(unsigned char     *buf, unsigned char     num, unsigned char     type)
{   
unsigned char     i;

printf("buf:\n\r");
for (i = 0; i < num; i++)
{
if (type == 1) printf("%c", buf[i]);
else printf("0x%x", buf[i]);
}
printf("\n\r");
}

int power(int t, int k)
{
int res = 1;
while (k)
{
if (k & 1) res *= t;
t *= t;
k >>= 1;
}
return res;
}

void accel(void)
{
printf("accel\n\r");
PORTC |= (1<<0);
PORTC &=~(1<<1);
while (dev_val[0] != 0xFE)
{
dev_val[0]++;
OCR2 = dev_val[0];
delay_us(10);
}
}

void brake(void)
{
printf("brake\n\r");
while (dev_val[0] != 0x00)
{
dev_val[0]--;
OCR2 = dev_val[0];
delay_us(10);
}
PORTC &=~(1<<0);
PORTC &=~(1<<1);
}

void test_servo(void)
{
servo_poz = 0;
delay_ms(500);
servo_poz = 254;
delay_ms(500);
servo_poz = 127;
delay_ms(500);
}

void servo_steer(unsigned char     poz, unsigned char     step)
{
unsigned char     i;

if (servo_poz < poz)
do
{
servo_poz = servo_poz + step;
} while (servo_poz < poz);
else
if (servo_poz > poz)
do
{
servo_poz = servo_poz - step;
} while (servo_poz > poz);
else servo_poz = poz;
printf("servo_steer=%d\n\r", servo_poz);
}

void reverse(void)
{
printf("reverse\n\r");
if (direction == 1)
{
PORTC |= (1<<0);
delay_us(100);
PORTC &=~(1<<1);
direction = 0;
}
else
{
PORTC |= (1<<1);
delay_us(100);
PORTC &=~(1<<0);
direction = 1;
}
}

void go(unsigned char     direction)
{
switch (direction)
{
case STOP:
printf("cmd: stop\n\r");
brake();
break;

case F:
printf("cmd: forward\n\r");
servo_steer(127, 10);
accel();
break;

case FR:
printf("cmd: forward-right\n\r");
servo_steer(0, 10);
accel();
break;

case FL:
printf("cmd: forward-left\n\r");
servo_steer(254, 10);
accel();
break;

case B:
printf("cmd: backward\n\r");
brake();
reverse();
servo_steer(127, 10);
accel();
break;

case BR:
printf("cmd: backward-right\n\r");
brake();
reverse();
servo_steer(0, 10);
accel();
break;

case BL:
printf("cmd: backward-left\n\r");
brake();
reverse();
servo_steer(254, 10);
accel();
break;
}
}

unsigned char     next_move(void)
{
unsigned char     pp, i;

pp = rand();
for (i = 0; i < 7; i++)
{
if (p[cur_move][i] > pp) break;
}
cur_move = i;

return(i);
}

unsigned char     walk(void)
{

{
go(next_move());
delay_ms(2500);
}

return(0);
}

int get_val(int count)
{
int tmp_chr, i, tmp_val = 0;

for (i=count-1;i>=0;i--)
{

tmp_chr = getchar() - 48;

if ((tmp_chr > 9) && (tmp_chr < 0))
{
printf(err_dev_val);
printf("%d\n\r", tmp_chr);
}
else
{
tmp_val += tmp_chr * power(10,i);

}
}

if (tmp_val > 0xFE)
{
printf(err_dev_max_val);
printf("%d\n\r", tmp_val);
return -1;
}
else return tmp_val;
}

int usart_buf_poll(void)
{
if (getchar()== 99)
{
printf("\n\rCOMMAND\n\r");
dev_type = getchar();
switch (dev_type)
{
case 109:
{
printf("\n\rMOTOR\n\r");
dev_num = 0;
motor_cmd = getchar();
switch (motor_cmd)
{
case 97:
{
printf("\n\rACCEL\n\r");
accel();
break;
}
case 98:
{
printf("\n\rBRAKE\n\r");
brake();
break;
}
case 114:
{
printf("\n\rREVERSE\n\r");
reverse();
break;
}
case 112:
{
printf("\n\rPOWER\n\r");

ret = get_val(3);
if (ret != -1)
{
dev_val[dev_num] = ret;
printf("\n\rValue: %d\n\r", dev_val[dev_num]);

OCR2 = dev_val[dev_num];
}
break;
}
default:
{
printf(err_dev_mot_cmd);
printf("%d\n\r", motor_cmd);
return -1;
}
};
break;
}
case 115:
{
printf("\n\rSERVO\n\r");
dev_num = 1;
servo_cmd = getchar();
switch (servo_cmd)
{
case 97:
{
printf("\n\rANGLE\n\r");

ret = get_val(3);
if (ret != -1)
{
dev_val[dev_num] = ret;
printf("\n\rValue: %d\n\r", dev_val[dev_num]);

servo_poz = dev_val[dev_num];
}
break;
}
case 116:
{
printf("\n\rTEST\n\r");
test_servo();
break;
}
default:
{
printf(err_dev_serv_cmd);
printf("%d\n\r", servo_cmd);
return -1;
}
};
break;
}
default:
{
printf(err_dev_num);
printf("%d\n\r", servo_cmd);
return -1;
}
};
};
}

interrupt [7] void timer1_compa_isr(void)
{
TCNT1H = 0x00; 
TCNT1L = 0x00;

PORTB = pb_state[index_st];

if (index_st == 1)
{

OCR1A = ctr_last;

ctr_last = 20000;

index_st = 0;
}
else
{

OCR1A=988+(((unsigned int)servo_poz)<<2);

ctr_last -= OCR1A ;

index_st ++ ;
};
}

interrupt [12] void usart_rx_isr(void)
{
char status,data;
status=UCSRA;
data=UDR;
if ((status & ((1<<4) | (1<<2    ) | (1<<3    )))==0)
{
rx_buffer[rx_wr_index]=data;
if (++rx_wr_index == 100)
{
rx_wr_index=0;
};
if (++rx_counter == 100)
{
rx_counter=0;
rx_buffer_overflow=1;
};
};
}

interrupt [10] void timer0_ovf_isr(void)
{
TCNT0 = 0xF4;
if (timer0_int_cnt < 20) PORTC ^=(1<<3);
if (timer0_int_cnt >= 20)
{
if (timer0_pause_cnt >= 40)
{
timer0_int_cnt = 0;
timer0_pause_cnt = 0;
}
else timer0_pause_cnt++;
}
else
{
timer0_int_cnt++;
}

}

interrupt [2] void ext_int0_isr(void)
{

}

interrupt [3] void ext_int1_isr(void)
{

if (PIND.3) printf("1\n\r");
else printf("0\n\r");
}

void main(void)
{
unsigned char     i, ar[50], res, zero_count, steer_angle;

init();

printf(motd);

timer_init();

while (1)
{     

usart_buf_poll();
}
}
