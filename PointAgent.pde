class PointAgent {

  PVector position;
  PVector velocity;
  PVector acceleration;
  float maxSpeed;
  float maxForce;
  float viewAngle;
  float viewRadius;

  //weights
  float sHWeight;
  float sWeight;

  //misc
  boolean moves;
  PointAgent target;

  PointAgent(PVector _position) {
    position = _position;
    target = new PointAgent();
    moves = true;
    acceleration = new PVector(0, 0);
    velocity = new PVector(0, 0);
    maxSpeed = 0.5;
    maxForce = 0.1;

    sHWeight = 1;
    sWeight = 5;
    viewRadius = 200;
    viewAngle = radians(60);
  }
  PointAgent(float x, float y) {
    position = new PVector(x, y);
    target = new PointAgent();
    moves = true;
    acceleration = new PVector(0, 0);
    velocity = new PVector(0, 0);
    maxSpeed = 0.5;
    maxForce = 0.5;
    sHWeight = 1;
    sWeight = 5;
    viewRadius = 200;
    viewAngle = radians(60);
  }

  PointAgent() {
    position = new PVector(5000, 5000);
    moves = false;
    acceleration = new PVector(0, 0);
    velocity = new PVector(0, 0);
    maxSpeed = 0.5;
    maxForce = 0.1;
  }

  void seekHome(PVector _origin, float _offSet) {
    PVector target = new PVector(_origin.x + _offSet, _origin.y + 1.5 * _offSet);
    PVector desired = PVector.sub(target, position);
    float d = desired.mag();
    if (d < 100) {
      float m = map(d, 0, 100, 0, maxSpeed);
      desired.setMag(m);
    } else {
      desired.setMag(maxSpeed);
    }
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxForce);
    applyForce(steer.mult(sHWeight));
  }

  void seek(PVector target) {
    PVector desired = PVector.sub(target, position);
    desired.setMag(maxSpeed);
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxForce);  // Limit to maximum steering force
    //println(steer);
    applyForce(steer.mult(sWeight));
  }

  void cohesion(ArrayList<K_Agent> agents) {
    PVector result = new PVector(0, 0);
    int neighbourCount = 0;
    for (int i = 0; i < agents.size(); i++) {
      for (int j = 0; j < agents.get(j).arms.length; j++) {
        if (a.arms[i].moves && isNeighbour(agents.get(i).arms[j], viewRadius, viewAngle, agents.get(i).arms)) {
        }
      }
    }
  }

  boolean isNeighbour(PointAgent _p, float _viewRadius, float _viewAngle, PointAgent[] _arm) {
    boolean isFriend = false;
    for (int i = 0; i < _arm.length; i++) {
      if (_arm[i] == this) {
        isFriend = true;
      } else {
        isFriend = false;
      }
    }
    if (this == _p || isFriend) {
      return false;
    } else if (dist(_p.position.x, _p.position.y, position.x, position.y) < viewRadius) {
      return true;
    } else {
      return false;
    }
  }
  void update() {
    velocity.add(acceleration);
    velocity.limit(maxSpeed);
    position.add(velocity);
    acceleration.mult(0);
  }
  void applyForce(PVector force) {
    acceleration.add(force);
  }
}