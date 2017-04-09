class PointAgent {

  PVector position;
  PVector velocity;
  PVector acceleration;
  float maxSpeed;
  float maxForce;
  float viewAngle;
  float viewRadius;
  int joinedNumber;

  //weights
  float expWeight;
  float seekWeight;
  float cohesionWeight;
  float avoidanceWeight;

  //misc
  boolean moves;
  PointAgent target;

  PointAgent(PVector _position) {
    position = _position;
    target = new PointAgent();
    moves = true;
    acceleration = new PVector(0, 0, 0);
    velocity = new PVector(0, 0, 0);
    maxSpeed = 0.5;
    maxForce = 0.5;
    joinedNumber = 1;

    expWeight = random(5);
    seekWeight = random(5);
    cohesionWeight = random(5);
    avoidanceWeight = random(5);


    viewRadius = 50;
  }
  PointAgent(float x, float y, float z) {
    position = new PVector(x, y, z);
    target = new PointAgent();
    moves = true;
    acceleration = new PVector(0, 0, 0);
    velocity = new PVector(0, 0, 0);
    maxSpeed = 0.5;
    maxForce = 0.5;
    joinedNumber = 1;

    expWeight = random(1);
    seekWeight = random(5);
    cohesionWeight = random(5);
    avoidanceWeight = random(5);


    viewRadius = random(50,100);
    //viewAngle = radians(10);
  }

  PointAgent() {
    position = new PVector(5000, 5000, 5000);
    moves = false;
    acceleration = new PVector(0, 0);
    velocity = new PVector(0, 0);
    maxSpeed = 0.5;
    maxForce = 0.1;
  }

  void expansion(PVector _origin, float _offSet) {
    PVector target = new PVector(_origin.x + _offSet, _origin.y + 1.5 * _offSet, _origin.z);
    PVector desired = PVector.sub(target, position);
    float d = desired.mag();
    if (d < 100) {
      float m = map(d, 0, 100, 0, maxSpeed);
      desired.setMag(m);
    } else {
      desired.setMag(maxSpeed);
    }
    PVector steer = PVector.sub(desired, velocity);
    steer.mult(-1);
    steer.limit(maxForce);
    applyForce(steer.mult(expWeight));
  }

  void seek(PVector target) {
    PVector desired = PVector.sub(target, position);
    desired.setMag(maxSpeed);
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxForce);  // Limit to maximum steering force
    //println(steer);
    applyForce(steer.mult(seekWeight));
  }

  void cohesion(K_Agent[] agents) {
    PVector result = new PVector(0, 0, 0);
    int neighbourCount = 0;
    for (int i = 0; i < agents.length; i++) {
      for (int j = 0; j < agents[i].arms.length; j++) {
        if (agents[i].moves && isNeighbour(agents[i].arms[j], agents[i].arms)) {
          PointAgent agent = agents[i].arms[j];
          result = result.add(agent.position);
          neighbourCount++;
        } 
        if (isNeighbour(agents[i].arms[j], agents[i].arms) == true && dist( agents[i].arms[j].position.x, agents[i].arms[j].position.y, position.x, position.y) < 5 && joinedNumber < 3) {
          //  boolean b = isNeighbour(agents[i].arms[j], agents[i].arms);
          // println(b);
          joinArms(agents[i].arms, j);
          joinedNumber++;
        }
      }
    }
    //    println(joinedNumber);

    if (neighbourCount > 0) {
      result.mult(1.0f / neighbourCount);
      result = result.sub(position);
    }
    applyForce(result.mult(cohesionWeight / joinedNumber));
  }

  void avoidance(K_Agent[] agents) {
    PVector result = new PVector(0, 0, 0);
    int neighbourCount = 0;
    for (int i = 0; i < agents.length; i++) {
      for (int j = 0; j < agents[i].arms.length; j++) {
        if (agents[i].moves && isNeighbour(agents[i].arms[j], agents[i].arms)) {
          PointAgent agent = agents[i].arms[j];
          result = result.add(agent.position);
          neighbourCount++;
        }
      }
    }
    //    println(joinedNumber);

    if (neighbourCount > 0) {
      result.mult(1.0f / neighbourCount);
      result = result.sub(position);
    }
    result.mult(-1);
    applyForce(result.mult(avoidanceWeight / joinedNumber));
  }

  boolean isNeighbour(PointAgent _p, PointAgent[] _arm) {
    boolean isFriend = false;
    for (int i = 0; i < _arm.length; i++) {
      if (_arm[i] == this) {
        isFriend = true;
      } else if (isFriend == false) {
        isFriend = false;
      }
    }
    if (this == _p) {
      return false;
    } else if (isFriend == true) {
      return false;
    } else if (dist(_p.position.x, _p.position.y, position.x, position.y) < viewRadius) {
      return true;
    } else {
      return false;
    }
  }

  //boolean isInView(PointAgent _p, float _viewAngle) {
  //  float ourHeadingRadians = velocity.heading();
  //  float upperGradient, lowerGradient;
  //  if (ourHeadingRadians - _viewAngle > ourHeadingRadians + _viewAngle) {
  //    upperGradient = tan(ourHeadingRadians - _viewAngle);
  //    lowerGradient = tan(ourHeadingRadians + _viewAngle);
  //  } else {
  //    upperGradient = tan(ourHeadingRadians + _viewAngle);
  //    lowerGradient = tan(ourHeadingRadians - _viewAngle);
  //  }
  //  float upperLineY = position.y + upperGradient * _p.position.y;
  //  float lowerLineY = position.y + lowerGradient * _p.position.y;


  //  if (upperLineY > _p.position.y && _p.position.y > lowerLineY) {
  //    return true;
  //  } else {
  //    return false;
  //  }
  //}


  void joinArms(PointAgent[] arm, int currentIndex) {
    arm[currentIndex] = this;
    //  println("Joined");
  }
  void update() {
    if (moves == true) {
      velocity.add(acceleration);
      velocity.limit(maxSpeed);
      position.add(velocity);
      acceleration.mult(0);
    }
  }
  void applyForce(PVector force) {
    acceleration.add(force);
  }
}