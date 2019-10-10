import processing.sound.*;
Amplitude amp;
AudioIn in;
SoundFile file;

void setup() {
  size(640, 360);
  background(255);
  file = new SoundFile(this, "Bittersweet.mp3");
  file.play();
  // Create an Input stream which is routed into the Amplitude analyzer
  amp = new Amplitude(this);
  in = new AudioIn(this, 0);
  in.start();
  amp.input(in);
}      

void draw() {
  println(amp.analyze());
}
