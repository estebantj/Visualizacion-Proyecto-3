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

int tiempoAnterior;

void setup() {
	//size(1366, 768, P3D);
	fullScreen(P3D);
	poligonos = new ArrayList<Poligono>();

	minim = new Minim(this);
	// Se carga la cancion
	song = minim.loadFile(songName);
	// Crea el objeto FFT para analizar la canción.
	fft = new FFT(song.bufferSize(), song.sampleRate());
	// Se reproduce la cancion
	song.play(0);
	tiempoAnterior = millis();
}      

void draw() {
	background(0);
	translate(width/2, height/2, 0);

	// first perform a forward fft on one of song's buffers
	fft.forward(song.mix);

	int tiempoActual = millis();
	if (tiempoActual - tiempoAnterior >= 1000) {
		for (int i=0; i<5; i++) {
			poligonos.add(new Poligono(random(-width/2, width/2), random(-height/2, height/2), random(-1500,-1000), 50));
		}
		tiempoAnterior = millis();
	}
	//println("Size: "+poligonos.size());
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

	/* 
		Rectangulos a ambos lados de la pantalla, scoreHi se utiliza para definir la cantidad de verde
		del color de ambos rectangulos.
	*/
	color displayColor = color(0,scoreHi,0);
	fill(displayColor);
	strokeWeight(0);

	beginShape();
	vertex(-width, -height, -500);
	vertex(-width, height, -500);
	vertex(-800, 50 ,-1000);
	vertex(-800, -50, -1000);
	endShape(); 

	beginShape();
	vertex(width, -height, -500);
	vertex(width, height, -500);
	vertex(800, 50, -1000);
	vertex(800, -50, -1000);
	endShape();

	// Cuadrado negro creado antes de la zona de creacion de cubos, asi no se nota donde aparecen los nuevos objetos.
	fill(0);
	beginShape();
	vertex(-width/2, -height/2,-1000);
	vertex(-width/2, height/2,-1000);
	vertex(width/2, height/2,-1000);
	vertex(width/2, -height/2,-1000);
	endShape();

	// Volumen para todas las frecuencias en este momento, con los sonidos más altos más altos.
    // Esto permite que la animación vaya más rápido para sonidos de tono más alto, lo que es más notable
	float scoreGlobal = 0.66*scoreLow + 0.8*scoreMid + 1*scoreHi;

	println("scoreGlobal: "+scoreGlobal);
	for (int index=0; index<poligonos.size(); index++) {
		Poligono poligonoactual = poligonos.get(index);
		poligonoactual.update(scoreGlobal);
		if (poligonoactual.checkOffScreen()) {
			poligonos.remove(index);
		} else {
			float bandValue = fft.getBand(index);
			poligonoactual.show(scoreLow, scoreMid, scoreHi, bandValue);
		}
	}	
}
