class Poligono {
	Vector ubicacion;
	Vector direccion;
	Vector velocidad;
	float radio;

	Poligono(float pX, float pY, float pRadio) {
		this.radio = 1;
		ubicacion = new Vector(pX, pY);
		direccion = new Vector(random(-1.5, 1.5), random(-1.5, 1.5));
	}

	void update() {
		this.radio += 0.2 * (direccion.x + direccion.y);
		this.ubicacion.x += this.direccion.x;
		this.ubicacion.y += this.direccion.y;
	}


	void show(float scoreLow, float scoreMid, float scoreHi, float intensity, float scoreGlobal) {
		color displayColor = color(scoreLow*0.67, scoreMid*0.67, scoreHi*0.67, intensity*5);
		fill(displayColor, 255);
		color strokeColor = color(255, 150-(20*intensity));
		stroke(strokeColor);
		strokeWeight(1 + (scoreGlobal/300));
		circle(ubicacion.x, ubicacion.y, radio);
	}

	boolean checkOffScreen() {
		return abs(ubicacion.x) > width/2  - this.radio || abs(ubicacion.y) > height/2  - this.radio;
	}

}