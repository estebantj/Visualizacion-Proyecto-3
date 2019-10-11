import ddf.minim.*;
import ddf.minim.analysis.*;

int screenWidth = 800;
int screenHeight = 600;

Minim minim;
AudioPlayer song;
FFT fft;
String songName = "Bittersweet.mp3";

// Variables que definen las "zonas" del espectro
// Por ejemplo, para graves, tomamos solo el primer 4% del espectro total

float specLow = 0.10; // 3%
float specMid = 0.225;  // 12.5%
float specHi = 0.30;   // 20%

// Esto deja el 64% del espectro posible que no se utilizará.
// Estos valores suelen ser demasiado altos para el oído humano de todos modos.

// valores de puntuación para cada zona
float scoreLow = 0;
float scoreMid = 0;
float scoreHi = 0;

int tiempoAnterior = 0;
int tiempoActual = 0;

void setup() {
	fullScreen(P3D);
	// size(800,600);
	//surface.setSize(screenWidth, screenHeight);
	
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

	// first perform a forward fft on one of song's buffers
	fft.forward(song.mix);

	if (millis() - tiempoAnterior >= 50) {
		background(0);
		tiempoAnterior = millis();

		scoreLow = 0;
		scoreMid = 0;
		scoreHi = 0;

		int aumento = 2;

		stroke(255,0,0);
		for(int i= 0; i < fft.specSize()*specLow; i++)
		{
			scoreLow += fft.getBand(i);
			line(i + aumento, height, i+aumento+1, height - (fft.getBand(i+1)*25));
			aumento += 4;
		}

		
		stroke(255,255,0);
		for(int i = (int)(fft.specSize()*specLow); i < fft.specSize()*specMid; i++)
		{
			scoreMid += fft.getBand(i);
			line(i + aumento, height, i+aumento+1, height - (fft.getBand(i+1)*30));
			aumento += 4;
		}

		stroke(0,255,0);
		for(int i = (int)(fft.specSize()*specMid); i < fft.specSize()*specHi; i++)
		{
			scoreHi += fft.getBand(i);
			line(i + aumento, height, i+aumento+1, height - (fft.getBand(i+1)*30));
			aumento += 4;
		}

	}
}
