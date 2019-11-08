class Poligono {
	Vector ubicacion;
	Vector direccion;
	Vector velocidad;
	Vector rotacion;
	int opcion;
	float radio;

	Poligono(float pX, float pY, float pZ, float pRadio) {
		this.radio = pRadio;
		ubicacion = new Vector(pX, pY, pZ);
		rotacion = new Vector(random(-1.5, 1.5), random(-1.5, 1.5));
	}

	void update(float volumen) {
		this.ubicacion.z += (2 + (volumen/100));
		this.rotacion.x -= (volumen/3000);
		//this.rotacion.y += (volumen/3000);
	}


	void show(float scoreLow, float scoreMid, float scoreHi, float intensity) {
		pushMatrix();
		
		// strokeColor = color(30, 0, scoreMid);
    	color strokeColor = color(30, scoreMid/2, scoreMid);
    	stroke(strokeColor);
    	strokeWeight(6);
    	
    	color displayColor = color(scoreHi, 0, 0);
    	fill(displayColor, 255);
    	
		translate(this.ubicacion.x, this.ubicacion.y, this.ubicacion.z);
    	rotateX(this.rotacion.x);
		rotateY(this.rotacion.y);
		box(this.radio);

		popMatrix();
	}

	boolean checkOffScreen() {
		return this.ubicacion.z > 1000;
	}
}
