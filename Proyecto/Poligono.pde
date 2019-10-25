class Poligono {
	Vector ubicacion;
	Vector direccion;
	Vector velocidad;
	Vector rotacion;
	int opcion;
	float radio;

	Poligono(float pX, float pY, float pZ, float pRadio) {
		opcion = int(random(0,2));
		this.radio = pRadio;
		ubicacion = new Vector(pX, pY, pZ);
		direccion = new Vector(random(-1.5, 1.5), random(-1.5, 1.5), 1);
		rotacion = new Vector(random(-1.5, 1.5), random(-1.5, 1.5));
	}

	void update() {
		//this.radio += 2;
		//this.ubicacion.x += this.direccion.x;
		//this.ubicacion.y -= this.direccion.y;
		this.ubicacion.z += 2;
	}


	void show(float scoreLow, float scoreMid, float scoreHi, float intensity, float scoreGlobal) {
		pushMatrix();
		
		color strokeColor = color(50, 0, scoreMid);
    	stroke(strokeColor);
    	strokeWeight(4);
    	
    	color displayColor = color(scoreLow*0.67, 0, 0, intensity*5);
    	fill(displayColor, 255);
    	
		translate(this.ubicacion.x, this.ubicacion.y, this.ubicacion.z);
    	rotateX(this.rotacion.x);
		rotateY(this.rotacion.y);
		box(this.radio);
		popMatrix();
		/*
		if (this.opcion == 0) {
			color displayColor = color(scoreLow*0.67, 0, 0);
			fill(displayColor, 255);
			color strokeColor = color(255, 150-(20*intensity));
			stroke(strokeColor);
			strokeWeight(1 + (scoreGlobal/300));
			circle(this.ubicacion.x, this.ubicacion.y, this.radio);
		} else if  (this.opcion == 1) {
			color displayColor = color(0, 0, scoreHi*0.67);
			fill(displayColor, 255);
			color strokeColor = color(255, 150-(20*intensity));
			stroke(strokeColor);
			strokeWeight(1 + (scoreGlobal/300));
			rectMode(CENTER);
			square(this.ubicacion.x, this.ubicacion.y, this.radio);
		}
		*/
	}

	boolean checkOffScreen() {
		//return abs(this.ubicacion.x) > width/2  - this.radio || abs(this.ubicacion.y) > height/2  - this.radio;
		return this.ubicacion.z > 550;
	}

}
