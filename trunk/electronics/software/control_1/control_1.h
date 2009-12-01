#include <mega8.h>
#include <m8_128.h>
#include <delay.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <spi.h>


//USART status
#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<OVR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)

// USART Receiver buffer
#define RX_BUFFER_SIZE 100

//main dev's defines
#define DEV_COUNT 2
#define MAX_VAL 0xFE

//main commands
#define COMMAND 99
#define MOTOR 109
#define SERVO 115

//commands for motor
#define ACCEL 97
#define BRAKE 98
#define REVERSE 114
#define POWER 112

//commands for servo
#define ANGLE 97
#define TEST 116

#define SET_B(x) |= (1<<x)
#define CLR_B(x) &=~(1<<x)
#define INV_B(x) ^=(1<<x)

//PWM defines
#define MIN_PWM 0x00
#define MAX_PWM 0xFE

//SERVO defines
#define MIN_SERVO_VAL 0x00
#define MID_SERVO_VAL 0x7F
#define MAX_SERVO_VAL 0xFE
#define SERVO_RIGHT 0
#define SERVO_LEFT 254
#define SERVO_FORWARD 127

#define KOEF_MOTOR MAX_PWM/MAX_SERVO_VAL

//delays
#define ACCEL_DELAY 10
#define BRAKE_DELAY 10

#define RUN_TIME 500
#define REVERSE_DELAY 100


//SPI

#define SPIDI    3    // Port B bit 6 (pin7): data in (data from MMC)
#define SPIDO    4    // Port B bit 5 (pin6): data out (data to MMC)
#define SPICLK    5    // Port B bit 7 (pin8): clock
#define SPICS    2    // Port B bit 4 (pin5: chip select for MMC

//MMC_SD

//set MMC_Chip_Select to high (MMC/SD-Karte Inaktiv)
#define MMC_Disable() PORTB |= (1 << SPICS);

//set MMC_Chip_Select to low (MMC/SD-Karte Aktiv)
#define MMC_Enable() PORTB &= ~(1 << SPICS);

extern int MMC_Init(void);
extern u8 mmc_write_sector (u32 addr, u8 *Buffer);
extern u8 mmc_read_sector (u32 addr, u8 *Buffer);
extern u8 mmc_read_cid (u8 *Buffer);
extern u8 mmc_read_csd (u8 *Buffer);
