#include <avr/io.h>
#include <stdint.h>
#include <avr/interrupt.h>

struct uptime_struct {
	uint8_t hour;
	uint8_t minute;
	uint8_t second;
};

static struct uptime_struct uptime;

static uint16_t timerOvfCount = 0;

void uartInit(const uint32_t baudRate) {
	if (baudRate == 57600) {
		UBRR0L = 16;
	}
	UCSR0B |= (1 << TXEN0);
}

void uartSendData(const uint8_t data) {
	while (!(UCSR0A & (1 << UDRE0)))
		;
	UDR0 = data;
}

void uartSendString(uint8_t *s) {
	while (*s != '\0') {
		uartSendData(*s);
		*s++;
	}
}

void timerReload(void) {
	/* 1 interrupt per ms */
	TCNT0 = 5;
}

void timer0Init(void) {
	timerReload();
	TIMSK0 |= (1 << TOIE0);
	TCCR0B |= ((1 << CS01) | (1 << CS00));
}

void uptimeInit(struct uptime_struct *u) {
	u->hour = 0;
	u->minute = 0;
	u->second = 0;
}

void uptimeUpdate(struct uptime_struct *u) {
	if (++u->second < 60) {
		return;
	}
	u->second = 0;
	if (++u->minute < 60) {
		return;
	}
	u->minute = 0;
	u->hour++;
}

void uptimePrint(struct uptime_struct *u) {
	char buffer[11];
	buffer[0] = (u->hour / 10) + '0';
	buffer[1] = (u->hour % 10) + '0';
	buffer[2] = ':';
	buffer[3] = (u->minute / 10) + '0';
	buffer[4] = (u->minute % 10) + '0';
	buffer[5] = ':';
	buffer[6] = (u->second / 10) + '0';
	buffer[7] = (u->second % 10) + '0';
	buffer[8] = '\r';
	buffer[9] = '\n';
	buffer[10] = '\0';
	uartSendString(buffer);
}

int main(void) {
	uartInit(57600);
	uartSendString("Start.\r\n");
	timer0Init();
	sei();

	while (1) 
		;

	return 0;
}

ISR(TIMER0_OVF_vect) {
	timerReload();
	if (++timerOvfCount < 1000) {
		return;
	}
	timerOvfCount = 0;
	uptimeUpdate(&uptime);
	uptimePrint(&uptime);
}
