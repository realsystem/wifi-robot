/*****************************************************

Project : Robot
Version : 0.0.1
Date    :
Author  : RealSystem
Comments: Based on http://avr123.nm.ru


Chip type               : ATmega8
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*****************************************************/

#include "control_1.h"

// Константы !  строки в памяти программ
flash char motd[]="System started\n\rReady for work\n\r";
//flash char err_low_volt[]="\n\rError: Low voltage, chargering needs: ";
flash char err_dev_num[]="\n\rError: Invalid device number: ";
flash char err_dev_val[]="\n\rError: Invalid device value: ";
flash char err_dev_max_val[]="\n\rError: Device value is out of range: ";
flash char err_dev_mot_cmd[]="\n\rError: Invalid command for the device motor: ";
flash char err_dev_serv_cmd[]="\n\rError: Invalid command for the device servo: ";
flash char mystring[] = "test";

//USART vars
u8 rx_buffer[RX_BUFFER_SIZE];

#if RX_BUFFER_SIZE<256
    u8 rx_wr_index,rx_rd_index,rx_counter;
#else
    u16 rx_wr_index,rx_rd_index,rx_counter;
#endif

// This flag is set on USART Receiver buffer overflow
bit rx_buffer_overflow;

//MMC_SD vars
u8 sector[512];

//motor and servo vars
u8 dev_val[DEV_COUNT]={0,127};
//input dev type(ascii)
u8 dev_type;
//0-motor
//1-servo
u8 dev_num = 0, motor_cmd, servo_cmd;
//u8 pwm = 0; // Величина ШИМ начальная PWM в %
s8 direction = 0;
u8 ret; // переменная для разных нужд
//u32 pwm_val; // для хранения величины ШИМ PWM в  1/1024
u8 servo_poz = 127;
u8 index_st = 0; //  индекс для работы в прерывании
flash char pb_state[2]={
0b00000001,  // "1" на servo на PB0
0b00000000 };// "0" на всех servo

u16  ctr_last  = 20000;
// сколько мкС осталось досчитать до 20 мС

u8 timer0_int_cnt;
//счетчик переполнений Таймера0

u8 timer0_pause_cnt;
//счетчик пауз

//Robot logic

u8 p[7][7] =
{
    {14,	43,	    57,	    71,	    86,	    93,	    100},
    {7,	    43,	    71,	    100,	100,	100,	100},
    {7,	    50,	    93,	    100,	100,	100,	100},
    {7,	    50,	    57,	    100,	100,	100,	100},
    {29,	29,	    29,	    29,	    57,	    79,	    100},
    {36,	36,	    36,	    36,	    71,	    93,	    100},
    {36,	36,	    36,	    36,	    71,	    79,	    100},
};

u8 cur_move;

enum {STOP, F, FR, FL, B, BR, BL};


// RC5 vars
u8 RC5flg;
u8 RC5err;
u8 RC5num;
u8 RC5cnt;
u8 RC5wrk;
u8 RC5prg;

u16 RC5inp;
u16 RC5old;
u16 RC5rcv;
u16 RC5tmp;

u8 RC5cnt0a;
u8 RC5cnt1a;
u8 RC5cnt0b;
u8 RC5cnt1b;


//++++++++++++++++++++++++++++++++++++++++++++++++

//FUNCTIONS


//SPI init
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
    MMC_Enable();    // set chip select to low (MMC is selected)
}

//timers init function
void timer_init(void)
{
// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 7,813 kHz
TCCR0=0x02;
TCNT0=0xF4;

//timer1 for servo

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 1000,000 kHz
// Mode: Normal top=FFFFh
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer 1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: On
// Compare B Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x02;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1A=1496;
OCR1BH=0x00;
OCR1BL=0x00;

//timer1 for motor - not use

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 8000,000 kHz
// Mode: Fast PWM top=03FFh
// OC1A output: Non-Inv.
// OC1B output: Non-Inv.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer 1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
//TCCR1A=0xA3;
//TCCR1B=0x09;//9

/*
настройка таймера_1
TCCR1A=0xA3; // 1010 0011

описание этого регистра на стр. 109 ДШ.
Биты_7_6 влияют на  ШИМ на ножке PD5
Биты_5_4 влияют на  ШИМ на ножке PD4
Как влияют написано в таблице 45 ДШ

Биты_1_0  совместно  с  битами_5_4
регистра  TCCR1B  определяют
режим работы ШИМ по таблице  47

У нас так :
TCCR1B=0x09; // 0000 1001

значит комбинация 4-х битов определяющая режим ШИМ такова:   0111
по таблице 47 это режим 7  - как мы и заказывали мастеру !

Биты_2_0  регистра  TCCR1B  определяют коэф. деления источника
тактового сигнала прежде чем он будет тикать таймер_1

У нас это 001  по таблице 48  коэф. деления  1   - т.е. таймер_1
считает с частотой кварца.
*/

//TCNT1H=0x00;
//TCNT1L=0x00;
//ICR1H=0x00;
//ICR1L=0x00;

// +++++++++++++++++++++++++++++++++++++++++++++++
// установить величину ШИМ на PB1
//OCR1AH=0x00;
//OCR1AL=0x00;

// +++++++++++++++++++++++++++++++++++++++++++++++
// установить величину ШИМ на PB2
//OCR1BH=0x00;
//OCR1BL=0x00;

/*     величина ШИМ в процентах равна частному от
   деления числа в 16-битном регистре OCR1xx  на 10.23  */
   // Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: 8000,000 kHz
// Mode: Fast PWM top=FFh
// OC2 output: Non-Inverted PWM
ASSR=0x00;
TCCR2=0x69;
TCNT2=0x00;
OCR2=0x00;
}

//init function
void init(void)
{
// Input/Output Ports initialization
PORTB=0x00;
DDRB=0x0F;

PORTC=0x00;
DDRC=0x1F;

// Port D initialization
PORTD=0x00;
DDRD=0x00;

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud rate: 38400
UCSRA=0x00;
UCSRB=0x98;
UCSRC=0x86;
UBRRH=0x00;
UBRRL=0x0C;


// External Interrupt(s) initialization
// INT0: On
// INT0 Mode: Any change
// INT1: On
// INT1 Mode: Any change
GICR|=0xC0;
MCUCR=0x05;
GIFR=0xC0;

/*
// External Interrupt(s) initialization
// INT0: On
// INT0 Mode: Falling Edge
// INT1: On
// INT1 Mode: Falling Edge
GICR|=0xC0;
MCUCR=0x0A;
GIFR=0xC0;
*/

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x11;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// Global enable interrupts
#asm("sei")
}



// Новая Функция getchar()
#ifndef _printf_TERMINAL_IO_
// Get a character from the USART Receiver buffer
#define _ALTERNATE_GETCHAR_

#pragma used+
u8 getchar(void)
{
    u8 data;

    while (rx_counter==0);
    data=rx_buffer[rx_rd_index];
    if (++rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
    #asm("cli")
    --rx_counter;
    #asm("sei")

    return data;
}
#pragma used-

#endif

void fillbuf(u8 *buf)     { // fill buffer sector with ASCII characters
    u16 i, c = 0;

    printf("fill buf\n\r");
    for (i=0; i<=512; i++) {
        buf[i] = mystring[c];
        c++;
        if (c > 4) { c = 0; }
    }
}


void output_buf(u8 *buf, u8 num, u8 type)
{   //type=1 if char, type=0 if digit
    u8 i;

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

/*
//function for changing pwm
void change_pwm(char new_pwm)
{
if (new_pwm > 102)
{ //если ШИМ уже более 100 %
     new_pwm = 0;  // обнулить величину ШИМ
};

pwm_val = ((1023 * (u32)new_pwm)/100);
// перевели % в 1024-е доли
// Вывод нового значение ШИМ в %  в USART
//printf("PWM");

// вывод в USART значения переменной pwm (число от 0 до 100)

// вывод числа сотен

temp = new_pwm/100;
// целочисленное деление на 100 даст
// нам число сотен в числе pwm

if (temp)
{   // если temp содержит не ноль, то нужно печатать количество сотен
    //putchar(temp+48);
}

temp = new_pwm%100;

// вывод числа десятков
//putchar((temp/10) + 48);

temp = temp%10;

// вывод единиц
//putchar(temp+48);

// вывести в USART пробел и знак "проценты"
//printf(" %\n\r");

// pwm_val - это число от 0 до 1023
// PWM(PB1) = OCR1A / 10.23  (%)
OCR1AH = (char)(pwm_val>>8);
OCR1AL = (char)pwm_val;

}*/

void accel(void)
{
    printf("accel\n\r");
    PORTC SET_B(0);
    PORTC CLR_B(1);
    while (dev_val[0] != MAX_PWM)
    {
        dev_val[0]++;
        OCR2 = dev_val[0];
        delay_us(ACCEL_DELAY);//FIXME
    }
}

void brake(void)
{
    printf("brake\n\r");
    while (dev_val[0] != MIN_PWM)
    {
        dev_val[0]--;
        OCR2 = dev_val[0];
        delay_us(BRAKE_DELAY);//FIXME
    }
    PORTC CLR_B(0);
    PORTC CLR_B(1);
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

void servo_steer(u8 poz, u8 step)
{
    u8 i;

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

//function for reverse
void reverse(void)
{
    printf("reverse\n\r");
    if (direction == 1)
    {
        PORTC SET_B(0);
        delay_us(REVERSE_DELAY);
        PORTC CLR_B(1);
        direction = 0;
    }
    else
    {
        PORTC SET_B(1);
        delay_us(REVERSE_DELAY);
        PORTC CLR_B(0);
        direction = 1;
    }
}

//functions for Robot's logic


void go(u8 direction)
{
    switch (direction)
    {
        case STOP:
            printf("cmd: stop\n\r");
            brake();
            break;

        case F:
            printf("cmd: forward\n\r");
            servo_steer(SERVO_FORWARD, 10);
            accel();
            break;

        case FR:
            printf("cmd: forward-right\n\r");
            servo_steer(SERVO_RIGHT, 10);
            accel();
            break;

        case FL:
            printf("cmd: forward-left\n\r");
            servo_steer(SERVO_LEFT, 10);
            accel();
            break;

        case B:
            printf("cmd: backward\n\r");
            brake();
            reverse();
            servo_steer(SERVO_FORWARD, 10);
            accel();
            break;

        case BR:
            printf("cmd: backward-right\n\r");
            brake();
            reverse();
            servo_steer(SERVO_RIGHT, 10);
            accel();
            break;

        case BL:
            printf("cmd: backward-left\n\r");
            brake();
            reverse();
            servo_steer(SERVO_LEFT, 10);
            accel();
            break;
    }
}


u8 next_move(void)
{
   u8 pp, i;

   pp = rand();
   for (i = 0; i < 7; i++)
   {
      if (p[cur_move][i] > pp) break;
   }
   cur_move = i;

   return(i);
}

u8 walk(void)
{
   //while((bit_is_set(IN, LIGHT_R)) && (bit_is_set(IN, LIGHT_L)))
   {
       go(next_move());
       delay_ms(2500);
   }

   return(0);
}

/*
//function for testing motor and servo
void test_prog1(void)
{
    servo_poz = 127;
    accel();
    servo_poz = 0;
    delay_ms(400);
    servo_poz = 254;
    delay_ms(500);
    servo_poz = 127;
    delay_ms(400);
    brake();
    reverse();
    accel();
    servo_poz = 0;
    delay_ms(400);
    servo_poz = 254;
    delay_ms(500);
    servo_poz = 127;
    delay_ms(400);
    brake();
}

//function for testing motor and servo
void test_prog2(void)
{
    int i;

    accel();
    delay_ms(100);
    for (i = 127; i >= 0; i-=5)
    {
        servo_poz = i;
        delay_ms(10);
    }
    delay_ms(100);
    brake();
    delay_ms(10);
    reverse();
    accel();
    for (i = 0; i <= 254; i+=5)
    {
        servo_poz = i;
        delay_ms(10);
    }
    for (i = 254; i >= 127; i-=5)
    {
        servo_poz = i;
        delay_ms(10);
    }
    brake();
    delay_ms(10);
    reverse();
}

//function for testing motor and servo
void test_prog3(void)
{
    servo_poz = 127;
    accel();
    delay_ms(2000);
    brake();
    delay_ms(10);
    reverse();
}*/

//get value from the end of input command
//count is a count of the digits, for example: for 100 we should use count=3
//return value if it is OK (0-254)
//return -1 if error
int get_val(int count)
{
    int tmp_chr, i, tmp_val = 0;

    for (i=count-1;i>=0;i--)
    {
        //get char and convert it from the ascii to the number
        tmp_chr = getchar() - 48;
        //is it digit?
        if ((tmp_chr > 9) && (tmp_chr < 0))
        {
            printf(err_dev_val);
            printf("%d\n\r", tmp_chr);
        }
        else
        {
            tmp_val += tmp_chr * power(10,i);
            //printf("\n\ri=%d, tmp_chr=%d, tmp_val=%d\n\r", i, tmp_chr, tmp_val);
        }
    }
    //check value
    if (tmp_val > MAX_VAL)
    {
        printf(err_dev_max_val);
        printf("%d\n\r", tmp_val);
        return -1;
    }
    else return tmp_val;
}

//usart buffers polling, get command and analyse
int usart_buf_poll(void)
{
    if (getchar()== COMMAND)
    {
        printf("\n\rCOMMAND\n\r");
        dev_type = getchar();
        switch (dev_type)
        {
            case MOTOR:
            {
                printf("\n\rMOTOR\n\r");
                dev_num = 0;
                motor_cmd = getchar();
                switch (motor_cmd)
                {
                    case ACCEL:
                    {
                        printf("\n\rACCEL\n\r");
                        accel();
                        break;
                    }
                    case BRAKE:
                    {
                        printf("\n\rBRAKE\n\r");
                        brake();
                        break;
                    }
                    case REVERSE:
                    {
                        printf("\n\rREVERSE\n\r");
                        reverse();
                        break;
                    }
                    case POWER:
                    {
                        printf("\n\rPOWER\n\r");
                        //get power value
                        ret = get_val(3);
                        if (ret != -1)
                        {
                            dev_val[dev_num] = ret;
                            printf("\n\rValue: %d\n\r", dev_val[dev_num]);
                            //change motor power
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
            case SERVO:
            {
                printf("\n\rSERVO\n\r");
                dev_num = 1;
                servo_cmd = getchar();
                switch (servo_cmd)
                {
                    case ANGLE:
                    {
                        printf("\n\rANGLE\n\r");
                        //get angle value
                        ret = get_val(3);
                        if (ret != -1)
                        {
                            dev_val[dev_num] = ret;
                            printf("\n\rValue: %d\n\r", dev_val[dev_num]);
                            //change angle
                            servo_poz = dev_val[dev_num];
                        }
                        break;
                    }
                    case TEST:
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

//INTERRUPTS

// Timer 1 output compare A interrupt service routine
interrupt [TIM1_COMPA] void timer1_compa_isr(void)
{
    TCNT1H = 0x00; // обнулить счет таймера
    TCNT1L = 0x00;
    // Вывести в PORTB новое состояние
    PORTB = pb_state[index_st];

    if (index_st == 1)
    {
        // прерываться после отсчёта остатка времени
        OCR1A = ctr_last;

        // обновить остаток времени на 20 мС
        ctr_last = 20000;

        // обнулить индекс
        index_st = 0;
    }
    else
    {
        // Вычислить длину имп. для сервы и вписать в OCR1A
        OCR1A=988+(((unsigned int)servo_poz)<<2);
        /* тут servo_poz умножается на 4 сдвигом в лево на 2 бита и затем плюсуется к 988.
        Пример - среднее положение сервы это команда 127, умножим на 4 будет 508, прибавим 988 -
        получим 1496 мкС - это и есть длина импульса для среднего положения вала servo.  */

        // Вычесть длину имп. сервы из периода в 20 мС
        ctr_last -= OCR1A ;

        // увеличить индекс на 1
        index_st ++ ;
    };
}

// Функция обработчик прерывания 12 - завершение приема символа в USART
// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)
{
    char status,data;
    status=UCSRA;
    data=UDR;
    if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
    {
        rx_buffer[rx_wr_index]=data;
        if (++rx_wr_index == RX_BUFFER_SIZE)
        {
            rx_wr_index=0;
        };
        if (++rx_counter == RX_BUFFER_SIZE)
        {
            rx_counter=0;
            rx_buffer_overflow=1;
        };
    };
}

// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
    TCNT0 = 0xF4;
    if (timer0_int_cnt < 20) PORTC INV_B(3);
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

// External Interrupt 0 service routine
interrupt [EXT_INT0] void ext_int0_isr(void)
{
    /*if(cur_move == BR) go(FL);
    if(cur_move == BL) go(FR);
    else go(F);
    //delay_ms(2500);
    cur_move = F;*/
}

// External Interrupt 1 service routine
interrupt [EXT_INT1] void ext_int1_isr(void)
{
    /*if(cur_move == FR) go(BL);
    if(cur_move == FL) go(BR);
    else go(B);
    //delay_ms(2500);
    cur_move = B;*/
    /*if(!RC5flg)
    {
       RC5flg++;
       RC5cnt = 0;
       RC5rcv = 0;
       RC5num = 0;
       RC5err = 0;
    }*/
    if (PIND.3) printf("1\n\r");
    else printf("0\n\r");
}
/*
void RC5AskBit(void)
{
    u8 a;
    u8 b;

    if(++RC5num < 14)
    {
        if(abs(RC5cnt1a-RC5cnt0a) < 2) RC5err++;
        if(abs(RC5cnt1b-RC5cnt0b) < 2) RC5err++;

        a = (RC5cnt1a > RC5cnt0a)? 1:0;
        b = (RC5cnt1b > RC5cnt0b)? 1:0;

        if(a == b) RC5err++;

	    RC5rcv <<= 1;
	    RC5rcv |= (a > b)? 1:0;
    }
    else
    {
	    if(RC5num > 14)
	    {
	        if(!RC5err && RC5rcv & 0x1000)
	        {
	            RC5inp =  RC5rcv;
	        }
	        RC5flg = 0;
	    }
    }
    RC5cnt1a = 0;
    RC5cnt0a = 0;
    RC5cnt1b = 0;
    RC5cnt0b = 0;
    return;
}

u8 RC5corrector(u8 i)
{
    static char corrector[12]={26,26,25,26,
			     26,26,25,26,
			     26,26,25,26};

    return((i > 11)? 26:corrector[i]);
}

void RC5receiver(void)
{
    if(RC5flg)
    {
	    if(RC5cnt > 13)
	    {
	        if(PIND.3)
	        {
		        RC5cnt0b++;
	        }
	        else RC5cnt1b++;
	    }
	    else
	    {
	        if(PIND.3)
	        {
		        RC5cnt0a++;
	        }
	        else RC5cnt1a++;
	    }
	    if(RC5cnt++ > RC5corrector(RC5num))
	    {
	        RC5cnt = 0;
	        RC5AskBit();
	    }
    }
    return;
}
*/
void main(void)
{
    u8 i, ar[50], res, zero_count, steer_angle;
    //bit y;

    //Initialization
    init();
    // Start
    printf(motd);
    /*
    //working with MMC or SD flash card
    spi_init();
	printf("MMC init\n\r");
	res = MMC_Init();
    printf("MMC init res = %d\n\r", res);
    if (res == 1)
    {
    //mmc_read_csd(sector);
    //output_buf(sector, 16, 0);

    mmc_read_cid(sector);
    output_buf(sector, 16, 1);

	fillbuf(sector);
    output_buf(sector, 128, 1);

    mmc_write_sector(0, sector);

    mmc_read_sector(0, sector);
    output_buf(sector, 128, 1);
    }*/
    //normal work
    timer_init();
    //test all systems
    /*accel();
    servo_steer(0, 1);
    servo_steer(254, 1);
    servo_steer(127, 1);
    brake();*/
    while (1)
    {     
        /*RC5receiver();
        delay_us(64);
        printf("RC5flg=%d, RC5cnt=%d, RC5rcv=%d, RC5num=%d, RC5err=%d\n\r", RC5flg, RC5cnt, RC5rcv, RC5num, RC5err);*/
        /*printf("rc: ");  
        for (i = 0; i < 20; i++)
        {
            printf("%d", rc[i]);
        }
        printf("\n\r");
        delay_ms(300);*/
        //walk();
        usart_buf_poll();
    }
}