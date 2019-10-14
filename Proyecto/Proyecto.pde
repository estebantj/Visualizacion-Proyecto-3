import ddf.minim.*;
import ddf.minim.analysis.*;

int screenWidth = 1366;
int screenHeight = 768;

Minim minim;
AudioPlayer song;
FFT fft;
String songName = "lifetime.mp3";

// Variables que definen las "zonas" del espectro
// Por ejemplo, para graves, tomamos solo el primer 4% del espectro total

float specLow = 0.10; // 3%
float specMid = 0.225;  // 12.5%
float specHi = 0.30;   // 20%


// Esto deja el 64% del espectro posible que no se utilizará.
// Estos valores suelen ser demasiado altos para el oído humano de todos modos.

// valor de suavizado
float scoreDecreaseRate = 25;

// valores de puntuación para cada zona
float scoreLow = 0;
float scoreMid = 0;
float scoreHi = 0;

float oldScoreLow = scoreLow;
float oldScoreMid = scoreMid;
float oldScoreHi = scoreHi;

ArrayList<Poligono> poligonos;

void setup() {
	//surface.setSize(screenWidth, screenHeight);
	fullScreen();
	poligonos = new ArrayList<Poligono>();

	minim = new Minim(this);
	// Se carga la cancion
	song = minim.loadFile(songName);
	// Crea el objeto FFT para analizar la canción.
	fft = new FFT(song.bufferSize(), song.sampleRate());
	// Se reproduce la cancion
	song.play(0);

}      

void draw() {
	translate(width/2, height/2);
	background(0);

	// first perform a forward fft on one of song's buffers
	fft.forward(song.mix);
	
	while (poligonos.size() < 100) {
		poligonos.add(new Poligono(0, 0, 30));
	}

	oldScoreLow = scoreLow;
	oldScoreMid = scoreMid;
	oldScoreHi = scoreHi;

	scoreLow = 0;
	scoreMid = 0;
	scoreHi = 0;

	for(int i= 0; i < fft.specSize()*specLow; i++) {
		scoreLow += fft.getBand(i);
	}

	for(int i = (int)(fft.specSize()*specLow); i < fft.specSize()*specMid; i++) {
		scoreMid += fft.getBand(i);
	}

	for(int i = (int)(fft.specSize()*specMid); i < fft.specSize()*specHi; i++) {
		scoreHi += fft.getBand(i);
	}
	
	float scoreGlobal = 0.66*scoreLow + 0.8*scoreMid + 1*scoreHi;
	
	for (int index=0; index<poligonos.size(); index++) {
		Poligono poligonoactual = poligonos.get(index);
		poligonoactual.update();
		if (poligonoactual.checkOffScreen()) {
			poligonos.remove(index);
		} else {
			float bandValue = fft.getBand(index);
			poligonoactual.show(scoreLow, scoreMid, scoreHi, bandValue, scoreGlobal);
		}
	}
}
