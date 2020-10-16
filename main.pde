Vehicle veis[];

void setup() {
  size(600, 600);

  veis = new Vehicle[13];
  for (int i = 0; i < veis.length; i++)
    veis[i] = new Vehicle();
}

void draw() {
  background(25);

  for (int i = 0; i < veis.length; i++) {
    veis[i].wander();
    veis[i].run();

    for (int j = 0; j < veis.length; j++)
      if (i != j)
        veis[i].flee(veis[j].position);
  }
}
