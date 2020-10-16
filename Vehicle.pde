class Vehicle {
  PVector position, velocity, acceleration;
  float mass, radius, maxSpeed, maxForce, minDist, wanderAngle;

  Vehicle() {
    position = new PVector(random(width), random(height));

    velocity = new PVector(random(-2.5, 2.5), random(-2.5, 2.5));
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
    edges();
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

  void edges() {
    if (position.x < 0)
      position.x = width;
    else if (position.x > width)
      position.x = 0;

    if (position.y < 0)
      position.y = height;
    else if (position.y > height)
      position.y = 0;
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
      steer.limit(maxForce * PI);
      applyForce(steer);
    }
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
