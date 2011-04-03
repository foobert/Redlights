#include "life.h"

Life life(8, 8);

const int row[8] = { 4, 3, 2, A1, A2, A3, A4, A5 };
const int col[8] = { 5, 6, 7, 12, 8, 9, 10, 11 };

int pixels[8][8];

void setup() {
  Serial.begin(9600); 
   
  for (int i = 0; i < 8; i++) {
    pinMode(row[i], OUTPUT);
    digitalWrite(row[i], LOW);
  }
  for (int i = 0; i < 8; i++) {
    pinMode(col[i], OUTPUT);
    digitalWrite(col[i], HIGH);
  }
  
  for (int i = 0; i < 8; i++) {
    for (int j = 0; j < 8; j++) {
      pixels[j][i] = 1;
    }
    refresh();
    delay(10);
  }
  
  for (int i = 0; i < 10; i++) {
    refresh();
    delay(10);
  }
  
  for (int i = 0; i < 8; i++) {
    for (int j = 0; j < 8; j++) {
      pixels[j][i] = 0;
    }
    refresh();
    delay(10);
  }
}

int loopCount = 0;
long previousMillis = 0;

char mode = 'l';
int errorMode = 0;

void loop() {
  
  long currentMillis = millis();
  long diff = (currentMillis - previousMillis);

  if (Serial.available() > 0) {
    char c = Serial.read();
    
    switch (c) {
      case '1':
      case '2':
        mode = c;
        break;
      case 'l':
      default:
        mode = 'l';
        break;
    }
  }
  
  switch (mode) {
    case 'l':
      runLife(diff);
      break;
    default:
      runError(diff);
      break;
  }
  
  refresh();
}

void runLife(long diff) {
  if (diff > 500 || loopCount > 50) {
    if (!life.step()) {
      life.seed();
      loopCount = 0;
    }
    
    int r = 0;
    int c = 0;
    int p = 0;
    int* s = life.getState();
    for (int c = 0; c < 8; c++) {
      for (int r = 0; r < 8; r++) {
        pixels[c][r] = s[p++];
      }
    }

    loopCount++;
    previousMillis = millis();
  }
}

void runError(long diff) {
  if (diff < 500)
    return;
  
  clear();  

    for (int i = 0; i < 8; i++) {
      pixels[0][i] = 1;
      pixels[i][0] = 1;
      pixels[7][i] = 1;
      pixels[i][7] = 1;
    }

  if (errorMode == 0) {
    for (int i = 0; i < 8; i++) {
      pixels[i][i] = 1;
      pixels[7-i][i] = 1;
    }
    errorMode = 1;
  } else {
    errorMode = 0;
  }
  previousMillis = millis();
}

void clear() {
  for (int i = 0; i < 8; i++) {
    for (int j = 0; j < 8; j++) {
      pixels[i][j] = 0;
    }
  }
}

void refresh() {
  
  for (int r = 0; r < 8; r++) {
    digitalWrite(row[r], HIGH);
    for (int c = 0; c < 8; c++) {
      digitalWrite(col[c], pixels[c][r] ? LOW : HIGH);
    }
    delay(2);
    digitalWrite(row[r], LOW);
  }
}
