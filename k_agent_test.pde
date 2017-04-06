K_Agent a;
void setup () {
  size(1000,1000);
  PVector position = new PVector(500,500);
  a = new K_Agent(position, 25);
}

void draw () {
  a.move();
  a.display();
}