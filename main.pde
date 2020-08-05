ArrayList<Vehicle> veis;

void setup() {
  size(1200, 600);

  veis = new ArrayList<Vehicle>();

  for (int i = 0; i < 10; i++)
    veis.add(new Vehicle(new PVector(random(width), random(height))));
    
}

void draw() {
  background(55, 5, 10);

  for (Vehicle vei : veis) {
    vei.wander();
    vei.run();
    for (Vehicle voi : veis) {
      if (voi != vei)
        vei.flee(voi.position);
    }
  }
}
