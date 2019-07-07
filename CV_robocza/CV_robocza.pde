import processing.pdf.*;

// wszystkie podawane dane mają wymiar podany w [mm]
int A4_width_mm = 210;
int A4_height_mm = 297;

// marginesy [mm]
int marginTop = 10;
int marginLeft = 11;
int marginRight = A4_width_mm - marginLeft;

// tworzenie skali
int pdf_width_px = 735;
int pdf_height_px = (int)(pdf_width_px * sqrt(2));
float s = (float)pdf_width_px / A4_width_mm;

PImage img;

void setup() {
  background(255);
  size(735, 1040);
  noLoop();
  beginRecord(PDF, "EKOLED_CV_HK.pdf");
  
  img = loadImage("pictures/myself_2.bmp");
}

void draw() {

  // Zdjęcie + info
  {
    fill(153);
    noStroke();
    
    fill(0x20, 0x20, 0x20);
    rect(0, 0, width, 280);
    
    float ratio = 0.08;
    //image(img, marginLeft*s, marginTop*s, img.width*ratio*s, img.height*ratio*s);
    
    PFont font = createFont("Arial",12,true);
    textFont(font);
    fill(255);
    textAlign(LEFT, TOP);
    
    float x = marginTop;
    //textSize(10*s);
    //text("Hubert Korgul", 70*s, x*s);
    
    //textSize(4*s);
    //textLeading(7*s);
    //text("E-mail:\n"+
    //     "Telefon:\n"+
    //     "Data urodzenia:\n"+
    //     "Miejscowość:\n", 70*s, (x+=18)*s);
         
    //fill(153);     
    //text("hubert.korgul@gmail.com\n"+
    //     "790 607 956\n"+
    //     "08.04.1992\n"+
    //     "Stary Gózd\n", (50+70)*s, x*s);
  }
  
  // Nagłówki
  {
    // wewnątrz pliku MCU wszystko jest zmniejszane: scale(0.25)
    drawMCU(marginLeft, 75, 8, 86, 22, 12, "", 3, 4*(marginRight-marginLeft)); //<>//
    drawMCU(marginLeft, 135, 12, 135, 22, 12, "", 3, 4*(marginRight-marginLeft));
    drawMCU(marginLeft, 180, 11, 124, 22, 12, "", 3, 4*(marginRight-marginLeft));
    drawMCU(marginLeft, 211, 7, 75, 22, 12, "", 3, 4*(marginRight-marginLeft));
    drawMCU(marginLeft, 240, 6, 64, 22, 12, "", 3, 4*(marginRight-marginLeft));
  }
  
  // Tekst (ta sekcja nie uwzględnia skalowania o 0.25)
  //{
  //  // Doświadczenie zawodowe
  //  PFont font = createFont("Arial",12,true);
  //  textFont(font);
  //  textAlign(LEFT, TOP);
  //  textSize(4.5*s);
  //  fill(0);
    
  //  ellipse(marginLeft*s, (85+16)*s, 1.84*s, 1.84*s);
  //  text("   Monter instalacji telekomunikacyjnych", marginLeft*s, (85+13)*s);
  //  textSize(4*s);
  //  text("06/2015 - 09/2015", 166*s, (85+13)*s);
  //  textSize(4.5*s);
  //  text("   ELMO S.A.", marginLeft*s, (85+20)*s);
  //  textSize(4*s);
  //  text("   Oddział: Grójec", marginLeft*s, (85+27)*s);
  //  text("   Doprowadzanie sieci internetowej do mieszkań, naprawa"+
  //       " uszkodzonych instalacji,\n   konfigurowanie routerów.", marginLeft*s, (85+34)*s);
    
  //  // Wykształcenie
  //  ellipse(marginLeft*s, (135+16)*s, 1.84*s, 1.84*s);
  //  textSize(4.5*s);
  //  text("   Szkoła Główna Gospodarstwa Wiejskiego w Warszawie", marginLeft*s, (135+13)*s);
  //  textSize(4*s);
  //  text("10/2015 - obecnie", 166*s, (135+13)*s);
  //  text("   informatyka", marginLeft*s, (135+20)*s);
  //  text("   Inżynieria systemów komputerowych", marginLeft*s, (135+27)*s);
  //  text("   średnie", marginLeft*s, (135+34)*s);
    
  //  // Umiejętności
  //  text("   Programowanie w języku C, C++, Java, lutowanie SMD, THT, obsługa urządzeń pomiarowych:"+
  //       "\n   oscyloskop, multimetr, sprawne czytanie angielskich not katalogowych", 
  //       marginLeft*s, (180+13)*s);
    
  //  // Hobby
  //  text("   Elektronika - budowa i naprawa drobnych urządzeń elektronicznych, "+
  //       "programowanie mikrokontrolerów, \n   Arduino, "+
  //       "czytanie czasopism o elektronice: EdW, EP", marginLeft*s, (211+13)*s);
    
  //  // Linki
  //  //ellipse(marginLeft*s, (240+15)*s, 1.84*s, 1.84*s);
  //  //text("   Git", marginLeft*s, (240+13)*s);
  //  //text("kilka programów na Arduino       https://github.com/thePLManHubert", 40*s, (240+13)*s);
  //}
  
  //// Zgoda
  //{
  //  textSize(3*s);
  //  fill(102);
  //  text("Wyrażam zgodę na przetwarzanie przez EKO-LED Sp. z o.o. moich danych osobowych, "+
  //       "zawartych w mojej ofercie pracy, dla potrzeb\nniezbędnych do realizacji procesu "+
  //       "rekrutacji zgodnie z ustawą z dnia 29 sierpnia 1997 r. o ochronie danych osobowych\n"+
  //       "(t.j. Dz. U. z 2016 r., poz. 922).", marginLeft*s, 265*s);
    
  //  text("Jednocześnie wyrażam zgodę na przetwarzanie przez ogłoszeniodawcę moich danych "+
  //       "osobowych na potrzeby przyszłych rekrutacji.", marginLeft*s, 280*s);
  //}
  
  endRecord();
}
