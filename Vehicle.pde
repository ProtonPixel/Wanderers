class Vehicle {
  PVector position, velocity, acceleration;
  float mass, radius, maxSpeed, maxForce, minDist, wanderAngle;

  Vehicle(PVector position) {
    this.position = position.copy();

    velocity = new PVector();
    acceleration = new PVector();
    mass = 8;
    radius = mass;

    maxSpeed = 2.5;
    maxForce = .5;
    minDist = 100;
    wanderAngle = 0;
  }

  void run() {
    move();
    show();
    edges1();
  }

  void move() {
    velocity.add(acceleration);
    velocity.limit(maxSpeed);
    position.add(velocity);

    acceleration.mult(0);
  }

  void show() {
    noFill();
    stroke(255);
    pushMatrix();

    translate(position.x, position.y);
    rotate(velocity.heading());

    triangle(-radius, radius, radius, 0, -radius, -radius);
    ellipse(-radius - 8, 0, 8, 8);

    popMatrix();
  }

  void applyForce(PVector force) {
    PVector forceCopy = force.copy();
    forceCopy.div(mass);
    acceleration.add(forceCopy);
  }

  void edges1() {
    if (position.x < 0)
      position.x = width;
    else if (position.x > width)
      position.x = 0;

    if (position.y < 0)
      position.y = height;
    else if (position.y > height)
      position.y = 0;
  }

  void edges2() {
    if (position.x < 0)
      position.x = 0;
    else if (position.x > width)
      position.x = width;
    if (position.y < 0)
      position.y = 0;
    else if (position.y > height) 
      position.y = height;
  }

  void seek(PVector target) {
    PVector desired = PVector.sub(target, position);
    desired.setMag(maxSpeed);

    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxForce);
    applyForce(steer);
  }

  void flee(PVector target) {
    if (PVector.dist(target, position) < minDist) {
      PVector desired = PVector.sub(target, position);
      desired.setMag(maxSpeed);

      PVector steer = PVector.sub(velocity, desired);
      steer.limit(maxForce * 2);
      applyForce(steer);
    }
  }

  void arrive(PVector target) {
    PVector desired = PVector.sub(target, position);
    float dist = PVector.dist(position, target);

    if (dist < minDist)
      desired.setMag(map(dist, 0, minDist, 0, maxSpeed));
    else
      desired.setMag(maxSpeed);

    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxForce);
    applyForce(steer);
  }

  void wander() {
    PVector tip, futureMoe, randVec, target;
    float mag, angInc;
    mag = 16;
    angInc = .5;
    tip = velocity.copy();
    tip.setMag(radius);
    tip.add(position);

    futureMoe = velocity.copy();
    futureMoe.setMag(mag);
    futureMoe.add(tip);

    randVec = PVector.fromAngle(wanderAngle);
    randVec.setMag(mag * .5);
    
    target = PVector.add(futureMoe, randVec);

    seek(target);

    wanderAngle += random(-angInc, angInc);

    noFill();
    stroke(255);
    line(tip.x, tip.y, futureMoe.x, futureMoe.y);
    line(futureMoe.x, futureMoe.y, target.x, target.y);
    ellipse(futureMoe.x, futureMoe.y, mag, mag);
  }
};
