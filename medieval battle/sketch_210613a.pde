/***************************************
Denis Chen
Medieval Battle
CS 35 
6/20/2021

This program is my own work
*/

PImage godWings; 
float[] skyColor = {0, 255, 255};
boolean heroSelection = true;
boolean enemySelection = false;


void setup() {
  size(1500, 800);
  background(255);
  godWings = loadImage("chiseledwingsTRANSPARENT.png");
}

public class Warrior {
  float health;
  float maxHealth;
  float attackdamage;
  float attackrange;
  float attackcooldown;
  float maxAttackCooldown;

  float defense;


  float healthbarLength;
  float rechargebarLength;

  float xPos;
  float yPos;
  float diameter;

  float attackanimationTime;

  float animation1Time;
  float animation2Time;
  float animation3Time;
  float animation4Time;

  float chainedAnimationTimings;


  float[] modelColor = {0, 0, 0};

  public Warrior() {
    this.health = 50;
    this.defense = 0;

    this.maxHealth = 50;
    this.attackdamage = 5;
    this.attackrange = 100;

    this.attackcooldown = 120;
    this.maxAttackCooldown = 120;


    this.healthbarLength = 80;
    this.rechargebarLength = 50;

    this.xPos = 600;
    this.yPos = 400;

    this.diameter = 40;
  }

  public boolean alive() {
    if (this.health > 0) {
      return true;
    } else {
      return false;
    }
  }

  public void attackrecharge() {
    if (attackcooldown > 0) {
      this.attackcooldown = this.attackcooldown - 1;
    }
  }

  public void character(float x, float y) {
    if (this.alive()) {
      // Character model
      this.xPos = x;
      this.yPos = y;

      circle(xPos, yPos, 40);

      //Health bar
      strokeWeight(2);
      stroke(0);
      rectMode(CORNER);
      fill(135);
      rect(xPos - healthbarLength / 2, yPos - 40, healthbarLength, 15);
      fill(0, 255, 0);
      rect(xPos - healthbarLength / 2, yPos - 40, healthbarLength*this.health/this.maxHealth, 15);

      // Attack recharge bar
      fill(135);
      rect(xPos - rechargebarLength / 2, yPos + 40, rechargebarLength, 15);
      fill(255, 0, 255);
      rect(xPos - rechargebarLength / 2, yPos + 40, rechargebarLength*(this.maxAttackCooldown - this.attackcooldown)/this.maxAttackCooldown, 15);
      noStroke();
    }
  }

  // If the mouse is within the hitbox, return true (xCentre, yCentre) are the coordinates of the middle of the hitbox; xLength andand yHeight are the horizontal and vertical lengths of the hitbox, respectively 
  public boolean inHitbox(float xLength, float yHeight, float xCentre, float yCentre) {
    if (mouseX >= xCentre - xLength / 2 && mouseX <= xCentre + xLength / 2 && mouseY >= yCentre - yHeight / 2 && mouseY <= yCentre + yHeight / 2) {
      return true;
    } else {
      return false;
    }
  }

  // Checks corners of the hitbox to see if a certain color of an animation is there; it means that it's being hit by an animation
  public boolean colorHitbox(float x, float y, float xLength, float yHeight, float color1, float color2, float color3) {
    if (get((int)x, (int)y) == color1 || get((int)x, (int)y) == color2 || get((int)x, (int)y) == color3 
      || get((int)(x + xLength), (int)y) == color1 || get((int)(x + xLength), (int)y) == color2 || get((int)(x + xLength), (int)y) == color3
      || get((int)(x), (int)(y + yHeight)) == color1 || get((int)(x), (int)(y + yHeight)) == color2 || get((int)(x), (int)(y + yHeight)) == color3
      || get((int)(x + xLength), (int)(y + yHeight)) == color1 || get((int)(x + xLength), (int)(y + yHeight)) == color2 || get((int)(x + xLength), (int)(y + yHeight)) == color3) {
      return true;
    } else {
      return false;
    }
  }


  public void attack(Warrior enemy) {
    if (this.alive() && enemy.alive() && attackcooldown == 0 && abs(enemy.xPos - this.xPos) <= this.attackrange) {
      if (attackdamage > enemy.defense) {
        enemy.health = enemy.health - (this.attackdamage - enemy.defense);
      } else if (this.attackdamage <= enemy.defense) {
        println("Defense too high!");
      }      
      attackcooldown = 120;
    }
  }



  public void animation(Warrior enemy) {
  }


  // These methods are only for the healer, but I need to make them common
  // to all classes just so the program doesn't crash
  public void healrecharge() {
  }
  public void healspell(Warrior enemy) {
  }
  public void healChargeBar() {
  }
  public void healanimation(Warrior enemy) {
  }
}










boolean a = false;


public class Knight extends Warrior {

  float[] modelColor = {255, 100, 0};
  public Knight() {

    this.health = 60; 
    this.maxHealth = 60;
    this.attackdamage = 7;
    this.attackrange = 100;

    this.attackanimationTime = 0;

    this.animation1Time = 0;
    this.animation2Time = 0;
    this.animation3Time = 0;
    this.animation4Time = 0;

    this.chainedAnimationTimings = 8;

    this.xPos = 650;
    this.yPos = 400;
  }

  public void attack(Warrior enemy) {
    if (this.alive() && enemy.alive() && attackcooldown == 0 && abs(enemy.xPos - this.xPos) <= this.attackrange) {
      if (this.attackdamage > enemy.defense) {
        enemy.health = enemy.health - (this.attackdamage - enemy.defense);
      } else if (this.attackdamage <= enemy.defense) {
        println("Defense too high!");
      }

      this.attackcooldown = this.maxAttackCooldown;
    }
  }

  public void animation(Warrior enemy) {
    if (this.attackcooldown == 0 && enemy.alive() && this.alive() && abs(enemy.xPos - this.xPos) <= this.attackrange) {
      this.attackanimationTime = chainedAnimationTimings;
      this.animation1Time = chainedAnimationTimings;

      a = true;
    }

    if (a) {
      fill(255);
      if (attackanimationTime > 0) {

        this.attackanimationTime = this.attackanimationTime - 1;
      }



      if (this.animation1Time > 0) {
        // Slash left if the enemy is to the left, and slash right if enemy is to the right or (I'm lazy) exactly where the player is
        if (enemy.xPos >= this.xPos) {
          fill(255);
          arc(this.xPos - 100, this.yPos, 500, 200, 3*PI/2, 5*PI/2);

          fill(0, 255, 255);
          arc(this.xPos - 100, this.yPos, 400, 200, 3*PI/2, 4*PI/2);
          fill(0, 255, 0);
          arc(this.xPos - 100, this.yPos, 400, 200, 4*PI/2, 5*PI/2);

          // Redraws the character models because the arcs that form the slash will overlap the models
          enemy.character(enemy.xPos, enemy.yPos);
          this.character(this.xPos, this.yPos);
        } else if (enemy.xPos < this.xPos) {
          fill(255);
          arc(this.xPos + 100, this.yPos, 500, 200, PI/2, 3*PI/2);

          fill(0, 255, 0);
          arc(this.xPos + 100, this.yPos, 400, 200, PI/2, PI);

          fill(0, 255, 255);
          arc(this.xPos + 100, this.yPos, 400, 200, PI, 3*PI/2);

          enemy.character(enemy.xPos, enemy.yPos);
          this.character(this.xPos, this.yPos);
        }
        this.animation1Time--;
        if (this.animation1Time <= this.chainedAnimationTimings) {
          this.animation2Time = this.chainedAnimationTimings;
        }
      }

      if (this.animation2Time > 0) {


        this.animation2Time--;
        if (this.animation2Time <= this.chainedAnimationTimings) {
          this.animation3Time = this.chainedAnimationTimings;
        }
      }

      if (this.animation3Time > 0) {



        this.animation3Time--;
        if (this.animation3Time <= this.chainedAnimationTimings) {
          this.animation4Time = this.chainedAnimationTimings;
        }
      }

      if (this.animation4Time > 0) {



        this.animation4Time--;
      }
    }
  }
  public void character(float x, float y) {
    if (this.alive()) {
      // Character model
      this.xPos = x;
      this.yPos = y;
      fill(modelColor[0], modelColor[1], modelColor[2]);
      circle(xPos, yPos, 40);







      //Health bar
      strokeWeight(2);
      stroke(0);
      rectMode(CORNER);
      fill(135);
      rect(xPos - healthbarLength / 2, yPos - 40, healthbarLength, 15);
      fill(0, 255, 0);
      rect(xPos - healthbarLength / 2, yPos - 40, healthbarLength*this.health/this.maxHealth, 15);

      // Attack recharge bar
      fill(135);
      rect(xPos - rechargebarLength / 2, yPos + 40, rechargebarLength, 15);
      fill(255, 0, 255);
      rect(xPos - rechargebarLength / 2, yPos + 40, rechargebarLength*(this.maxAttackCooldown - this.attackcooldown)/this.maxAttackCooldown, 15);
      noStroke();
    }
  }
}












public class Defender extends Warrior {

  float[] modelColor = {127, 127, 127};
  public Defender() {
    this.health = 60; 
    this.maxHealth = 60;
    this.defense = 3;
    this.attackdamage = 5;
    this.attackrange = 100;

    this.attackanimationTime = 0;

    this.animation1Time = 0;
    this.animation2Time = 0;
    this.animation3Time = 0;
    this.animation4Time = 0;

    this.chainedAnimationTimings = 8;

    this.xPos = 650;
    this.yPos = 400;
  }

  public void attack(Warrior enemy) {
    if (this.alive() && enemy.alive() && attackcooldown == 0 && abs(enemy.xPos - this.xPos) <= this.attackrange) {
      println("My defense = " + this.defense);
      if (this.attackdamage > enemy.defense) {
        enemy.health = enemy.health - (this.attackdamage - enemy.defense);
      } else if (this.attackdamage <= enemy.defense) {
        println("Defense too high!");
      }
      // The defender can strike with such blunt force that it stuns his target, delaying their next attack

      enemy.attackcooldown = enemy.attackcooldown + 80;

      // Ensures that it won't overshoot their original maximum cooldown
      if (enemy.attackcooldown > enemy.maxAttackCooldown) {
        enemy.attackcooldown = enemy.maxAttackCooldown;
      }

      attackcooldown = maxAttackCooldown;
    }
  }



  public void animation(Warrior enemy) {
    if (this.attackcooldown == 0 && enemy.alive() && this.alive() && abs(enemy.xPos - this.xPos) <= this.attackrange) {
      this.attackanimationTime = chainedAnimationTimings;
      this.animation1Time = chainedAnimationTimings;

      a = true;
    }

    if (a) {
      fill(255);
      if (attackanimationTime > 0) {
        // Weird shockwave thing, when defender slams the ground
        fill(255, 255, 0);
        arc(this.xPos, this.yPos, 100, 100, PI, 2*PI);

        arc(this.xPos, this.yPos + 10, 60, 60, 0, PI);

        fill(255, 100, 0);
        arc(this.xPos, this.yPos, 200, 200, PI, PI + PI / 4);
        arc(this.xPos, this.yPos, 200, 200, 2*PI - PI / 4, 2*PI);
        fill(255);
        rect(this.xPos - 25, this.yPos, - 20, -60);
        rect(this.xPos + 25, this.yPos, + 20, -60);
        this.attackanimationTime = this.attackanimationTime - 1;
      }

      /*
      
       
       */

      if (this.animation1Time > 0) {
        rect(this.xPos - 55, this.yPos, - 30, -80);
        rect(this.xPos + 55, this.yPos, + 30, -80);
        this.animation1Time--;
        if (this.animation1Time <= this.chainedAnimationTimings) {
          this.animation2Time = this.chainedAnimationTimings;
        }
      }

      if (this.animation2Time > 0) {
        rect(this.xPos - 95, this.yPos, - 40, -100);
        rect(this.xPos + 95, this.yPos, + 40, -100);

        this.animation2Time--;
        if (this.animation2Time <= this.chainedAnimationTimings) {
          this.animation3Time = this.chainedAnimationTimings;
        }
      }

      if (this.animation3Time > 0) {



        this.animation3Time--;
        if (this.animation3Time <= this.chainedAnimationTimings) {
          this.animation4Time = this.chainedAnimationTimings;
        }
      }

      if (this.animation4Time > 0) {



        this.animation4Time--;
      }
    }
  }
  public void character(float x, float y) {
    if (this.alive()) {
      // Character model
      this.xPos = x;
      this.yPos = y;
      fill(modelColor[0], modelColor[1], modelColor[2]);
      circle(xPos, yPos, 40);







      //Health bar
      strokeWeight(2);
      stroke(0);
      rectMode(CORNER);
      fill(135);
      rect(xPos - healthbarLength / 2, yPos - 40, healthbarLength, 15);
      fill(0, 255, 0);
      rect(xPos - healthbarLength / 2, yPos - 40, healthbarLength*this.health/this.maxHealth, 15);

      // Attack recharge bar
      fill(135);
      rect(xPos - rechargebarLength / 2, yPos + 40, rechargebarLength, 15);
      fill(255, 0, 255);
      rect(xPos - rechargebarLength / 2, yPos + 40, rechargebarLength*(this.maxAttackCooldown - this.attackcooldown)/this.maxAttackCooldown, 15);
      noStroke();
    }
  }
}











public class Vampire extends Warrior {
  float vampirism = 0.5;
  float[] modelColor = {150, 0, 0};
  public Vampire() {
    this.health = 40;
    this.maxHealth = 40;
    this.attackdamage = 4;
    this.attackrange = 150;

    this.attackanimationTime = 0;

    this.animation1Time = 0;
    this.animation2Time = 0;
    this.animation3Time = 0;
    this.animation4Time = 0;

    this.chainedAnimationTimings = 8;
  }



  public void attack(Warrior enemy) {
    if (this.alive() && enemy.alive() && attackcooldown == 0 && abs(enemy.xPos - this.xPos) <= this.attackrange) {
      if (this.attackdamage > enemy.defense) {
        enemy.health = enemy.health - (this.attackdamage - enemy.defense);
        // Lifesteal heals for a fraction of the damage (if vampirism is 0.5, they heal for half their dealt damage)
        this.health = this.health + this.vampirism*(this.attackdamage - enemy.defense);
      } else if (this.attackdamage <= enemy.defense) {
        println("Defense too high!");
      }

      if (this.health > this.maxHealth) {
        this.health = this.maxHealth;
      }
      attackcooldown = maxAttackCooldown;
    }
  }



  public void animation(Warrior enemy) {
    if (this.attackcooldown == 0 && enemy.alive() && this.alive() && abs(enemy.xPos - this.xPos) <= this.attackrange) {
      this.attackanimationTime = chainedAnimationTimings;
      this.animation1Time = chainedAnimationTimings;

      a = true;
    }

    if (a) {
      if (attackanimationTime > 0) {


        this.attackanimationTime = this.attackanimationTime - 1;
      }

      /*
      Animations 1 - 3 are health steal lines (blood being drained from enemy)
       Animation 4 is some random spiky animation that appears on the affected enemy
       */

      if (this.animation1Time > 0) {
        stroke(255, 0, 0);
        strokeWeight(5);
        //fill(255, 0, 0);

        line(enemy.xPos, enemy.yPos+10, this.xPos, this. yPos); 
        line(enemy.xPos, enemy.yPos, this.xPos, this. yPos);
        line(enemy.xPos, enemy.yPos-10, this.xPos, this. yPos);  

        // Heal particles
        stroke(255, 0, 0);

        line(this.xPos, this.yPos - 60, this.xPos, this.yPos  - 70);
        line(this.xPos - 5, this.yPos - 65, this.xPos + 5, this.yPos - 65);

        line(this.xPos + 30, this.yPos - 10, this.xPos + 30, this.yPos  - 20);
        line(this.xPos + 25, this.yPos - 15, this.xPos + 35, this.yPos - 15);

        line(this.xPos - 30, this.yPos + 20, this.xPos - 30, this.yPos  + 10);
        line(this.xPos  - 35, this.yPos + 15, this.xPos - 25, this.yPos + 15);
        noStroke();
        this.animation1Time--;
        if (this.animation1Time <= this.chainedAnimationTimings) {
          this.animation2Time = this.chainedAnimationTimings;
        }
      }

      if (this.animation2Time > 0) {
        strokeWeight(5);

        line(enemy.xPos, enemy.yPos+10, this.xPos, this. yPos); 
        line(enemy.xPos, enemy.yPos, this.xPos, this. yPos);
        line(enemy.xPos, enemy.yPos-10, this.xPos, this. yPos);      
        noStroke();
        this.animation2Time--;
        if (this.animation2Time <= this.chainedAnimationTimings) {
          this.animation3Time = this.chainedAnimationTimings;
        }
      }

      if (this.animation3Time > 0) {
        strokeWeight(5);

        line(enemy.xPos, enemy.yPos+10, this.xPos, this. yPos); 
        line(enemy.xPos, enemy.yPos, this.xPos, this. yPos);
        line(enemy.xPos, enemy.yPos-10, this.xPos, this. yPos);   
        noStroke();
        this.animation3Time--;
        if (this.animation3Time <= this.chainedAnimationTimings) {
          this.animation4Time = this.chainedAnimationTimings;
        }
      }

      if (this.animation4Time > 0) {
        strokeWeight(3);

        stroke(255, 0, 0);

        line(enemy.xPos, enemy.yPos, enemy.xPos - 10, enemy.yPos - 50);
        line(enemy.xPos, enemy.yPos, enemy.xPos + 10, enemy.yPos - 50);
        line(enemy.xPos, enemy.yPos, enemy.xPos, enemy.yPos - 52);

        line(enemy.xPos, enemy.yPos, enemy.xPos - 20, enemy.yPos - 45);
        line(enemy.xPos, enemy.yPos, enemy.xPos + 20, enemy.yPos - 45);

        line(enemy.xPos, enemy.yPos, enemy.xPos - 30, enemy.yPos - 35);
        line(enemy.xPos, enemy.yPos, enemy.xPos + 30, enemy.yPos - 35);

        line(enemy.xPos, enemy.yPos, enemy.xPos - 35, enemy.yPos - 20);
        line(enemy.xPos, enemy.yPos, enemy.xPos + 35, enemy.yPos - 20);




        line(enemy.xPos, enemy.yPos, enemy.xPos - 10, enemy.yPos + 50);
        line(enemy.xPos, enemy.yPos, enemy.xPos + 10, enemy.yPos + 50);
        line(enemy.xPos, enemy.yPos, enemy.xPos, enemy.yPos + 52);

        line(enemy.xPos, enemy.yPos, enemy.xPos - 20, enemy.yPos + 45);
        line(enemy.xPos, enemy.yPos, enemy.xPos + 20, enemy.yPos + 45);

        line(enemy.xPos, enemy.yPos, enemy.xPos - 30, enemy.yPos + 35);
        line(enemy.xPos, enemy.yPos, enemy.xPos + 30, enemy.yPos + 35);

        line(enemy.xPos, enemy.yPos, enemy.xPos - 35, enemy.yPos + 20);
        line(enemy.xPos, enemy.yPos, enemy.xPos + 35, enemy.yPos + 20);

        noStroke();


        this.animation4Time--;
      }
    }
  }
  public void character(float x, float y) {
    if (this.alive()) {
      // Character model
      this.xPos = x;
      this.yPos = y;
      fill(modelColor[0], modelColor[1], modelColor[2]);
      circle(xPos, yPos, 40);







      //Health bar
      strokeWeight(2);
      stroke(0);
      rectMode(CORNER);
      fill(135);
      rect(xPos - healthbarLength / 2, yPos - 40, healthbarLength, 15);
      fill(0, 255, 0);
      rect(xPos - healthbarLength / 2, yPos - 40, healthbarLength*this.health/this.maxHealth, 15);

      // Attack recharge bar
      fill(135);
      rect(xPos - rechargebarLength / 2, yPos + 40, rechargebarLength, 15);
      fill(255, 0, 255);
      rect(xPos - rechargebarLength / 2, yPos + 40, rechargebarLength*(this.maxAttackCooldown - this.attackcooldown)/this.maxAttackCooldown, 15);
      noStroke();
    }
  }
}










// Lancer may need rebalancing because he sucks right now (he pulls enemies in but never wins the close range duel)
public class Lancer extends Warrior {
  float[] modelColor = {0, 60, 150};
  public Lancer() {
    this.health = 60;
    this.maxHealth = 60;
    this.attackdamage = 10;

    this.attackrange = 200;

    this.attackanimationTime = 0;

    this.animation1Time = 0;
    this.animation2Time = 0;
    this.animation3Time = 0;
    this.animation4Time = 0;

    this.chainedAnimationTimings = 8;
  }


  public void attack(Warrior enemy) {
    if (this.alive() && enemy.alive() && attackcooldown == 0 && abs(enemy.xPos - this.xPos) <= this.attackrange) {

      if (this.attackdamage > enemy.defense) {
        enemy.health = enemy.health - (this.attackdamage - enemy.defense);
      } else if (this.attackdamage <= enemy.defense) {
        println("Defense too high!");
      }


      // Lancer stabs target outward and then pulls them back in again (pretty hard to escape, so if you get in his range you will take a lot of damage)

      enemy.xPos = enemy.xPos - (enemy.xPos - this.xPos) / 2;



      attackcooldown = maxAttackCooldown;
    }
  }
  public void animation(Warrior enemy) {

    if (this.attackcooldown == 0 && enemy.alive() && this.alive() && abs(enemy.xPos - this.xPos) <= this.attackrange) {
      this.attackanimationTime = chainedAnimationTimings;
      this.animation1Time = chainedAnimationTimings;

      a = true;
    }

    if (a) {
      if (attackanimationTime > 0) {


        this.attackanimationTime = this.attackanimationTime - 1;
      }

      if (this.animation1Time > 0) {

        this.animation1Time--;
        if (this.animation1Time <= this.chainedAnimationTimings) {
          this.animation2Time = this.chainedAnimationTimings;
        }
      }

      if (this.animation2Time > 0) {
        // Determines which side the lance should be stabbing
        float sideFactor = (enemy.xPos - this.xPos)/abs(this.xPos - enemy.xPos);
        // Pushes the lance further away from the lancer's model
        float shift = -80;
        fill(255, 190, 0);
        triangle(this.xPos - sideFactor*(40+shift), this.yPos - 50, this.xPos - sideFactor*(190+shift), this.yPos + 50, this.xPos + sideFactor*(500-shift), this.yPos);
        fill(255, 220, 0);
        triangle(this.xPos - sideFactor*(20+shift), this.yPos - 50, this.xPos - sideFactor*(120+shift), this.yPos + 50, this.xPos + sideFactor*(500-shift), this.yPos);
        fill(255, 255, 0);
        triangle(this.xPos - sideFactor*(shift), this.yPos - 50, this.xPos - sideFactor*(50+shift), this.yPos + 50, this.xPos + sideFactor*(500-shift), this.yPos);

        this.animation2Time--;
        if (this.animation2Time <= this.chainedAnimationTimings) {
          this.animation3Time = this.chainedAnimationTimings;
        }
      }

      if (this.animation3Time > 0) {

        this.animation3Time--;
        if (this.animation3Time <= this.chainedAnimationTimings) {
          this.animation4Time = this.chainedAnimationTimings;
        }
      }

      if (this.animation4Time > 0) {

        this.animation4Time--;
      }
    }
  }

  public void character(float x, float y) {
    if (this.alive()) {
      // Character model
      this.xPos = x;
      this.yPos = y;
      fill(modelColor[0], modelColor[1], modelColor[2]);
      circle(xPos, yPos, 40);







      //Health bar
      strokeWeight(2);
      stroke(0);
      rectMode(CORNER);
      fill(135);
      rect(xPos - healthbarLength / 2, yPos - 40, healthbarLength, 15);
      fill(0, 255, 0);
      rect(xPos - healthbarLength / 2, yPos - 40, healthbarLength*this.health/this.maxHealth, 15);

      // Attack recharge bar
      fill(135);
      rect(xPos - rechargebarLength / 2, yPos + 40, rechargebarLength, 15);
      fill(255, 0, 255);
      rect(xPos - rechargebarLength / 2, yPos + 40, rechargebarLength*(this.maxAttackCooldown - this.attackcooldown)/this.maxAttackCooldown, 15);
      noStroke();
    }
  }
}










public class Healer extends Warrior {
  float healthrestore = 4;
  float healcooldown;
  float healMaxCooldown;

  float healanimation1Time;
  float healanimation2Time;
  float healanimation3Time;
  float healanimation4Time;

  float healanimationTime;

  float chainedHealAnimationTimings;

  float[] modelColor = {255, 255, 150};
  public Healer() {
    this.health = 60;
    this.maxHealth = 60;
    this.attackdamage = 1;

    this.healcooldown = 240;
    this.healMaxCooldown = 240;

    this.attackanimationTime = 0;
    this.healanimationTime = 0;

    this.animation1Time = 0;
    this.animation2Time = 0;
    this.animation3Time = 0;
    this.animation4Time = 0;

    this.animation1Time = 0;
    this.animation2Time = 0;
    this.animation3Time = 0;
    this.animation4Time = 0;

    this.chainedAnimationTimings = 8;
    this.chainedHealAnimationTimings = 8;
  }

  public void healrecharge() {
    if (healcooldown > 0) {
      this.healcooldown = this.healcooldown - 1;
    }
  }

  // New type of attack that is based purely on healing
  public void healspell(Warrior ally) {


    if (this.alive() && ally.alive() && healcooldown == 0 && abs(ally.xPos - this.xPos) <= this.attackrange) {
      // Lifesteal heals for a fraction of the damage (if vampirism is 0.5, they heal for half their dealt damage)
      ally.health = ally.health + this.healthrestore;
      if (ally.health > ally.maxHealth) {
        ally.health = ally.maxHealth;
      }
      healcooldown = healMaxCooldown;
    }
  }

  public void attack(Warrior enemy) {
    if (this.alive() && enemy.alive() && attackcooldown == 0 && abs(enemy.xPos - this.xPos) <= this.attackrange) {
        // Ignores armor
        enemy.health = enemy.health - this.attackdamage;
         
      attackcooldown = 120;
    }
  }

  public void animation(Warrior enemy) {

    if (this.attackcooldown == 0 && enemy.alive() && this.alive() && abs(enemy.xPos - this.xPos) <= this.attackrange) {
      this.attackanimationTime = chainedAnimationTimings;
      this.animation1Time = chainedAnimationTimings;

      a = true;
    }

    if (a) {
      if (attackanimationTime > 0) {



        this.attackanimationTime = this.attackanimationTime - 1;
      }

      if (this.animation1Time > 0) {
        strokeWeight(4);
        stroke(255, 220, 0);
        line(enemy.xPos + 30, enemy.yPos + 40, enemy.xPos - 30, enemy.yPos - 40);
        noStroke();
        this.animation1Time--;
        if (this.animation1Time <= this.chainedAnimationTimings) {
          this.animation2Time = this.chainedAnimationTimings;
        }
      }

      if (this.animation2Time > 0) {
        strokeWeight(4);
        stroke(255, 220, 0);
        line(enemy.xPos - 30, enemy.yPos, enemy.xPos - 60, enemy.yPos);
        noStroke();
        this.animation2Time--;
        if (this.animation2Time <= this.chainedAnimationTimings) {
          this.animation3Time = this.chainedAnimationTimings;
        }
      }

      if (this.animation3Time > 0) {
        strokeWeight(4);
        stroke(255, 220, 0);
        line(enemy.xPos + 30, enemy.yPos, enemy.xPos + 60, enemy.yPos);
        noStroke();
        this.animation3Time--;
        if (this.animation3Time <= this.chainedAnimationTimings) {
          this.animation4Time = this.chainedAnimationTimings;
        }
      }

      if (this.animation4Time > 0) {
        strokeWeight(4);
        stroke(255, 220, 0);
        line(enemy.xPos + 30, enemy.yPos - 70, enemy.xPos - 30, enemy.yPos + 70);
        noStroke();
        fill(255, 255, 0);
        circle(enemy.xPos, enemy.yPos, 15);
        this.animation4Time--;
      }
    }
  }

  public void healanimation(Warrior ally) {

    if (this.healcooldown == 0 && ally.alive() && this.alive() && abs(ally.xPos - this.xPos) <= this.attackrange) {
      this.healanimationTime = chainedHealAnimationTimings;
      this.healanimation1Time = chainedHealAnimationTimings;

      a = true;
    }

    if (a) {
      if (healanimationTime > 0) {


        this.healanimationTime = this.healanimationTime - 1;
      }

      if (this.healanimation1Time > 0) {

        this.healanimation1Time--;
        if (this.healanimation1Time <= this.chainedHealAnimationTimings) {
          this.healanimation2Time = this.chainedHealAnimationTimings;
        }
      }

      if (this.healanimation2Time > 0) {
        // Creates halo rings above healed target's head
        fill(255, 255, 0);
        ellipse(this.xPos, this.yPos - 50, 50, 20);

        fill(skyColor[0], skyColor[1], skyColor[2]);
        ellipse(this.xPos, this.yPos - 50, 30, 10);
        this.healanimation2Time--;
        if (this.healanimation2Time <= this.chainedHealAnimationTimings) {
          this.healanimation3Time = this.chainedHealAnimationTimings;
        }
      }

      if (this.healanimation3Time > 0) {
        fill(255, 255, 0);
        ellipse(this.xPos, this.yPos - 100, 100, 40);

        fill(skyColor[0], skyColor[1], skyColor[2]);
        ellipse(this.xPos, this.yPos - 100, 60, 20);
        this.healanimation3Time--;
        if (this.healanimation3Time <= this.chainedHealAnimationTimings) {
          this.healanimation4Time = this.chainedHealAnimationTimings;
        }
      }

      if (this.healanimation4Time > 0) {
        fill(255, 255, 0);
        ellipse(this.xPos, this.yPos - 175, 150, 60);

        fill(skyColor[0], skyColor[1], skyColor[2]);
        ellipse(this.xPos, this.yPos - 175, 90, 30);
        this.healanimation4Time--;
      }
    }
  }

  public void healChargeBar() {
    if (this.alive()) {
      // Heal recharge bar
      fill(135);
      rect(this.xPos - rechargebarLength / 2, yPos + 60, rechargebarLength, 15);
      fill(252, 255, 173);
      rect(this.xPos - rechargebarLength / 2, yPos + 60, rechargebarLength*(this.healMaxCooldown - this.healcooldown)/this.healMaxCooldown, 15);
    }
  }

  public void character(float x, float y) {
    if (this.alive()) {
      // Character model
      this.xPos = x;
      this.yPos = y;
      fill(modelColor[0], modelColor[1], modelColor[2]);
      circle(xPos, yPos, 40);







      //Health bar
      strokeWeight(2);
      stroke(0);
      rectMode(CORNER);
      fill(135);
      rect(xPos - healthbarLength / 2, yPos - 40, healthbarLength, 15);
      fill(0, 255, 0);
      rect(xPos - healthbarLength / 2, yPos - 40, healthbarLength*this.health/this.maxHealth, 15);

      // Attack recharge bar
      fill(135);
      rect(xPos - rechargebarLength / 2, yPos + 40, rechargebarLength, 15);
      fill(255, 0, 255);
      rect(xPos - rechargebarLength / 2, yPos + 40, rechargebarLength*(this.maxAttackCooldown - this.attackcooldown)/this.maxAttackCooldown, 15);
      noStroke();
    }
  }
}













public class SunGod extends Warrior {
  float[] modelColor = {255, 210, 0};
  float[] modelColor2 = {255, 255, 150};
  public SunGod() {
    this.health = 1;
    this.maxHealth = 1;
    this.attackdamage = 0.5;
    this.attackrange = 1500;
    this.attackanimationTime = 0;

    // Attacks once per 2 frames
    this.attackcooldown = 2;
    this.maxAttackCooldown = 2;

    this.animation1Time = 0;
    this.animation2Time = 0;
    this.animation3Time = 0;
    this.animation4Time = 0;

    this.chainedAnimationTimings = 8;


    this.xPos = 750;
    this.yPos = 400;

    this.diameter = 50;
  }

  public void attack(Warrior enemy) {
    if (this.alive() && enemy.alive() && attackcooldown == 0 && abs(enemy.xPos - this.xPos) <= this.attackrange) {

      // Sun damage ignores armor
      enemy.health = enemy.health - this.attackdamage;
      attackcooldown = 1;
    }
  }
  public void animation(Warrior enemy) {

    if (this.attackcooldown == 0 && this.alive() && enemy.alive() && abs(enemy.xPos - this.xPos) <= this.attackrange) {

      // Fires a divine sun beam (DO NOT CHANGE THESE COLORS! THERE ARE SOME HITBOXES THAT DEPEND ON DETECTING THESE COLORS)
      // IF YOU WANT TO CHANGE THESE COLORS, GO TEST THE STROKE COLOR USING THE GET() FUNCTION
      image(godWings, this.xPos - 325, this.yPos - 180);
      strokeWeight(120);
      stroke(255, 180, 2);
      line(this.xPos, this.yPos, mouseX + (mouseX - this.xPos)*1000, mouseY + (mouseY - this.yPos)*1000);
      strokeWeight(100);
      stroke(255, 253, 3);
      line(this.xPos, this.yPos, mouseX + (mouseX - this.xPos)*1000, mouseY + (mouseY - this.yPos)*1000);
      strokeWeight(60);
      stroke(255, 253, 254);
      line(this.xPos, this.yPos, mouseX + (mouseX - this.xPos)*1000, mouseY + (mouseY - this.yPos)*1000);
      noStroke();
    }
  }

  public void character(float x, float y) {
    if (this.alive()) {
      // Character model
      this.xPos = x;
      this.yPos = y;
      fill(modelColor[0], modelColor[1], modelColor[2]);
      circle(xPos, yPos, 50);

      fill(modelColor2[0], modelColor2[1], modelColor2[2]);
      arc(xPos, yPos, 50, 50, 2*PI/6, 2*PI/3);

      arc(xPos, yPos, 50, 50, PI, 4*PI/3);
      arc(xPos, yPos, 50, 50, 5*PI/3, 2*PI);

      fill(255);
      circle(xPos, yPos, 37.5);




      //Health bar (the Sun Avatar's model is a bit larger so I moved the bar upward)
      strokeWeight(2);
      stroke(0);
      rectMode(CORNER);
      fill(135);
      rect(xPos - healthbarLength / 2, yPos - 50, healthbarLength, 15);
      fill(0, 255, 0);
      rect(xPos - healthbarLength / 2, yPos - 50, healthbarLength*this.health/this.maxHealth, 15);

      // Attack recharge bar
      fill(135);
      rect(xPos - rechargebarLength / 2, yPos + 40, rechargebarLength, 15);
      fill(255, 0, 255);
      rect(xPos - rechargebarLength / 2, yPos + 40, rechargebarLength*(this.maxAttackCooldown - this.attackcooldown)/this.maxAttackCooldown, 15);
      noStroke();
    }
  }
}













public class Wizard extends Warrior {
  float[] modelColor = {200, 0, 255};
  public Wizard() {
    this.health = 40;
    this.maxHealth = 40;
    this.attackdamage = 10;
    this.attackrange = 250;
    this.attackanimationTime = 0;

    this.animation1Time = 0;
    this.animation2Time = 0;
    this.animation3Time = 0;
    this.animation4Time = 0;

    this.chainedAnimationTimings = 8;
  }


  public void animation(Warrior enemy) {

    if (this.attackcooldown == 0 && enemy.alive() && this.alive() && abs(enemy.xPos - this.xPos) <= this.attackrange) {
      this.attackanimationTime = chainedAnimationTimings;
      this.animation1Time = chainedAnimationTimings;

      a = true;
    }

    if (a) {
      if (attackanimationTime > 0) {
        // Explosive spark between you and target MAYBE WE SHOULD SAVE THIS ANIMATION FOR EXPLOSIVE DAMAGE


        this.attackanimationTime = this.attackanimationTime - 1;
      }

      if (this.animation1Time > 0) {
        fill(255, 100, 0);
        // The coordinate on the circle makes it so that the fireball hits the edge of the target closest to you
        /*
        We divide by the absolute value of the difference between the two x coordinates, which makes it so that
         the fireball won't move when our character moves
         */
        circle(enemy.xPos + 10*(this.xPos - enemy.xPos)/abs(this.xPos - enemy.xPos), enemy.yPos + (this.yPos - enemy.yPos)/4, 250);
        this.animation1Time--;
        if (this.animation1Time <= this.chainedAnimationTimings) {
          this.animation2Time = this.chainedAnimationTimings;
        }
      }

      if (this.animation2Time > 0) {
        fill(255, 0, 0);
        circle(enemy.xPos + 10*(this.xPos - enemy.xPos)/abs(this.xPos - enemy.xPos), enemy.yPos + (this.yPos - enemy.yPos)/4, 400);
        this.animation2Time--;
        if (this.animation2Time <= this.chainedAnimationTimings) {
          this.animation3Time = this.chainedAnimationTimings;
        }
      }

      if (this.animation3Time > 0) {
        fill(255, 255, 0);
        circle(enemy.xPos + 10*(this.xPos - enemy.xPos)/abs(this.xPos - enemy.xPos), enemy.yPos + (this.yPos - enemy.yPos)/4, 150);
        this.animation3Time--;
        if (this.animation3Time <= this.chainedAnimationTimings) {
          this.animation4Time = this.chainedAnimationTimings;
        }
      }

      if (this.animation4Time > 0) {
        fill(255);
        circle(enemy.xPos + 10*(this.xPos - enemy.xPos)/abs(this.xPos - enemy.xPos), enemy.yPos + (this.yPos - enemy.yPos)/4, 100);
        this.animation4Time--;
      }
    }
  }
  public void character(float x, float y) {
    if (this.alive()) {
      // Character model
      this.xPos = x;
      this.yPos = y;
      fill(modelColor[0], modelColor[1], modelColor[2]);
      circle(xPos, yPos, 40);







      //Health bar
      strokeWeight(2);
      stroke(0);
      rectMode(CORNER);
      fill(135);
      rect(xPos - healthbarLength / 2, yPos - 40, healthbarLength, 15);
      fill(0, 255, 0);
      rect(xPos - healthbarLength / 2, yPos - 40, healthbarLength*this.health/this.maxHealth, 15);

      // Attack recharge bar
      fill(135);
      rect(xPos - rechargebarLength / 2, yPos + 40, rechargebarLength, 15);
      fill(255, 0, 255);
      rect(xPos - rechargebarLength / 2, yPos + 40, rechargebarLength*(this.maxAttackCooldown - this.attackcooldown)/this.maxAttackCooldown, 15);
      noStroke();
    }
  }
}










// SETUP AND DRAW BELOW



Wizard wizard1 = new Wizard();
Wizard wizard2 = new Wizard();

Vampire vampire1 = new Vampire();
Vampire vampire2 = new Vampire();

Defender defender1 = new Defender();
Defender defender2 = new Defender();

Healer healer1 = new Healer();
Healer healer2 = new Healer();

Warrior warrior1 = new Warrior();
Warrior warrior2 = new Warrior();

Lancer lancer1 = new Lancer();
Lancer lancer2 = new Lancer();

Knight knight1 = new Knight();
Knight knight2 = new Knight();

SunGod sunavatar1 = new SunGod();


Warrior hero1;
Warrior enemy1;
//Defender enemy1 = defender2;
//Healer enemy1 = healer2;
//Warrior enemy1 = warrior2;
//Wizard enemy1 = wizard2;
//Lancer enemy1 = lancer2;
//Vampire enemy1 = vampire2;










boolean hero1attacking = false;


boolean setupConditions = true;





void draw() {

  if (heroSelection) {

    background(0);

    fill(0, 255, 255);
    rect(0, 0, width, height / 2);

    fill(0, 255, 0);
    rect(0, height / 2, width, height);

    // Weird brown-ish color
    fill(209, 174, 105);
    rect(width / 2 - 500, height / 2 - 200, 1000, 400);

    textAlign(CENTER, CENTER);
    fill(255);
    textSize(80);
    text("MEDIEVAL BATTLE", width / 2, height / 2);
    textSize(30);
    text("Select class to begin!", width / 2, height / 2 + 120);


    fill(255);
    //Knight

    if (areaHitbox(width / 2 - 300, height / 2 + 230, 150, 50)) {
      textSize(15);
      fill(0);
      text("With the help of a rejuvenation spell from his master - a powerful Wizard - the Knight has spent centuries protecting his kingdom's royal family. Legends say that this mythical Knight strikes faster than the eye can see.", width - 350, height / 2 - 100, 300, 500);
    }

    //Defender
    if (areaHitbox(width / 2 - 150, height / 2 + 230, 150, 50)) {
      textSize(15);
      fill(0);
      text("Blindly rushing into the collapsing cave that had trapped his King, the Defender was crushed by thousands of tons of rock. As gratitude for his undying loyalty, the King, with the help of a fellow Wizard, brought the Defender back to life, infused with the might of a hundred mountains. One of the Defender's strikes against the ground can generate enourmous earthquakes.", width - 350, height / 2 - 100, 300, 500);
    }

    //Vampire
    if (areaHitbox(width / 2, height / 2 + 230, 150, 50)) {
      textSize(20);
      fill(0);
      text("The Vampire is an ancient being that stalked the Earth far before the first man set foot on the planet. Driven insane by the billions of years spent deprived of sustenance, he now eternally hungers for blood, growing in strength with every drop. The Vampire can absorb the life essence of his enemies, healing himself.", width - 350, height / 2 - 100, 300, 500);
    }

    //Lancer
    if (areaHitbox(width / 2 + 150, height / 2 + 230, 150, 50)) {
      textSize(20);
      fill(0);
      text("A recent addition to his kingdom's royal army, the brave, young Lancer will go any lengths to prove himself worthy, even if it means endangering his own life. He wields a mythical lance which imbues him with god-like strength, and will pull enemies toward himself if it means protecting his allies.", width - 350, height / 2 - 100, 300, 500);
    }
    //Healer
    if (areaHitbox(width / 2 - 235, height / 2 + 280, 150, 50)) {
      textSize(20);
      fill(0);
      text("An angel descended from the heavens, the Healer seeks to end the bloodshed. She is haunted by the endless influx of new spirits appearing on heaven's doorstep, and swears that an end must be put to the violence. While she possesses the power to level entire cities, she holds back her strength and focuses more on healing.", width - 350, height / 2 - 100, 300, 500);
    }

    //Wizard
    if (areaHitbox(width / 2 - 85, height / 2 + 280, 130, 50)) {
      textSize(15);
      fill(0);
      text("A mortal body assimilated by a mystical spirit, the Wizard possesses the power to manipulate matter itself. He traverses across the dimensions, seeking to purge evil from this universe, and saw our medieval battlegrounds as an opportunity to gather helpers for his mission. The wizard's primary choice of weaponry are his hands, which can release blasts of nuclear energy.", width - 350, height / 2 - 100, 300, 500);
    }

    //Sun Avatar
    if (areaHitbox(width / 2 + 45, height / 2 + 280, 150, 50)) {
      textSize(15);
      fill(0);
      text("The God of the Sun is a timeless entity possessing infinite power. While he oversees the infinite array of universes including our own, His very presence in ours would obliterate our space-time fabric. Thus, He channels his power into an avatar to carry out his will in this universe. The avatar is fragile from the vast energy harnessed within itself; so fragile that a single strike is enough to destroy the avatar. Act wise, and you can unleash tremendous damage upon your foes.", width - 350, height / 2 - 100, 300, 500);
    }

    fill(0);
    textSize(20);
    text("Press:", width / 2 - 400, height / 2 + 275);

    text("1 - Knight     2 - Defender     3 - Vampire     4 - Lancer", width / 2, height / 2 + 250);
    text("5 - Healer     6 - Wizard     7 - Sun Avatar", width / 2, height / 2 + 300);




    if (keyPressed) {
      // I would use a switch statement but it doesn't seem to work very well (problems with initializations)
      if (key == '1') {
        hero1 = knight1;
        heroSelection = false;
        enemySelection = true;
      } else if (key == '2') {
        hero1 = defender1; 
        heroSelection = false;
        enemySelection = true;
      } else if (key == '3') {
        hero1 = vampire1; 
        heroSelection = false;
        enemySelection = true;
      } else if (key == '4') {
        hero1 = lancer1;
        heroSelection = false;
        enemySelection = true;
      } else if (key == '5') {
        hero1 = healer1;
        heroSelection = false;
        enemySelection = true;
      } else if (key == '6') {
        hero1 = wizard1;
        heroSelection = false;
        enemySelection = true;
      } else if (key == '7') {
        hero1 = sunavatar1;
        heroSelection = false;
        enemySelection = true;
      }
    }
    return;
  }

  if (enemySelection) {

    background(0);

    fill(0, 255, 255);
    rect(0, 0, width, height / 2);

    fill(0, 255, 0);
    rect(0, height / 2, width, height);

    // Weird brown-ish color
    fill(209, 174, 105);
    rect(width / 2 - 500, height / 2 - 200, 1000, 400);

    textAlign(CENTER, CENTER);
    fill(255);
    textSize(80);
    text("MEDIEVAL BATTLE", width / 2, height / 2);
    textSize(30);
    text("Select your opponent!", width / 2, height / 2 + 120);

    fill(0);
    textSize(20);
    text("Press:", width / 2 - 400, height / 2 + 275);

    text("Q - Knight     W - Defender     E - Vampire     R - Lancer", width / 2, height / 2 + 250);
    text("T - Healer     Y - Wizard", width / 2, height / 2 + 300);


    if (keyPressed) {
      if (key == 'q' || key == 'Q') {
        enemy1 = knight2;
        enemySelection = false;
      } else if (key == 'w' || key == 'W') {
        enemy1 = defender2; 
        enemySelection = false;
      } else if (key == 'e' || key == 'E') {
        enemy1 = vampire2; 
        enemySelection = false;
      } else if (key == 'r' || key == 'E') {
        enemy1 = lancer2;
        enemySelection = false;
      } else if (key == 't' || key == 'T') {
        enemy1 = healer2;
        enemySelection = false;
      } else if (key == 'y' || key == 'Y') {
        enemy1 = wizard2;
        enemySelection = false;
      }
    }
    return;
  }

  // Everything that should only be run once at the very start goes in this loop
  if (setupConditions) {

    setupConditions = false;

    // Default starting position for the hero
    hero1.xPos = 900;
    hero1.yPos = 400;
  }
  background(255);



  // Grassy plains background
  rectMode(CORNERS);
  noStroke();
  fill(0, 255, 0);
  rect(0, height / 2, width, height);
  fill(skyColor[0], skyColor[1], skyColor[2]);
  rect(0, 0, width, height / 2);

  fill(hero1.modelColor[0], hero1.modelColor[1], hero1.modelColor[2]);

  // This triangle hovers above the hero's head to indicate where you are
  if (hero1.alive()) {
    fill(0, 255, 0);
    triangle(hero1.xPos, hero1.yPos - 60, hero1.xPos - 20, hero1.yPos - 95, hero1.xPos + 20, hero1.yPos - 95);
  }

  hero1.character(hero1.xPos, hero1.yPos);
  hero1.attackrecharge();
  hero1.healChargeBar();

  fill(enemy1.modelColor[0], enemy1.modelColor[1], enemy1.modelColor[2]);

  enemy1.character(enemy1.xPos, enemy1.yPos);
  enemy1.attackrecharge();
  enemy1.healChargeBar();
  // The actual name of the class is sketch_210618a$Healer but that number in the middle
  // changes sometimes, so it's best to substring to get rid of it entirely and just look
  // to see if it's part of the healer class
  if (enemy1.getClass().getName().substring(15).equals("Healer")) {
    enemy1.healrecharge();
  }
  if (hero1.getClass().getName().substring(15).equals("Healer")) {
    hero1.healrecharge();
  }






  /*
  THE FOLLOWING CODE IS FOR ATTACKING WITH THE MAIN CHARACTER. IT'S SUPPOSED TO MAKE IT SO THAT WHEN YOU ATTACK, THE ANIMATION PLAYS FOR A SET PERIOD
   OF TIME, BEFORE ENDING, AND THEN IT WAITS FOR YOUR NEXT ATTACK. I HAVE NO IDEA HOW THE HELL THIS CODE IS WORKING BUT IF ANY BUGS POP UP, IT'S BECAUSE OF
   THIS FOLLOWING CODE
   */


  if (mousePressed) {
    // Ensures that if you attempt to attack outside the range, it won't automatically attack when you walk back in range
    // It also ensures that, if you click when the attack timer is still recharging, your character won't automatically attack when it finishes recharging

    if (hero1.getClass().getName().substring(15).equals("SunGod")) {
      hero1.animation(enemy1);
      /* 
       colorHitbox checks to see if a certain color is present at the enemy's hitbox edges
       
       Note that while the actual hitbox (for point-and-click attacks that detect the mouse coordinates) of the enemy is 40x40 pixels, I made the color detection hitbox 36x36. This is because the enemy is a circle
       and the hitbox is a square, so I should make the hitbox-square width smaller than the circle width (otherwise the corners of the square hitbox
       protrude too far out of the circle region and it will seem like the enemy is getting hit by nothing
       |```/````````\```|
       |``/          \``|
       |`/            \`|
       ||              ||
       ||              ||
       | \            / |
       |  \          /  |
       |___\________/___|
       
       Look how these corners are too far out; that's why I made the square hitbox smaller than what the actual hitbox should be
       
       
       */
      if (abs(enemy1.xPos - hero1.xPos) <= hero1.attackrange && hero1.attackcooldown == 0 && enemy1.colorHitbox(enemy1.xPos - 18, enemy1.yPos - 18, 36, 36, -765, -19454, -514)) {
        hero1attacking = true;
        //print("Enemy health: " + enemy1.health + " HP");
      }
    } else {
      if (abs(enemy1.xPos - hero1.xPos) <= hero1.attackrange && hero1.attackcooldown == 0 && enemy1.inHitbox(50, 50, enemy1.xPos, enemy1.yPos)) {
        hero1attacking = true;
        //print("Enemy health: " + enemy1.health + " HP");
      }
    }
  }

  if (hero1attacking) {
    hero1.animation(enemy1);
    hero1.attack(enemy1);

    if (hero1.attackcooldown == hero1.maxAttackCooldown / 2) {
      hero1attacking = false;
    }
  } else {
    hero1attacking = false;
  }








  if (keyPressed) {
    if (hero1.xPos - hero1.diameter / 2 > 0) {
      if (key == 'a' || key == 'A') {
        hero1.xPos = hero1.xPos - 1;
      }
    }
    if (hero1.xPos + hero1.diameter / 2 < width) {
      if (key == 'd' || key == 'D') {
        hero1.xPos = hero1.xPos + 1;
      }
    }
  }



  if (enemy1.xPos > hero1.xPos + enemy1.attackrange && enemy1.alive() && hero1.alive()) {
    enemy1.xPos = enemy1.xPos - 0.5;
  } 

  if (enemy1.xPos < hero1.xPos - enemy1.attackrange && enemy1.alive() && hero1.alive()) {
    enemy1.xPos = enemy1.xPos + 0.5;
  }

  if (enemy1.xPos <= hero1.xPos + enemy1.attackrange && enemy1.xPos >= hero1.xPos - enemy1.attackrange && enemy1.alive() && hero1.alive()) {
    strokeWeight(3);
    enemy1.animation(hero1);
    enemy1.attack(hero1);
  } 

  if (enemy1.getClass().getName().substring(15).equals("Healer") && enemy1.alive()) {
    //print("sdfsfsdf");
    enemy1.healanimation(enemy1);
    enemy1.healspell(enemy1);
  }
  if (hero1.getClass().getName().substring(15).equals("Healer") && hero1.alive()) {
    hero1.healanimation(hero1);
    hero1.healspell(hero1);
  }

  if (!(enemy1.alive()) && hero1.alive() && hero1.getClass().getName().substring(15).equals("SunGod")) {
    textSize(50);
    text("Wow, what a big accomplishment that", width / 2, height / 2 - 150);
    text("you won with the most stupidly powerful class", width / 2, height / 2 - 90);
  } else if (!(enemy1.alive()) && hero1.alive()) {
    textSize(100);
    text("YOU WIN!", width / 2, height / 2 - 150);
  } else if (enemy1.alive() && (!(hero1.alive()))) {
    textSize(100);
    text("DEFEAT", width / 2, height / 2 - 150);
  }
}

boolean areaHitbox(float topleft, float topright, float hWidth, float vHeight) {
  if (mouseX > topleft && mouseX < topleft + hWidth && mouseY > topright && mouseY < topright + vHeight) {
    return true;
  } else {
    return false;
  }
}
