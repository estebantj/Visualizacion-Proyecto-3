import ddf.minim.*;
import ddf.minim.analysis.*;
 
Minim minim;
AudioPlayer song;
FFT fft;
String songName = "Bittersweet.mp3";

// Variables que definen las "zonas" del espectro
// Por ejemplo, para graves, tomamos solo el primer 4% del espectro total

float specLow = 0.03; // 3%
float specMid = 0.125;  // 12.5%
float specHi = 0.20;   // 20%

// Esto deja el 64% del espectro posible que no se utilizará.
// Estos valores suelen ser demasiado altos para el oído humano de todos modos.

// valores de puntuación para cada zona
float scoreLow = 0;
float scoreMid = 0;
float scoreHi = 0;

// Valores anteriores, para suavizar la reducción
float oldScoreLow = scoreLow;
float oldScoreMid = scoreMid;
float oldScoreHi = scoreHi;

void setup() {
	minim = new Minim(this);

	//Charger la chanson
	song = minim.loadFile(songName);

	//Créer l'objet FFT pour analyser la chanson
	fft = new FFT(song.bufferSize(), song.sampleRate());

	song.play(0);
}      

void draw() {
	fft.forward(song.mix);
}
