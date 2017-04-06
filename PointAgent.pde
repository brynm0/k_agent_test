class PointAgent {
  PVector position;
  PVector velocity;
  PVector acceleration;
  boolean moves;
  PointAgent target;
  float springStrength;


  PointAgent(PVector _position) {
    position = _position;
    target = new PointAgent();
    moves = true;
    springStrength = 1;
    acceleration = new PVector(0, 0);
    velocity = new PVector(0, 0);
  }
  PointAgent(float x, float y) {
    position = new PVector();
    position.x = x;
    position.y = y;
    target = new PointAgent();
    moves = true;
    acceleration = new PVector(0, 0);
    velocity = new PVector(0, 0);
  }

  PointAgent() {
    position = new PVector(5000, 5000);
    moves = false;
    acceleration = new PVector(0, 0);
    velocity = new PVector(0, 0);
  }

  PVector spring(PVector _origin, float _offSet) {
    PVector springForce = new PVector();
    float equilibriumPosition = 1.80278 * _offSet;
    float currentDisplacement = dist(position.x, position.y, _origin.x, _origin.y);
    //F = -kxp[
    //F = ma
    //just let m = 1 for the moment
    //F = a
    //acceleration of point agent = F
    float x = currentDisplacement - equilibriumPosition;
    springForce.setMag(springStrength * x);
    float rise = _origin.y - position.y;
    float run = _origin.x - position.x;
    float orientation = atan(rise/run);
    springForce.rotate(orientation);
    println(springForce);
    return springForce;
  }
  void resolveForces(PVector _origin, float _offset) {
    PVector springForce = new PVector();
    springForce = spring(_origin, _offset);
    acceleration = springForce.mult(1);
  }
  void move(PVector _origin, float _offset) {
    resolveForces(_origin, _offset);
    velocity = velocity.add(acceleration); 
    position.x = velocity.x + position.x;
    position.y = velocity.y + position.y;
  }
}